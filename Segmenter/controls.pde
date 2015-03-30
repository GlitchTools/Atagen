
void keyPressed() {
  switch(key) {

  case ENTER:
  case RETURN:
    saveFrame(fileName+"_seg####.png");
    break;

  case 'r':
  case 'R':
    mode = (mode == 1) ? 0 : 1;
    break;


  case 'w':
  case 'W':
    thres = (thres >= 8) ? thres -4 : thres;
    println("Threshold: " + thres);
    break;

  case 'e':
  case 'E':
    thres = (thres <= 252) ? thres+4 : thres;
    println("Threshold: " + thres);
    break;

  case 'a':
  case 'A':
    v = (v) ? false : true;
    println("Vertical: " + v);
    break;

  case 's':
  case 'S':
    h = (h) ? false : true;
    println("Horizontal: " + h);
    break;

  case 'd':
  case 'D':
    diag = (diag) ? false : true;
    println("Diagonal: " + diag);
    break;

  case 'q':
  case 'Q':
    if (running) {
      noLoop();
      running = false;
    } else {
      loop();
      running = true;
    }
  }
}

void mousePressed() {
  switch(mouseButton) {
  case LEFT:
    bounds[0] = mouseX;
    bounds[1] = mouseY;
    noLoop();
    break;

  case RIGHT:
    resetBounds();
    break;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    bounds[2] = mouseX;
    bounds[3] = mouseY;
    if (bounds[0] > bounds[2]) {
      int temp = bounds[0];
      bounds[0] = bounds[2];
      bounds[2] = temp;
    }
    if (bounds[1] > bounds[3]) {
      int temp = bounds[1];
      bounds[1] = bounds[3];
      bounds[3] = temp;
    }
    if (bounds[0] == bounds [2] && bounds[1] == bounds[3]) {
      resetBounds();
    }
    if (running) loop();
  }
}

void resetBounds() {
  bounds[0]= 0;
  bounds[1]= 0;
  bounds[2]= width;
  bounds[3]= height;
}
