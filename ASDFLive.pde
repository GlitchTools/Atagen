// ASDFLive
// an ASDF-style sort with live control & blur mode
// rob mac, 2014
// controls:
// q      switch vertical/horizontal
// w      switch forwards/reverse
// e      stop/start
// r      reload image
// a      blur
// + / -  threshold
// enter  save image
// g      dump frames
PImage img;
String fileName = "copshunting1.png_RGB_4629.png";
float thresh = 80;
boolean inv = false; // invert sort
boolean hor = true; // horizontal sort
boolean active = true;
boolean psych = false; // psychedelic overlay mode
boolean dump = false; // framedump
boolean cflip = false;
boolean update = true; // turn image updating off
void setup() {
  img = loadImage(fileName);
  if (img.width < displayWidth && img.height < displayHeight) {
    size(img.width, img.height);
  } else {
    size(displayWidth, displayHeight);
  }
  image(img, 0, 0, width, height);
  img.loadPixels();
  loadPixels();
}

void draw() {
  if (keyPressed) doThresh();
  if (active) {
    if (!hor) {
      if (inv) {
        int pos = 0;
        for (int x = 0; x < img.width; x++) {
          pos = 0;
          for (int y = 0; y < img.height; y++) {
            if (brightness(img.pixels[x+(y*img.width)]) < thresh) {
              int leng = y-pos;
              color temp[] = new color[leng];
              for (int i = 0; i < leng-1; i++) {
                temp[i] = img.pixels[x+((y-leng+i)*img.width)];
              }
              for (int i = 0; i < leng-1; i++) {
                if (temp[i] > temp[i+1]) {
                  color t = temp[i+1];
                  temp[i+1] = temp[i];
                  temp[i] = t;
                }
              }
              for (int i = 0; i < leng-1; i++) {
                img.pixels[x+((y-leng+i)*img.width)] = temp[i];
              }
              pos = y;
              //        println(y, pos, leng);
            }
          }
        }
      } else {
        int pos = img.height;
        for (int x = 0; x < img.width; x++) {
          pos = img.height;
          for (int y = img.height-1; y > 0; y--) {
            if (brightness(img.pixels[x+(y*img.width)]) < thresh) {
              int leng = pos-y;
              //          println(leng);
              color temp[] = new color[leng];
              for (int i = leng-1; i > 0; i--) {
                temp[i] = img.pixels[x+((pos-i)*img.width)];
              }
              for (int i = 1; i < leng; i++) {
                if (temp[i] > temp[i-1]) {
                  color t = temp[i-1];
                  temp[i-1] = temp[i];
                  temp[i] = t;
                }
              }
              for (int i = leng-1; i > 0; i--) {
                img.pixels[x+((pos-i)*img.width)] = temp[i];
              }
              pos = y;
            }
          }
        }
      }
    } else {
      if (inv) {
        int pos = 0;
        for (int y = 0; y < img.height; y++) {
          pos = 0;
          for (int x = 0; x < img.width; x++) {
            if (brightness(img.pixels[x+(y*img.width)]) < thresh) {
              int leng = x-pos;
              color temp[] = new color[leng];
              for (int i = 0; i < leng; i++) {
                temp[i] = img.pixels[x-leng+i+((y)*img.width)];
              }
              for (int i = 0; i < leng-1; i++) {
                if (temp[i] > temp[i+1]) {
                  color t = temp[i+1];
                  temp[i+1] = temp[i];
                  temp[i] = t;
                }
              }
              for (int i = 0; i < leng; i++) {
                img.pixels[x-leng+i+((y)*img.width)] = temp[i];
              }
              pos = x;
              //        println(y, pos, leng);
            }
          }
        }
      } else {
        int pos = img.width;
        for (int y = 0; y < img.height-1; y++) {
          pos = img.width;
          for (int x = img.width-1; x > 0; x--) {
            if (brightness(img.pixels[x+(y*img.width)]) < thresh) {
              int leng = pos-x;
              color temp[] = new color[leng];
              for (int i = 0; i < leng-1; i++) {
                temp[i] = img.pixels[pos-i+((y)*img.width)];
              }
              for (int i = 0; i < leng-1; i++) {
                if (temp[i] > temp[i+1]) {
                  color t = temp[i+1];
                  temp[i+1] = temp[i];
                  temp[i] = t;
                }
              }
              for (int i = 0; i < leng-1; i++) {
                img.pixels[pos-i+((y)*img.width)] = temp[i];
              }
              pos = x;
              //        println(y, pos, leng);
            }
          }
        }
      }
    }

    if (psych && hor) {
      if (cflip) {
        img.copy(img, 0, 0, img.width, img.height, 0, 0, img.width-1, img.height);
      } else {
        img.copy(img, 0, 0, img.width, img.height, 0, 0, img.width-1, img.height-1);
      }
      cflip=!cflip;
    } else if (psych && !hor) {
      if (cflip) {
        img.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height-1);
      } else {
        img.copy(img, 0, 0, img.width, img.height, 0, 0, img.width-1, img.height-1);
      }
      cflip=!cflip;
    } else img.updatePixels();
    if (update) image(img, 0, 0, width, height);
  }
}

void keyPressed() {
  switch(key) {
  case RETURN:
  case ENTER:
    img.save(split(fileName, '.')[0] + "_asdf_" + frameCount + ".png");
    println("Saved.");
    break;

  case 'q':
  case 'Q':
    hor = !hor;
    break;

  case 'w':
  case 'W':
    inv = !inv;
    break;

  case 'e':
  case 'E':
    active = !active;
    break;

  case 'a':
  case 'A':
    psych = !psych;
    break;

  case 'r':
  case 'R':
    img = loadImage(fileName);
    image(img, 0, 0, width, height);
    break;

  case 't':
  case 'T':
    update=!update;
    break;
  }
}

void doThresh() {
  switch(key) {
  case '+':
    thresh = (thresh+5 < 255) ? thresh+5 : thresh;
    println("Threshold: " + thresh);
    break;
  case '-':
    thresh = (thresh-5 > 0) ? thresh-5 : thresh;
    println("Threshold: " + thresh);
    break;
  }
}
