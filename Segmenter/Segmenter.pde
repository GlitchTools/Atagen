/*  interactive multidirectional pixelsorter
    
    pixel directionality is determined by ranges that are
    split from multiples of brightness threshold. 
    (eg. thresh@64: 0-64 sorts up, 65-127 sorts right, & so on)
    
    sorting can be modulated live using controls,
    or sequenced using a combination of cycle + dswitch options.
    sorts can be bound by clicking and dragging to select area.
    
    please note looping sorts are possible/likely/desirable;
    you may need to shuffle threshold during sort to 'complete'.
    enable choice option for pattern generation/broken sort.
    
    rob mac 2014.
    
    
    control:    key:

    start/stop    q
    
    thresh down   w
    thresh up     e
    
    vert on/off   a
    hori on/off   s
    diag on/off   d  
    reverse       r
    
    set bounds    left click->drag
    reset bounds  right click
    
    capture       enter/return
    
*/

// user options
String fileName = "smilenorcry.jpg";
int thres = 64; //            threshold
int mode = 0; //              lighter/darker, essentially 'reverses' the sort
boolean diag = true; //       diagonal/straight
boolean v = true; //          use to select initial direction.
boolean h = true; //          if cycling, use V=true H=false.
int cycle = 0; //             cycle V/H+diag each X runs - 0 off
boolean dswitch = false; //   enable cycling 'diag'
boolean choice = false; //    ignores most options, makes cool things.

PImage img;
int[] bounds = {0,0,0,0};
boolean running = false;
int curCy = 0;
void setup() {
  img = loadImage(fileName);
  size(img.width, img.height);
  image(img, 0, 0);
  loadPixels();
  colorMode(HSB);
  resetBounds();
  noLoop();
}

void draw() {
  if (cycle > 0) {
    if (curCy == cycle) {
      if (v) {
        v=false;
        h=true;
      } else if (h) {
        h=false;
        v=true;
        if (dswitch) diag = (diag) ? false : true;
      }

      curCy = 0;
    } else {
      curCy++;
    }
  }  
  for (int j = bounds[1]; j < bounds[3]-1; j++) {
    for (int k = bounds[0]; k < bounds[2]-1; k++) {
      float bright = brightness(get(k, j));
      color c;
      if (!choice) {
        if (diag) {
          if (mode == 0) {
            if (h && bright < abs(thres)&& k > bounds[0]+1 && j > bounds[1]+1 && (bright < brightness(pixels[k-1+((j-1)*width)]))) {
              swap(k, j, k-1, j-1);
            } else if (v && bright < abs(thres*2) && j > bounds[1]+1 && k < bounds[2]-1 && (bright < brightness(pixels[k+1+((j-1)*width)]))) {
              swap(k, j, k+1, j-1);
            } else if (h && bright < abs(thres*3) && k < bounds[2]-1 && j < bounds[3]-1 && (bright < brightness(pixels[k+1+((j+1)*width)]))) {
              swap(k, j, k+1, j+1);
            } else if (v && k > bounds[0] && j < bounds[3]-1 && (bright < brightness(pixels[k-1+((j+1)*width)]))) {
              swap(k, j, k-1, j+1);
            }
          } else { // mode
            if (h && bright < abs(thres)&& k > bounds[0] && j > bounds[1] && (bright > brightness(pixels[k-1+((j-1)*width)]))) {
              swap(k, j, k-1, j-1);
            } else if (v && bright < abs(thres*2) && j > bounds[1] && k < bounds[2]-1 && (bright > brightness(pixels[k+1+((j-1)*width)]))) {
              swap(k, j, k+1, j-1);
            } else if (h && bright < abs(thres*3) && k < bounds[2]-1 && j < bounds[3]-1 && (bright > brightness(pixels[k+1+((j+1)*width)]))) {
              swap(k, j, k+1, j+1);
            } else if (v && k > bounds[0] && j < bounds[3]-1 && (bright > brightness(pixels[k-1+((j+1)*width)]))) {
              swap(k, j, k-1, j+1);
            }
          } // mode
        }//diag

        else {
          if (mode == 0) {
            if (h && bright < abs(thres)&& k > bounds[0] && (bright < brightness(get(k-1, j)))) {
              swap(k, j, k-1, j);
            } else if (v && bright < abs(thres*2) && j > bounds[1] && (bright < brightness(get(k, j-1)))) {
              swap(k, j, k, j-1);
            } else if (h && bright < abs(thres*3) && k < bounds[2]-1 && (bright < brightness(get(k+1, j)))) {
              swap(k, j, k+1, j);
            } else if (v && k > bounds[0] && j < bounds[3]-1 && (bright < brightness(get(k, j+1)))) {
              swap(k, j, k, j+1);
            }
          } else { // mode
            if (h && bright < abs(thres)&& k > bounds[0] && (bright > brightness(get(k-1, j)))) {
              swap(k, j, k-1, j);
            } else if (v && bright < abs(thres*2) && j > bounds[1] && (bright > brightness(get(k, j-1)))) {
              swap(k, j, k, j-1);
            } else if (h && bright < abs(thres*3) && k < bounds[2]-1 && (bright > brightness(get(k+1, j)))) {
              swap(k, j, k+1, j);
            } else if (v && k > bounds[0] && j < bounds[3]-1 && (bright > brightness(get(k, j+1)))) {
              swap(k, j, k, j+1);
            }
          } // mode
        } // diag
      } else { //choice
           //weirdo pattern mode
          if (mode == 0) {
          if (bright < thres && k-1+((j-1)*width) > 0) {
            swap(k, j, k-1, j-1);
          } else if (bright < abs(thres*2) && k+1+((j-1)*width) > 0) {
            swap(k, j, k+1, j-1);
          } else if (bright < abs(thres*3) && k+1+((j+1)*width) < width*height) {
            swap(k, j, k+1, j+1);
          } else if (k-1+((j+1)*width) < width*height) {
            swap(k, j, k-1, j+1);
          }
        } else { // mode
          if (bright > abs(thres*3) && k-1+((j-1)*width) > 0) {
            if (k-1+((j-1)*width) > 0) {
              swap(k, j, k-1, j-1);
            }
          } else
            if (bright > abs(thres*2) && k+1+((j-1)*width) > 0) {
            if (k+1+((j-1)*width) > 0) {
              swap(k, j, k+1, j-1);
            }
          } else
            if (bright < thres  && k+1+((j+1)*width) < width*height) {
            swap(k, j, k+1, j+1);
          } else if (k-1+((j+1)*width) < width*height) {
            swap(k, j, k-1, j+1);
          }
        } // mode
      }//choice
    }//hori loop
  }//vert loop
  updatePixels();
}

void swap(int x, int y, int xc, int yc) {
//  if (x+(y*width) < width*height && xc+(yc*width) < width*height && xc+(yc*width) > -1) {
    color c = pixels[x+(y*width)];
    pixels[x+(y*width)] =  pixels[xc+(yc*width)];
    pixels[xc+((yc)*width)] = c;
//  }
}

