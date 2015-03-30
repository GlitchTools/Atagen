void swap(int x, int y, int dir) {
  color c = img.pixels[x+(y*img.width)];  
  switch(dir) {
  case 1: // up
    img.pixels[x+(y*img.width)] = img.pixels[x+((y-1)*img.width)];
    img.pixels[x+((y-1)*img.width)] = c;
    break;
  case 2: //up+right
    img.pixels[x+(y*img.width)] = img.pixels[x+1+((y-1)*img.width)];
    img.pixels[x+1+((y-1)*img.width)] = c;
    break;
  case 3: // left
    img.pixels[x+(y*img.width)] = img.pixels[x-1+((y)*img.width)];
    img.pixels[x-1+((y)*img.width)] = c;
    break; 
  case 4:// right
    img.pixels[x+(y*img.width)] = img.pixels[x+1+((y)*img.width)];
    img.pixels[x+1+((y)*img.width)] = c;
    break;
  case 5: // down+left
    img.pixels[x+(y*img.width)] = img.pixels[x-1+((y+1)*img.width)];
    img.pixels[x-1+((y+1)*img.width)] = c;
    break;
  case 6: // down
    img.pixels[x+(y*img.width)] = img.pixels[x+((y+1)*img.width)];
    img.pixels[x+((y+1)*img.width)] = c;
    break;
  case 7: // down+right
    img.pixels[x+(y*img.width)] = img.pixels[x+1+((y+1)*img.width)];
    img.pixels[x+1+((y+1)*img.width)] = c;
    break;
  default: // up + left
    img.pixels[x+(y*img.width)] = img.pixels[x-1+((y-1)*img.width)];
    img.pixels[x-1+((y-1)*img.width)] = c;
    break;
  }
}
