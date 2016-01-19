// video 'greater than' buffer/delay
// rob mac, 2015
import processing.video.*;

//options
String fileName = "This Is Your Brain On Drugs (Original).mp4";
int fps = 25; //set your video's fps here, and width/height below
int w = 320;
int h = 240;
float len = 0.5; //length of echo
int mode = 2; //set echo style, 0, 1, or 2


Movie frames;
boolean newFrame = false;
int cached = 0;
int count = int(fps*len)-1;
PImage[] cache = new PImage[count+1];
void setup() {
  size(w, h);
  frames = new Movie(this, fileName);
  frameRate(fps);
  //  noSmooth();
  //  strokeWeight(1.0/fps);
  frames.loop();
  loadPixels();
  cache[count] = createImage(w, h, RGB);
}

void draw() {
  if (newFrame) {

    if (cached < count) { 
      cache[cached] = createImage(w, h, RGB);
      cache[cached].loadPixels();
      arrayCopy(frames.pixels, cache[cached].pixels);
      cached++;
    } else {
      for (int i = 0; i < count; i++) {
        arrayCopy(cache[i+1].pixels, cache[i].pixels);
      }
      arrayCopy(frames.pixels, cache[cached].pixels);
    }

    if (cached == count) {
      switch(mode) {
      case 1:
        for (int i = 0; i < w*h; i++) {
          pixels[i%w+(i/w)*w] = color(0);
          for (int o = 0; o < count; o++) {
            pixels[i%w+(i/w)*w] = (brightness(cache[o].pixels[i%w+(i/w)*w])*map(o, 0, count, 1.0, 0.0) > brightness(pixels[i%w+(i/w)*w])) ? cache[o].pixels[i%w+(i/w)*w] : pixels[i%w+(i/w)*w];
            /*        stroke(cache[o].pixels[i%w+(i/w)*w]);
             point(i%w, i/w);*/
          }
        }
        break;

      case 2:
        for (int i = 0; i < w*h; i++) {
          pixels[i%w+(i/w)*w] = color(0);
          for (int o = 0; o < count; o++) {
            pixels[i%w+(i/w)*w] = (brightness(cache[o].pixels[i%w+(i/w)*w]) > brightness(pixels[i%w+(i/w)*w])) ? cache[o].pixels[i%w+(i/w)*w] : pixels[i%w+(i/w)*w];
            /*        stroke(cache[o].pixels[i%w+(i/w)*w]);
             point(i%w, i/w);*/
          }
        }
        break;

      default:
        for (int i = 0; i < w*h; i++) {
          color temp = pixels[i%w+(i/w)*w];
          pixels[i%w+(i/w)*w] = color(0);
          for (int o = 0; o < count; o++) {
            temp = lerpColor(temp, cache[o].pixels[i%w+(i/w)*w], norm(o, count, 0));
          }
          pixels[i%w+(i/w)*w] = temp;
        }
        break;
      }//mode
    }
    updatePixels();
    newFrame = false;
  }
}

void movieEvent(Movie m) {
  m.read();
  newFrame = true;
  m.loadPixels();
}

void keyPressed() {
  switch(key) {
  case ' ':
    mode = (mode == 2) ? 0 : mode+1;
    println(mode);
    break;
  }
}
