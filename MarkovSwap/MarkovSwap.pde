// Markovian Pixelswapper
// rob mac, 2014
// analyses a pixels' surroundings and moves
// it to the area of greatest difference.
// controls:
// q      switch between quadrants and whole image
// w      invert thresholding
// -  + or
// e  d   adjust threshold
// enter  save frame
// g      dump frames


// add a base threshold offset eg. to avoid sorting blacks while soritng low colours
String fileName = "nokiatext.jpg";
PImage img;
int upd = 4; // update frequency
float thres = 0.5;
boolean bri = false;
boolean split = true;
boolean dump = false;
void setup() {
  img = loadImage(fileName);
  if (img.width > displayWidth || img.height > displayHeight) {
    size(displayWidth, displayHeight);
  } else {
    size(img.width, img.height);
  } 
  image(img, 0, 0, width, height);
  img.loadPixels();
}

void draw() {
  if (keyPressed) keyThres();
  if (split) { // run quadrants separately
    for (int x = img.width/2+1; x > 1; x--) {
      for (int y = 1; y < img.height/2+1; y++) {      
        mark2(x, y);
      }
    }
    for (int x = img.width/2-1; x < img.width-1; x++) {
      for (int y = 1; y < img.height/2+1; y++) {      
        mark2(x, y);
      }
    } 
    for (int x = img.width/2+1; x > 1; x--) {
      for (int y = img.height-2; y > img.height/2-1; y--) {      
        mark2(x, y);
      }
    }
    for (int x = img.width/2-1; x < img.width-1; x++) {
      for (int y = img.height-2; y > img.height/2-1; y--) {      
        mark2(x, y);
      }
    }
  } else { // just regular
    for (int x = 1; x < img.width-1; x++) {
      for (int y = 1; y < img.height-1; y++) {      
        mark(x, y);
      }
    }
  }

  if (frameCount % upd == 0) img.updatePixels();
  image(img, 0, 0, width, height);
  if (dump) {
    saveFrame("ani/ani" + split(fileName, '.')[0] + "_mark####.tiff");
  }
}
