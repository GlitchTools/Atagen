void doSort() { // messy!

  switch(direction) {

  case 2: //left
    for (int x = 0; x < img.width-1; x++) {
      for (int y = 0; y < img.height; y++) {
        detect[0] = schain[x+(y*img.width)];
        if (enabled.get(int(detect[0]) ) == true) {
          detect[1] = schain[x+1+((y)*img.width)];
          detect[2] = brightness(img.pixels[x+(y*img.width)]*baffle);
          detect[3] = brightness(img.pixels[x+1+((y)*img.width)]/baffle);
          if (detect[0] == detect[1] && detect[2] < detect[3] && detect[2] < thresh) {
            swap(x, y, x+1, y);
          }
        }
      }
    }
    break;    

  case 1: //up
    for (int x = 0; x < img.width; x++) {
      for (int y = 0; y < img.height-1; y++) {
        detect[0] = schain[x+(y*img.width)];
        if (enabled.get(int(detect[0]) ) == true) {
          detect[1] = schain[x+((y+1)*img.width)];
          detect[2] = brightness(img.pixels[x+(y*img.width)]*baffle);
          detect[3] = brightness(img.pixels[x+((y+1)*img.width)]/baffle);
          if (detect[0] == detect[1] && detect[2] < detect[3] && detect[2] < thresh) {
            swap(x, y, x, y+1);
          }
        }
      }
    }
    break;  

  case 3: //down
    for (int x = 0; x < img.width; x++) {
      for (int y = img.height-1; y > 0; y--) {
        detect[0] = schain[x+(y*img.width)];
        if (enabled.get(int(detect[0]) ) == true) {
          detect[1] = schain[x+((y-1)*img.width)];
          detect[2] = brightness(img.pixels[x+(y*img.width)]*baffle);
          detect[3] = brightness(img.pixels[x+((y-1)*img.width)]/baffle);
          if (detect[0] == detect[1] && detect[2] < detect[3] && detect[2] < thresh) {
            swap(x, y, x, y-1);
          }
        }
      }
    }
    break;

  case 4: //right
    for (int x = img.width-1; x > 0; x--) {
      for (int y = 0; y < img.height; y++) {

        detect[0] = schain[x+((y)*img.width)];
        if (enabled.get(int(detect[0]) ) == true) {
          detect[1] = schain[x-1+((y)*img.width)];
          detect[2] = brightness(img.pixels[x+((y)*img.width)]*baffle);
          detect[3] = brightness(img.pixels[x-1+((y)*img.width)]/baffle);
          if (detect[0] == detect[1] && detect[2] < detect[3] && detect[2] < thresh) {
            swap(x, y, x-1, y);
          }
        }
      }
    }
    break;


  case 5: //up left
    for (int x = 0; x < img.width-1; x++) {
      for (int y = 0; y < height-1; y++) {

        detect[0] = schain[x+(y*img.width)];
        if (enabled.get(int(detect[0]) ) == true) {
          detect[1] = schain[x+1+((y+1)*img.width)];
          detect[2] = brightness(img.pixels[x+(y*img.width)]*baffle);
          detect[3] = brightness(img.pixels[x+1+((y+1)*img.width)]/baffle);
          if (detect[0] == detect[1] && detect[2] < detect[3] && detect[2] < thresh) {
            swap(x, y, x+1, y+1);
          }
        }
      }
    }
    break;  

  case 7: //down left
    for (int x = 0; x < img.width; x++) {
      for (int y = img.height-1; y > 0; y--) {

        detect[0] = schain[x+(y*img.width)];
        if (enabled.get(int(detect[0]) ) == true) {
          detect[1] = schain[x+1+((y-1)*img.width)];
          detect[2] = brightness(img.pixels[x+(y*img.width)]*baffle);
          detect[3] = brightness(img.pixels[x+1+((y-1)*img.width)]/baffle);
          if (detect[0] == detect[1] && detect[2] < detect[3] && detect[2] < thresh) {
            swap(x, y, x+1, y-1);
          }
        }
      }
    }
    break;

  case 6: //up right
    for (int x = img.width-1; x > 0; x--) {
      for (int y = 0; y < img.height-1; y++) {

        detect[0] = schain[x+(y*img.width)];
        if (enabled.get(int(detect[0]) ) == true) {
          detect[1] = schain[x-1+((y+1)*img.width)];
          detect[2] = brightness(img.pixels[x+(y*img.width)]*baffle);
          detect[3] = brightness(img.pixels[x-1+((y+1)*img.width)]/baffle);
          if (detect[0] == detect[1] && detect[2] < detect[3] && detect[2] < thresh) {
            swap(x, y, x-1, y+1);
          }
        }
      }
    }
    break;  

  case 8: //down right
    for (int x = img.width-1; x > 0; x--) {
      for (int y = img.height-1; y > 0; y--) {

        detect[0] = schain[x+(y*img.width)];
        if (enabled.get(int(detect[0]) ) == true) {
          detect[1] = schain[x-1+((y-1)*img.width)];
          detect[2] = brightness(img.pixels[x+(y*img.width)]*baffle);
          detect[3] = brightness(img.pixels[x-1+((y-1)*img.width)]/baffle);
          if (detect[0] == detect[1] && detect[2] < detect[3] && detect[2] < thresh) {
            swap(x, y, x-1, y-1);
          }
        }
      }
    }
    break;
  }//end of direction switch
}
