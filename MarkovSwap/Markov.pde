
void mark(int x, int y) { // only higher
  color pos = img.pixels[x+((y)*img.width)];
  if ((bri && brightness(pos) > thres) || (!bri && brightness(pos) < thres)) {
    color[] check = doCheck(x, y);
    int dir = 0;
    float curHi = 0.0;
    for (int i = 0; i < 8; i++) {
      float cur = comp(pos, check[i]);
      if (cur > curHi) {
        curHi = cur;
        dir = i;
      }
    }
    swap(x, y, dir);
  }//brightness
}

void mark1(int x, int y) { // only higher or brighter
  color pos = img.pixels[x+((y)*img.width)];
  if ((bri && brightness(pos) > thres) || (!bri && brightness(pos) < thres)) {
    color[] check = doCheck(x, y);
    int dir = 0;
    float curHi = 0.0;
    for (int i = 0; i < 8; i++) {
      float cur = comp(pos, check[i]);
      if (cur > curHi) {
        curHi = cur;
        dir = i;
      } else if (cur == curHi && brightness(check[i]) > brightness(pos)) {
        curHi = cur;
        dir = i;
      }
    }
    swap(x, y, dir);
  }//brightness
}

void mark2(int x, int y) { // higher or equal
  color pos = img.pixels[x+((y)*img.width)];
  if ((bri && brightness(pos) > thres) || (!bri && brightness(pos) < thres)) {
    color[] check = doCheck(x, y);
    int dir = 0;
    float curHi = 0.0;
    for (int i = 0; i < 8; i++) {
      float cur = comp(pos, check[i]);
      if (cur >= curHi) {
        curHi = cur;
        dir = i;
      }
    }
    swap(x, y, dir);
  }//brightness
}

color[] doCheck(int x, int y) {
  color[] temp = { 
    img.pixels[x-1+((y-1)*img.width)], img.pixels[x+((y-1)*img.width)], img.pixels[x+1+((y-1)*img.width)], 
    img.pixels[x-1+((y)*img.width)], img.pixels[x+1+((y)*img.width)], 
    img.pixels[x-1+((y+1)*img.width)], img.pixels[x+((y+1)*img.width)], img.pixels[x+1+((y+1)*img.width)]
  };
  return temp;
}


int r(color c) {
  return c >> 24 & 0xff;
}

int g(color c) {
  return c >> 16 & 0xff;
}

int b(color c) {
  return c >> 0xff;
}

float comp(color src, color dst) {
  //float temp = (inv) ?   : abs(r(src) + r(dst)) - abs(g(src) + g(dst)) - abs(r(src) + r(dst)); 
  return abs(r(src) - r(dst)) + abs(g(src) - g(dst)) + abs(r(src) - r(dst));
}


float comp2(color src, color dst) { //weird & wacky modulo fun
  //float temp = (inv) ?   : abs(r(src) + r(dst)) - abs(g(src) + g(dst)) - abs(r(src) + r(dst)); 
  return abs(r(src) % (r(dst)+1)) + abs(g(src) % (g(dst)+1)) + abs(r(src) % (r(dst)+1));
}

