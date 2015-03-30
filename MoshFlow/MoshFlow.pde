// moshflow by rob mac, 2014
// q to toggle moshing on/off
// r to toggle refreshing slow grids
// w / e to adjust prediction time
// s / d to adjust grid size
// a / z to adjust mosh movement threshold

// based on Optical Flow 2010/05/28
// by Hidetoshi Shimodaira shimo@is.titech.ac.jp 2010 GPL


//video params
int wscreen=448;
int hscreen=336;
int gs=10; // grid step (pixels)
float predsec=0.3; // prediction time (sec): larger for longer vector
String fileName = "5468D88E.mp4";
boolean mosh = false; // mosh effect
boolean overflow = false; // redraw slow vectors
int fps = 25;
float thresh = 0.5;
boolean shift = true; // broken hue shift moshed areas

// grid parameters
int as=gs*2;  // window size for averaging (-as,...,+as)
int gw=wscreen/gs;
int gh=hscreen/gs;
int gs2=gs/2;
float df=predsec*fps;
boolean gsup = false;
int newgs=gs;
float tdiv=5;

// regression vectors
float[] fx, fy, ft;
int fm=3*9; // length of the vectors

// regularization term for regression
float fc=pow(12, 8); // larger values for noisy video

// smoothing parameters
float wflow=0.1; // smaller value for longer smoothing

// internally used variables
float ar, ag, ab; // used as return value of pixave
float[] dtr, dtg, dtb; // differentiation by t (red,gree,blue)
float[] dxr, dxg, dxb; // differentiation by x (red,gree,blue)
float[] dyr, dyg, dyb; // differentiation by y (red,gree,blue)
float[] par, pag, pab; // averaged grid values (red,gree,blue)
float[] flowx, flowy; // computed optical flow
float[] sflowx, sflowy; // slowly changing version of the flow

import processing.video.*;
Movie video;
//PImage video;
void setup() {
  // screen and video
  size(wscreen, hscreen); 
  video = new Movie(this, fileName);
  video.loop();
  // draw
  rectMode(CENTER);
  ellipseMode(CENTER);

  // arrays
  par = new float[gw*gh];
  pag = new float[gw*gh];
  pab = new float[gw*gh];
  dtr = new float[gw*gh];
  dtg = new float[gw*gh];
  dtb = new float[gw*gh];
  dxr = new float[gw*gh];
  dxg = new float[gw*gh];
  dxb = new float[gw*gh];
  dyr = new float[gw*gh];
  dyg = new float[gw*gh];
  dyb = new float[gw*gh];
  flowx = new float[gw*gh];
  flowy = new float[gw*gh];
  sflowx = new float[gw*gh];
  sflowy = new float[gw*gh];
  fx = new float[fm];
  fy = new float[fm];
  ft = new float[fm];
  //  vline = new color[wscreen];
}


// calculate average pixel value (r,g,b) for rectangle region
void pixave(int x1, int y1, int x2, int y2) {
  float sumr, sumg, sumb;
  color pix;
  int r, g, b;
  int n;

  if (x1<0) x1=0;
  if (x2>=wscreen) x2=wscreen-1;
  if (y1<0) y1=0;
  if (y2>=hscreen) y2=hscreen-1;

  sumr=sumg=sumb=0.0;
  for (int y=y1; y<=y2; y++) {
    for (int i=wscreen*y+x1; i<=wscreen*y+x2; i++) {
      pix=video.pixels[i];
      b=pix & 0xFF; // blue
      pix = pix >> 8;
      g=pix & 0xFF; // green
      pix = pix >> 8;
      r=pix & 0xFF; // red
      // averaging the values
      sumr += r;
      sumg += g;
      sumb += b;
    }
  }
  n = (x2-x1+1)*(y2-y1+1); // number of pixels
  // the results are stored in static variables
  ar = sumr/n;
  ag=sumg/n;
  ab=sumb/n;
}

