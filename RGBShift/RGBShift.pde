/*
 RGB SHIFTER
 rob mac, 2014
 additional warps, assistance from adam tuerff
 controls:
 
 WASD         red layer shift
 TFGH         green layer shift
 IJKL         blue layer shift
 arrows       all layer shift
 Q, E, U      pixel warps
 R, Y, P      RGB warps
 O (held)     pixelsort
 [ ] or + -   adjust threshold (effects warps+sort)
 x            snapshot (set current window as working image) - MUST BE DONE AFTER WARP EFFECTS
 z            return to working image
 c            unsnap (go back to original working image)
 enter        save image
 
 */

PImage img, r, g, b, org;
String fileName = "wispyhead1.png";
int rxShift = 0;
int gxShift = 0;
int bxShift = 0;
int ryShift = 0;
int gyShift = 0;
int byShift = 0;
float thresh = 8.5;
int gate = 3; // widen threshold by x amount
int rand = 3; // randomiser for crush - 1 = 50% etc 0 = off
int randmode = 0; // 0 to randomly miss bits; 1 to randomly reverse bend bits
boolean snapped = false;
boolean stopkey = false;
int W, H;
void setup() {
  img = loadImage(fileName);
  W = (img.width < displayWidth - 30) ? img.width : displayWidth-30;
  H = (img.height < displayHeight - 30) ? img.height : displayHeight-30;
  size(W, H);
  image(img, 0, 0, width, height);
  img.loadPixels();
  r = createImage(img.width, img.height, RGB);
  b = createImage(img.width, img.height, RGB);
  g = createImage(img.width, img.height, RGB);
  doSnap();
  doShift();
}

void draw() {
  if (keyPressed && !stopkey) doKeys();
}

void keyPressed() {
  doKeys();
}

void swap(int src, int dest) {
  color c = img.pixels[dest];
  img.pixels[dest] = img.pixels[src];
  img.pixels[src] = c;
}

void doSort() {
  img.loadPixels();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height-1; y++) {
      if (brightness(img.pixels[x+(y*img.width)]) > thresh+brightness(img.pixels[x+((y+1)*img.width)])) swap(x+((y+1)*img.width), x+(y*img.width));
    }
  }
  updateDisplay();
}

void doSnap() {
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      r.pixels[x+(y*img.width)] = (img.pixels[x+(y*img.width)] >> 16 & 0xff);
      g.pixels[x+(y*img.width)] = (img.pixels[x+(y*img.width)] >> 8 & 0xff);
      b.pixels[x+(y*img.width)] = (img.pixels[x+(y*img.width)] & 0xff);
    }
  }
}

void doShift() {
  int _rxShift = 0;
  int _gxShift = 0;
  int _bxShift = 0;
  int _ryShift = 0;
  int _gyShift = 0;
  int _byShift = 0;
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      _rxShift = constrain(x + rxShift, 0, img.width-1);
      _bxShift = constrain(x + bxShift, 0, img.width-1);
      _gxShift = constrain(x + gxShift, 0, img.width-1);
      _ryShift = constrain(y + ryShift, 0, img.height-1);
      _byShift = constrain(y + byShift, 0, img.height-1);
      _gyShift = constrain(y + gyShift, 0, img.height-1);
      img.pixels[x+(y*img.width)] = (r.pixels[_rxShift+((_ryShift)*img.width)]<<16)+(g.pixels[_gxShift+((_gyShift)*img.width)]<<8)+b.pixels[_bxShift+((_byShift)*img.width)];
    }
  }
  updateDisplay();
}

void doCrush1() {
  int lost = 0;
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      float te = brightness(img.pixels[x+(y*img.width)]);
      if (te < thresh+gate && te > thresh-gate && round(random(rand)) == rand) {
        lost++;
      } else {
        img.pixels[x+(y*img.width)] = img.pixels[abs(x+(y*img.width)-lost)];
      }
    }
  }
  updateDisplay();
  println("Crushed - style #1.");
}

