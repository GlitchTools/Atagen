void keyPressed() {
  switch(key) {

  case 'w':
  case 'W':
    bri = !bri;
    println("Threshold inverted.");
    break;

  case 'q':
  case 'Q':
    split = !split;
    break;

  case 'g':
  case 'G':
    dump = !dump;
    break;

  case 'r':
  case 'R':
    img = loadImage(fileName);
    break;

  case ENTER:
  case RETURN:
    img.save(split(fileName, '.')[0] + "_mark_" + frameCount + ".png");
    break;
  }
}

void keyThres() {
  switch(key) {
  case 'e':
  case 'E':
  case '+':
    thres = (thres < 255) ? thres + 1 : thres;
    println("Threshold: " + thres);
    break;

  case 'd':
  case 'D':
  case '-':
    thres = (thres > 1) ? thres - 1 : thres;
    println("Threshold: " + thres);
    break;
  }
}
