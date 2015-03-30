PImage img;
String fileName = "../wispyhead1 copyfix3.png";
float freq = 1; // number of hue cycles
float spd = 10; // speed of cycling
float inc = 0.01; // control change amount
float decay = 0.9; // control decay amount (set lower for more accuracy)

float bump = 0;
float off = 0;
void setup() {
  colorMode(HSB, 360, 100, 100);
  img = loadImage(fileName);
  size(img.width, img.height);
  image(img, 0, 0);
  loadPixels();
}

void draw() {
  for (int i = 0; i < width*height; i++) {
    float hue = hue(img.pixels[i]);
    float shift = ((i/width)*freq)+off;
    hue += shift;
    hue %= 360;
    pixels[i] = color(hue, saturation(img.pixels[i]/*/(off+2)*/), brightness(img.pixels[i]));
  }
  updatePixels();
  if (bump != 0.00) doBump(0);
  off = (off+spd)%360;
  if (keyPressed) {
    if (key=='s' | key =='S') spd = spd+0.25;
    if (key=='a' | key =='A') spd = (spd-0.25 > 0) ? spd-0.25 : 0;
  }
}

void keyPressed() {
  if (key=='=' | key =='+') doBump(0-inc); 
  if (key=='-' | key =='_') doBump(inc);
  if (key=='r' | key =='R') freq = 1.0;
}

void doBump(float amt) {
  bump *= decay;
  bump = bump+amt;
  freq += (bump + freq > -0.0 && bump + freq < img.height) ? bump : 0;
}
