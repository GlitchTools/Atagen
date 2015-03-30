void doMash() {
  println("Running..");
  PGraphics temp = createGraphics(img.width, img.height);
  int off = 0;
  color c;
  boolean a = false;
  temp.beginDraw();
  temp.image(img, 0, 0);
  if (h) {
    if (!Hrev) {
      for (int y = 0; y < img.height-1; y++) {
        for (int x = 0; x < img.width-1; x++) {
          c = img.pixels[x+(y*img.width)];
          while (check (x, y, x+off+1, y) == true && x+off+1 < img.width) {
            off++;
            a = true;
          }
          if (a) {
            temp.stroke(c);
            temp.line(x, y, x+(off/lim), y);
            x = x+(off/lim);
            a = false;
            off = 0;
          }
        }
      }
    } else { // hrev
      for (int y = 0; y < img.height-1; y++) {
        for (int x = img.width-1; x > 1; x--) {
          c = img.pixels[x+(y*img.width)];
          while (check (x, y, x-off-1, y) == true && x-off-1 > 0) {
            off++;
            a = true;
          }
          if (a) {
            temp.stroke(c);
            temp.line(x, y, x-(off/lim), y);
            x = x-(off/lim);
            a = false;
            off = 0;
          }
        }
      }
    }
  }//h

  if (v) {
    if (!Vrev) {
      for (int x = 0; x < img.width-1; x++) {
        for (int y = 0; y < img.height-1; y++) {
          c = img.pixels[x+(y*img.width)];
          while (check (x, y, x, y+off+1) == true && y+off+1 < img.height-1 ) {
            off++;
            a = true;
          }
          if (a) {
            temp.stroke(c);
            temp.line(x, y, x, y+(off/lim));
            y = y+(off/lim);
            a = false;
            off = 0;
          }
        }
      }
    } else { //Vrev
      for (int x = 0; x < img.width-1; x++) {
        for (int y = img.height-1; y > 1; y--) {
          c = img.pixels[x+(y*img.width)];
          while (check (x, y, x, y-off-1) == true && y-off-1 > 0) {
            off++;
            a = true;
          }
          if (a) {
            temp.stroke(c);
            temp.line(x, y, x, y-(off/lim));
            y = y-(off/lim);
            a = false;
            off = 0;
          }
        }
      }
    }
  }//v
  temp.endDraw();
  img = temp.get();
  img.updatePixels();
  image(img, 0, 0, width, height);
  println("Done.");
}
