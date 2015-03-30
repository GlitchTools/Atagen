// pixelstreaker
// rob mac, 2014
// e      run
// r      reset image
// q      enable/disable verticals
// w      enable/disable horizontals
// a      invert vertical
// s      invert horizontal
// d      switch tolerance mode
// f      switch detection mode
// t / y  adjust tolerance
// + / -  ^
// g / h  adjust tolerance randomness
// z / x  adjust moves divisor
// c      reset divisor
// v      freerun on/off
// enter  save
final int EXCLUSIVE = 0;
final int LESSER = 1;
final int GREATER = 2;

final int CLASSIC = 0;
final int RGBSUM = 1;
final int BRIGHT = 2;

PImage img;
String fileName = "Scan 31.png"; // all options aside from filename can be 
float tol = 100.0; // tolerance
int mode = LESSER; // EXCLUSIVE, LESSER, GREATER
int sum = BRIGHT; // CLASSIC, RGBSUM, BRIGHT
int lim = 1; // move divisor
float rand = 5;
boolean h = false;
boolean v = true;
boolean Hrev = false;
boolean Vrev = false;
int W, H;
boolean active = false;
boolean toggle = true; // toggle or run continuously
void setup() {
  colorMode(RGB);
  img = loadImage(fileName);
  W = (img.width < displayWidth - 30) ? img.width : displayWidth-30;
  H = (img.height < displayHeight - 30) ? img.height : displayHeight-30;
  size(W, H);
  image(img, 0, 0, width, height);
}

void draw() {
  if (keyPressed) tolKey();
  if (active) {
    doMash();
    if (toggle) { 
      active = false;
    }
  }
  //  updatePixels();
}

