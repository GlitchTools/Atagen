// ManhattanSort, 2014
// adapted from code by CalxDesign & Ale González
// rob mac, additional code by Adam Tuerff
// Controls:
// Numpad Sort Direction (use NumLock)
// Q / A  Adjust edge detection size
// W / S  Adjust edge detection quality
// E / D  or
// + / -  Adjust sorting threshold
// X / C  Enable/adjust baffling
// V / B  Adjust baffle colour offset
// T or 0 Run/stop
// R      Reset image
// I      Invert selected areas
// Z      Switch between ordinary and Manhattan distance voronoi
// P      Switch between region disable and region define mouse mode
// Click  Enable/disable or define a new point
// Enter  Save image
// G      Dump frames to GIF

import gifAnimation.*;
import java.util.List;
import java.util.LinkedList;
GifMaker gifExport;

int direction = 1;
int colorOffset = 0;
boolean saveFrames = false;
PImage img;
int numSites;
String fileName;
int area = 1500;
int qual = 20;
int mode = 1; // 0 - voronoi, 1 - manhattan
int baffle = 1;
float thresh = 130.0;
int W, H;
boolean done = false;
float[] detect = new float[4];
int[] schain;
PVector[] sites;
ArrayList<PVector> vertices = new ArrayList<PVector>();
ArrayList<Boolean> enabled = new ArrayList<Boolean>();
boolean running = false;
boolean newpoints = false;
boolean newparams = true;
boolean mousePoints = false;

void setup() {
  size(100, 100);
  frame.setResizable(true);
  smooth();
  selectInput("Select an Image File", "selectedSource");
  while (img == null) {
    delay(200);
  }
  if (img.width < displayWidth && img.height < displayHeight) {
    W = img.width; 
    H = img.height;
  } else {
    W = displayWidth-50; 
    H = displayHeight-50;
  }
  size(W, H);
  frame.setSize(W, H);
  if (W > H) {
    area = ((W % 25) * 50);
    qual = W/50;
  } else {
    area = ((H % 25) * 50); 
    qual = H/50;
  }
  colorMode(HSB, 100);
  image(img, 0, 0, width, height);
  img.loadPixels();
}


void draw() {
  if (!done) { 
    doVor();
  } else if (running) {
    img.loadPixels();   
    doSort();
    img.updatePixels();
    background(0);
    image(img, 0, 0, width, height);
    if (saveFrames) {
      gifExport.addFrame();
      gifExport.setDelay(1);
    }
  }
}