// extract values from 9 neighbour grids
void getnext9(float x[], float y[], int i, int j) {
  y[j+0] = x[i+0];
  y[j+1] = x[i-1];
  y[j+2] = x[i+1];
  y[j+3] = x[i-gw];
  y[j+4] = x[i+gw];
  y[j+5] = x[i-gw-1];
  y[j+6] = x[i-gw+1];
  y[j+7] = x[i+gw-1];
  y[j+8] = x[i+gw+1];
}

// solve optical flow by least squares (regression analysis)
void solveflow(int ig) {
  float xx, xy, yy, xt, yt;
  float a, u, v, w;

  // prepare covariances
  xx=xy=yy=xt=yt=0.0;
  for (int i=0; i<fm; i++) {
    xx += fx[i]*fx[i];
    xy += fx[i]*fy[i];
    yy += fy[i]*fy[i];
    xt += fx[i]*ft[i];
    yt += fy[i]*ft[i];
  }

  // least squares computation
  a = xx*yy - xy*xy + fc; // fc is for stable computation
  u = yy*xt - xy*yt; // x direction
  v = xx*yt - xy*xt; // y direction

  // write back
  flowx[ig] = -2*gs*u/a; // optical flow x (pixel per frame)
  flowy[ig] = -2*gs*v/a; // optical flow y (pixel per frame)
}

void draw() {
  if (video.available()) {
    // video capture
    video.read();
    video.loadPixels();
    // draw image
    if (!mosh) set(0, 0, video);

    // 1st sweep : differentiation by time
    for (int ix=0; ix<gw; ix++) {
      int x0=ix*gs+gs2;
      for (int iy=0; iy<gh; iy++) {
        int y0=iy*gs+gs2;
        int ig=iy*gw+ix;
        // compute average pixel at (x0,y0)
        pixave(x0-as, y0-as, x0+as, y0+as);
        // compute time difference
        dtr[ig] = ar-par[ig]; // red
        dtg[ig] = ag-pag[ig]; // green
        dtb[ig] = ab-pab[ig]; // blue
        // save the pixel
        par[ig]=ar;
        pag[ig]=ag;
        pab[ig]=ab;
      }
    }

    // 2nd sweep : differentiations by x and y
    for (int ix=1; ix<gw-1; ix++) {
      for (int iy=1; iy<gh-1; iy++) {
        int ig=iy*gw+ix;
        // compute x difference
        dxr[ig] = par[ig+1]-par[ig-1]; // red
        dxg[ig] = pag[ig+1]-pag[ig-1]; // green
        dxb[ig] = pab[ig+1]-pab[ig-1]; // blue
        // compute y difference
        dyr[ig] = par[ig+gw]-par[ig-gw]; // red
        dyg[ig] = pag[ig+gw]-pag[ig-gw]; // green
        dyb[ig] = pab[ig+gw]-pab[ig-gw]; // blue
      }
    }

    // 3rd sweep : solving optical flow
    for (int ix=1; ix<gw-1; ix++) {
      int x0=ix*gs+gs2;
      for (int iy=1; iy<gh-1; iy++) {
        int y0=iy*gs+gs2;
        int ig=iy*gw+ix;

        // prepare vectors fx, fy, ft
        getnext9(dxr, fx, ig, 0); // dx red
        getnext9(dxg, fx, ig, 9); // dx green
        getnext9(dxb, fx, ig, 18);// dx blue
        getnext9(dyr, fy, ig, 0); // dy red
        getnext9(dyg, fy, ig, 9); // dy green
        getnext9(dyb, fy, ig, 18);// dy blue
        getnext9(dtr, ft, ig, 0); // dt red
        getnext9(dtg, ft, ig, 9); // dt green
        getnext9(dtb, ft, ig, 18);// dt blue

        // solve for (flowx, flowy) such that
        // fx flowx + fy flowy + ft = 0
        solveflow(ig);

        // smoothing
        sflowx[ig]+=(flowx[ig]-sflowx[ig])*wflow;
        sflowy[ig]+=(flowy[ig]-sflowy[ig])*wflow;
      }
    }


    // 4th sweep : draw the flow
    if (mosh) {
      loadPixels();
      for (int ix=0; ix<gw; ix++) {
        int x0=ix*gs+gs2;
        for (int iy=0; iy<gh; iy++) {
          int y0=iy*gs+gs2;
          int ig=iy*gw+ix;

          float u=df*sflowx[ig];
          float v=df*sflowy[ig];

          // draw the line segments for optical flow
          float a=sqrt(u*u+v*v);
          int xPos = x0+floor(u);
          int yPos = y0+floor(v);
          if (a>=thresh) { // draw only if the length >=2.0
            for (int x = 0; x < gs; x++) {
              for (int y = 0; y < gs; y++) {
                int off = (shift) ? int(a*1200) : 0;
                //pixel copying goes here
                try {
                  pixels[x+xPos+((y+yPos+floor(v))*width)] = pixels[x+x0+((y+y0)*width)] + off;
                }
                catch(Exception e) {
                }
              }
            }
          } else if (a<((thresh/4)) && overflow) {
            for (int x = 0; x < gs; x++) {
              for (int y = 0; y < gs; y++) {
                //pixel copying goes here
                try {
                  pixels[x+xPos+((y+yPos+floor(v))*width)] = video.pixels[x+x0+((y+y0)*width)];
                }
                catch(Exception e) {
                }
              }
            }
          }
        }
      }
      updatePixels();
    }
    if (gsup) resetGrid();
  } //video available
} //draw