void doCrush2() {
  int s = 0;
  for (int i = 0; i < img.width*img.height; i++) {
    float te = brightness(img.pixels[i]);
    if (te < thresh+gate && te > thresh-gate) {
      if (randmode == 0 && round(random(rand)) == rand) s++;
      else if (randmode == 1)
        if (round(random(rand)) == rand) s++;
        else s--;
    }
    img.pixels[i] = (r.pixels[constrain(i+s, 0, img.pixels.length-1)]<<16)+(g.pixels[constrain(i+s, 0, img.pixels.length-1)]<<8)+(b.pixels[constrain(i+s, 0, img.pixels.length-1)]);
  }
  updateDisplay();
  println("Crushed - style #2.");
}

void doCrush3() {
  int s = 0;
  for (int i = 0; i < img.width*img.height; i++) {
    float te = brightness(img.pixels[i]);
    if (te < thresh+gate && te > thresh-gate) {
      if (randmode == 0 && round(random(rand)) == rand) s++;
      else if (randmode == 1)
        if (round(random(rand)) == rand) s++;
        else s--;
    }
    img.pixels[i] = (r.pixels[constrain(i+s, 0, img.pixels.length-1)]<<17)+(g.pixels[constrain(i+s, 0, img.pixels.length-1)]<<9)+(b.pixels[constrain(i+s, 0, img.pixels.length-1)]);
  }
  updateDisplay();
  println("Crushed - style #3.");
}

void RGBCrush1() {
  int sR, sG, sB;
  sR = sG = sB = 0;
  for (int i = 0; i < img.width*img.height; i++) {
    if (i+sR < img.pixels.length -1 && r.pixels[i+sR] < thresh+gate && r.pixels[i+sR] > thresh-gate) sR++;
    if (i+sG < img.pixels.length -1 && g.pixels[i+sG] < thresh+gate && g.pixels[i+sG] > thresh-gate) sG++;
    if (i+sB < img.pixels.length -1 && b.pixels[i+sB] < thresh+gate && b.pixels[i+sB] > thresh-gate) sB++;
    int _r = r.pixels[constrain(i+sR, 0, img.pixels.length-1)]<<16; 
    int _g = g.pixels[constrain(i+sG, 0, img.pixels.length-1)]<<8;
    int _b = b.pixels[constrain(i+sB, 0, img.pixels.length-1)];
    img.pixels[i] = _r+_g+_b;
  }
  updateDisplay();
  println("RGB Crushed - style #1.");
}


void RGBCrush2() {
  int sR, sG, sB;
  sR = sG = sB = 0;
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      if (x+sR+(y*img.width) < img.pixels.length -1 && r.pixels[x+sR+(y*img.width)] < thresh+gate && r.pixels[x+sR+(y*img.width)] > thresh-gate) sR++;
      if (x+sG+(y*img.width) < img.pixels.length -1 && g.pixels[x+sG+(y*img.width)] < thresh+gate && g.pixels[x+sG+(y*img.width)] > thresh-gate) sG++;
      if (x+sB+(y*img.width) < img.pixels.length -1 && b.pixels[x+sB+(y*img.width)] < thresh+gate && b.pixels[x+sB+(y*img.width)] > thresh-gate) sB++;
      int _r = r.pixels[constrain(x+sR+(y*img.width), 0, img.pixels.length-1)]<<16; 
      int _g = g.pixels[constrain(x+sG+(y*img.width), 0, img.pixels.length-1)]<<8;
      int _b = b.pixels[constrain(x+sB+(y*img.width), 0, img.pixels.length-1)];
      img.pixels[x+(y*img.width)] = _r+_g+_b;
    }
  }
  updateDisplay();
  println("RGB Crushed - style #2.");
}

