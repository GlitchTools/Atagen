boolean check(int x, int y, int xc, int yc) {  
  float src, dst, r;
  r = (rand != 0) ? random(0, rand) : 0;
  switch(sum) {
  case 1: //rgbsum 
    src = rgbsum(x, y);
    dst = rgbsum(xc, yc);
    break;
  case 2: // brightness
    src = brightness(img.pixels[x+(y*width)]);
    dst = brightness(img.pixels[xc+(yc*width)]);
    break;
  default: // 'classic' or asdfish
    src = map(img.pixels[x+(y*width)], 0, 0xFFFFFF, 0.0, 255.0);
    dst = map(img.pixels[xc+(yc*width)], 0, 0xFFFFFF, 0.0, 255.0);
    break;
  }

  if (mode == 0 && (src < dst-tol-r || src > dst+tol+r)) return true;
  else if (mode == 1 && src > dst+tol-r) return true;
  else if (mode == 2 && src < dst-tol+r) return true;
  else return false;
}

float rgbsum(int x, int y) {
  int r = img.pixels[x+(y*width)] >> 24 & 0xff;
  int g = img.pixels[x+(y*width)] >> 16 & 0xff;
  int b = img.pixels[x+(y*width)] & 0xff;
  float result = (r + g + b) / 3;
  return result;
}
