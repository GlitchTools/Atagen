/* keysort
pixelsorting keyed off secondary image
rob mac 2015
thanks to clif pottberg

+ / -    adjust threshold
r        reset key image
space    save image
*/

PImage img, src;
float thresh = 100.0;
String fileName = "BLADE-RUNNER.jpg";
String srcName = "mountain1_2625884k.jpg";
boolean broke = true;
boolean brokebg = false;

void setup() {
  img = loadImage(fileName); 
  src = loadImage(srcName);
  size(img.width, img.height);
  src.resize(img.width, img.height);
  img.loadPixels();
  src.loadPixels();
  image(img, 0, 0);
}

void draw() {
  if (!broke) {
    for (int x = 0; x < img.width; x++) {
      int last = 0;
      for (int y = 0; y < img.height; y++) {
        if (brightness(src.pixels[x+(y*width)]) < thresh) {
          int len = y-last;
          color[][] sort = new color[2][len];
          for (int i = 0; i < len; i++) {
            sort[0][i] = img.pixels[x+((last+i)*width)];
            sort[1][i] = src.pixels[x+((last+i)*width)];
          }
          for (int i = 0; i < len-1; i++) {
            if (brightness(sort[0][i+1]) > brightness(sort[0][i])) {
              color[] swap = {
                sort[0][i], sort[1][i]
              };
              sort[0][i] = sort[0][i+1];
              sort[1][i] = sort[1][i+1];
              sort[0][i+1] = swap[0];
              sort[1][i+1] = swap[1];
            }
          }
          for (int i =0; i < len; i++) {
            img.pixels[x+((last+i)*width)] = sort[0][i];
            src.pixels[x+((last+i)*width)] = sort[1][i];
          }
          last = y;
        }
      }//y
    }//x
  } // broke
  else {
    for (int x = 0; x < img.width; x++) {
      int last = 0;
      for (int y = 0; y < img.height-1; y++) {
        if (brightness(src.pixels[x+(y*width)]) > thresh) {
          int len = y-last;
          color[][] sort = new color[2][len+1];
          for (int i = 0; i < len; i++) {
            sort[0][i] = img.pixels[x+((last+i)*width)];
            sort[1][i] = src.pixels[x+((last+i)*width)];
          }
          for (int i =0; i < len; i++) {
            if (brightness(sort[1][i]) > brightness(sort[0][i])) {
              color[] swap = {
                sort[0][i], sort[1][i]
              };
              sort[0][i] = sort[0][i+1];
              sort[1][i] = sort[1][i+1];
              sort[0][i+1] = swap[0];
              sort[1][i+1] = swap[1];
            }
          }
          for (int i =0; i < len; i++) {
            img.pixels[x+((last+i)*width)] = sort[0][i];
            src.pixels[x+((last+i)*width)] = sort[1][i];
          }
          last = y;
        }
      }//y
    }//x
  }
  img.updatePixels();
  src.updatePixels();
  image(img, 0, 0);
}

void keyPressed(){
  if (key == ' ') if (!brokebg) save(fileName+frameCount+".png"); else img.save(fileName+frameCount+".png"); 
  if (key == '+') {thresh+=.5; println(thresh);}
  if (key == '-') {thresh-=.5; println(thresh);}
  if (key == 'r' || key == 'R') src = loadImage(srcName);
}