void RGBCrush3() {
  int sR, sG, sB;
  sR = sG = sB = 0;
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      if (x+sR+(y*img.width) < img.pixels.length -1 && r.pixels[x+sR+(y*img.width)] < thresh+gate && r.pixels[x+sR+(y*img.width)] > thresh-gate) sR++;
      if (x+sG+(y*img.width) < img.pixels.length -1 && g.pixels[x+sG+(y*img.width)] < thresh+gate && g.pixels[x+sG+(y*img.width)] > thresh-gate) sG++;
      if (x+sB+(y*img.width) < img.pixels.length -1 && b.pixels[x+sB+(y*img.width)] < thresh+gate && b.pixels[x+sB+(y*img.width)] > thresh-gate) sB++;
      int _r = r.pixels[constrain(x+sR+(y*img.width), 0, img.pixels.length-1)]<<17; 
      int _g = g.pixels[constrain(x+sG+(y*img.width), 0, img.pixels.length-1)]<<9;
      int _b = b.pixels[constrain(x+sB+(y*img.width), 0, img.pixels.length-1)];
      img.pixels[x+(y*img.width)] = _r+_g+_b;
    }
  }
  updateDisplay();
  println("RGB Crushed - style #3.");
}


void doKeys() {
  switch(key) {
  case 'o':
  case 'O':
    doSort();
    break;
  case 'w':
  case 'W':
    ryShift++;
    doShift();
    break;
  case 's':
  case 'S':
    ryShift--;
    doShift();
    break;
  case 'a':
  case 'A':
    rxShift++;
    doShift();
    break;
  case 'd':
  case 'D':
    rxShift--;
    doShift();
    break;
  case 't':
  case 'T':
    gyShift++;
    doShift();
    break;
  case 'g':
  case 'G':
    gyShift--;
    doShift();
    break;
  case 'f':
  case 'F':
    gxShift++;
    doShift();
    break;
  case 'h':
  case 'H':
    gxShift--;
    doShift();
    break;
  case 'i':
  case 'I':
    byShift++;
    doShift();
    break;
  case 'k':
  case 'K':
    byShift--;
    doShift();
    break;
  case 'j':
  case 'J':
    bxShift++;
    doShift();
    break;
  case 'l':
  case 'L':
    bxShift--;
    doShift();
    break;

  case 'x':
  case 'X':
    doSnap();
    snapped = true;
    println("Snapshot taken.");
    rxShift = bxShift = gxShift = ryShift = byShift = gyShift = 0;
    doShift();
    stopkey = true;
    break;

  case 'c':
  case 'C':
    img = loadImage(fileName);
    updateDisplay(); 
    doSnap(); 
    snapped = false; 
    doShift(); 
    println("Snapshot dumped."); 
    stopkey = true; 
    break; 

  case 'z' : 
  case 'Z' : 
    rxShift = bxShift = gxShift = ryShift = byShift = gyShift = 0; 
    doShift(); 
    stopkey = true; 
    break; 

  case '+' : 
  case ']' : 
    thresh = (thresh < 255) ? thresh+.5 : thresh; 
    println("Thresh: " + thresh); 
    break; 

  case '-' : 
  case '[' : 
    thresh = (thresh > 0.5) ? thresh-.5 : thresh; 
    println("Thresh: " + thresh); 
    break; 

  case 'q' : 
  case 'Q' : 
    doCrush1(); 
    stopkey=true; 
    break; 

  case 'E' : 
  case 'e' : 
    doCrush2(); 
    stopkey=true; 
    break; 

  case 'R' : 
  case 'r' : 
    RGBCrush1(); 
    stopkey=true; 
    break; 

  case 'Y' : 
  case 'y' : 
    RGBCrush2(); 
    stopkey=true; 
    break; 

  case 'U' : 
  case 'u' : 
    doCrush3(); 
    stopkey=true; 
    break; 

  case 'P':
  case 'p':
    RGBCrush3();
    stopkey=true;
    break;

  case ENTER : 
  case RETURN : 
    img.save(fileName + "_RGB_"+frameCount+".png"); 
    break; 

  case CODED : 
    switch(keyCode) {
    case UP : 
      ryShift++; 
      gyShift++; 
      byShift++; 
      break; 

    case DOWN : 
      ryShift--; 
      gyShift--; 
      byShift--; 
      break; 

    case LEFT : 
      rxShift++; 
      gxShift++; 
      bxShift++; 
      break; 

    case RIGHT : 
      rxShift--; 
      gxShift--; 
      bxShift--; 
      break;
    }
    doShift();
  }
}

void keyReleased() {
  stopkey = false;
}

void updateDisplay() {
  img.updatePixels(); 
  image(img, 0, 0, width, height);
}
