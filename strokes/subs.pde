void setCols(color c) {
  switch(c1mode) {
  case BRI:
    c1 = brightness(c);
    break;
  case HUE:
    c1 = hue(c);
    break;
  case SAT:
    c1 = saturation(c);
    break;
  case RED:
    c1 = red(c);
    break;
  case BLU:
    c1 = blue(c);
    break;
  case GRN:
    c1 = green(c);
    break;
  case DRK:
    c1 = 255-brightness(c);
    break;
  }
  switch(c2mode) {
  case BRI:
    c2 = brightness(c);
    break;
  case HUE:
    c2 = hue(c);
    break;
  case SAT:
    c2 = saturation(c);
    break;
  case RED:
    c2 = red(c);
    break;
  case BLU:
    c2 = blue(c);
    break;
  case GRN:
    c2 = green(c);
    break;
  case DRK:
    c2 = 255-brightness(c);
    break;
  }
}

void updateQueue() {
  mode_ind = (mode_ind+1 < drawModes.length) ? mode_ind+1 : 0;
  mode = drawModes[mode_ind];
  c1_ind = (c1_ind+1 < c1s.length) ? c1_ind+1 : 0;
  c1mode = c1s[c1_ind];
  c2_ind = (c2_ind+1 < c2s.length) ? c2_ind+1 : 0;
  c2mode = c2s[c2_ind];
}

void updatePoint(int i) {
  switch(mode) {
  case NOR: // normal, saturation based
    cy[i]+=sin(map(c1, 0, 255, 0, TWO_PI));
    cx[i]+=cos(map(c2, 0, 255, 0, TWO_PI));
    break;
  case INV: // switched sin/cos, hue+bright based
    cy[i]+=cos(map(c1, 0, 255, TWO_PI, 0));
    cx[i]+=sin(map(c2, 0, 255, TWO_PI, 0));
    break;
  case LIN:
    cy[i]+=(c1 < one) ? cos(HALF_PI) : (c1 < one*2) ? cos(PI)
      : (c1 < one*3) ? cos(HALF_PI*3) : cos(TWO_PI);
    cx[i]+=(c2 < one) ? sin(HALF_PI) : (c2 < one*2) ? sin(PI)
      : (c2 < one*3) ? sin(HALF_PI*3) : sin(TWO_PI);
    break;
  case QU1:
    cy[i]+=(c1 < one) ? cos(map(c1, 0, one, 0, TWO_PI))
      : (c1 < one*2) ? cos(map(c1, 0, one*2, 0, TWO_PI))
        : (c1 < one*3) ? cos(map(c1, 0, one*3, 0, TWO_PI))
          : cos(map(c1, 0, 255, 0, TWO_PI));

    cx[i]+=(c2 < one) ? sin(map(c2, 0, one, 0, TWO_PI)) :
    (c2 < one*2) ? sin(map(c2, 0, one*2, 0, TWO_PI)) :
    (c2 < one*3) ? sin(map(c2, 0, one*3, 0, TWO_PI)) :
    sin(map(c2, 0, 255, 0, TWO_PI));
    break;
  case QU2:
    cy[i]+=(c1 < one) ? cos(map(c1, 0, 255, 0, HALF_PI)) :
    (c1 < one*2) ? cos(map(c1, 0, 255, 0, PI)) :
    (c1 < one*3) ? cos(map(c1, 0, 255, 0, HALF_PI*3)) :
    cos(map(c1, 0, 255, 0, TWO_PI));

    cx[i]+=(c2 < one) ? sin(map(c2, 0, 255, 0, HALF_PI)) :
    (c2 < one*2) ? sin(map(c2, 0, 255, 0, PI)) :
    (c2 < one*3) ? sin(map(c2, 0, 255, 0, HALF_PI*3)) :
    sin(map(c2, 0, 255, 0, TWO_PI));
    break;
  }
}
