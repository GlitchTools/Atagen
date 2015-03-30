// Original: http://www.openprocessing.org/sketch/145401
// adaptation to images, Tomasz Sulej, generateme.blog@gmail.com
// sequencing, alternate modes, general clutter - rob mac.

// put image filename here:
String imagefilename = "fractall.jpg";
// detail per iteration
int n=10000;
// change draw/color modes per iteration, or only on mouseclick?
boolean itswitch = true; 

/* drawModes are sequenceable, delineated by commas
 modes are as follows:
 NOR    normal
 INV    inverted sin/cos
 LIN    linear
 QU1    quantised 1
 QU2    quantised 2
 eg.
 LIN, NOR - will cycle linear & normal draw modes
 QU2 - will use only quantise 2 draw mode
 any number of modes in any order is acceptable
 some draw/color combos may create noise on first iteration
 */
int[] drawModes = { 
  QU2
};

/* color modes work similarly. c1 is x, c2 is y. mismatched lengths are acceptable
 modes are:
 BRI    brightness
 SAT    saturation
 HUE    hue
 DRK    inverted brightness (dark)
 RED    red
 BLU    blue
 GRN    green
 */

int[] c1s = {
  DRK, BRI
};
int[] c2s = {
  BRI, DRK
};

/////////////////////////////////////


float [] cx=new float[n];
float [] cy=new float[n];

PImage img;
int len;
int mode_ind, c1_ind, c2_ind = 0;
int mode, c1mode, c2mode;


void setup() {
  img = loadImage(imagefilename);

  size(img.width, img.height);
  len = (width<height?width:height)/6;

  background(0);
  for (int i=0; i<n; i++) {
    cx[i]=random(width);
    cy[i]=random(height);
  }

  smooth(8);
  strokeWeight(.3);
  mode = drawModes[mode_ind];
  c1mode = c1s[c1_ind];
  c2mode = c2s[c2_ind];
}

int tick = 0;
int one = 255/4;
float c1, c2;
void draw() {  
  for (int i=1; i<n; i++) {
    color c = img.get((int)cx[i], (int)cy[i]);
    stroke(c);
    point(cx[i], cy[i]);
    setCols(c);
    updatePoint(i);
  }

  if (frameCount>len) {
    frameCount=0;
    if (itswitch) updateQueue();
    tick++;
    println("iteration: " + tick);
    for (int i=0; i<n; i++) {
      cx[i]=random(width);
      cy[i]=random(height);
    }
  }
}

void mouseClicked() {
  updateQueue();
}

void keyPressed() {
  if (key == 's' || key == 'S') {   
    String savepath;
    savepath = imagefilename.replaceFirst("[.][^.]+$", "");
    saveFrame(savepath+"_"+nf(frameCount, 4)+".png");
  }
}