void keyPressed() {
  switch(key) {
  case 'q':
  case 'Q':
    mosh=!mosh;
    break;

  case 'w':
  case 'W':
    predsec = (predsec > 0.1) ? predsec-0.1 : predsec;
    println("Prediction at " + nf(predsec, 1, 1) + " seconds.");
    break;

  case 'e':
  case 'E':
    predsec = (predsec < 5.0) ? predsec+0.1 : predsec;
    println("Prediction at " + nf(predsec, 1, 1) + " seconds.");
    break;

  case 's':
  case 'S':
    newgs = (gs > 2) ? gs-1 : gs;
    gsup=true;
    println("Grid at " + gs + " px.");
    break;

  case 'd':
  case 'D':
    newgs = (gs < width/4) ? gs+1 : gs;
    gsup=true;
    println("Grid at " + gs + " px.");
    break;

  case 'a':
  case 'A':
    updateThresh(1);
    println("Movement threshold at " + thresh + " px. (Divisor: " + tdiv + ").");
    break;

  case 'z':
  case 'Z':
    updateThresh(0);
    println("Movement threshold at " + thresh + " px. (Divisor: " + tdiv + ").");
    break;

  case 'r':
  case 'R':
    overflow=!overflow;
    break;
  }
}

void updateThresh(int dir) {
  if (gs > 5) {
    if (dir==0) tdiv++;
    if (dir==1) tdiv =(tdiv > 1)?tdiv-1:tdiv;
    thresh = gs/tdiv;
  } else {
    if (dir==1) thresh=(thresh>1)?thresh+1:(thresh>0.1)?thresh+0.1:(thresh>0.01)?thresh+0.01:thresh+0.001;
    if (dir==0) thresh=(thresh>1)?thresh-1:(thresh>0.1)?thresh-0.1:(thresh>0.01)?thresh-0.01:thresh; 
    if (dir==2) thresh=1;
  }
}

void resetGrid() {
  gs=newgs;
  as=gs*2; 
  gw=wscreen/gs;
  gh=hscreen/gs;
  gs2=gs/2;
  df=predsec*fps;
  par = new float[gw*gh];
  pag = new float[gw*gh];
  pab = new float[gw*gh];
  dtr = new float[gw*gh];
  dtg = new float[gw*gh];
  dtb = new float[gw*gh];
  dxr = new float[gw*gh];
  dxg = new float[gw*gh];
  dxb = new float[gw*gh];
  dyr = new float[gw*gh];
  dyg = new float[gw*gh];
  dyb = new float[gw*gh];
  flowx = new float[gw*gh];
  flowy = new float[gw*gh];
  sflowx = new float[gw*gh];
  sflowy = new float[gw*gh];
  updateThresh(2);
  gsup = false;
}
