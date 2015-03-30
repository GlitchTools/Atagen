
void keyPressed() {
  switch(key) {

  case 'q':
  case 'Q':
    v = !v;
    if (v) println("Vertical enabled.");
    else println("Vertical disabled.");
    break;

  case 'w':
  case 'W':
    h = !h;
    if (h) println("Horizontal enabled.");
    else println("Horizontal disabled.");
    break;

  case 'a':
  case 'A':
    Vrev = !Vrev;
    if (Vrev) println("Verticals: up.");
    else println("Verticals: down.");
    break;

  case 's':
  case 'S':
    Hrev = !Hrev;
    if (Hrev) println("Horizontals: left.");
    else println("Horizontals: right.");
    break;

  case 'd':
  case 'D':
    switch(mode) {
    case EXCLUSIVE:
      mode = LESSER;
      println("Tolerance mode: lesser.");
      break;
    case LESSER:
      mode = GREATER;
      println("Tolerance mode: greater.");
      break;
    case GREATER:
      mode = EXCLUSIVE;
      println("Tolerance mode: exclusive.");
      break;
    }
    break;

  case 'f':
  case 'F':
    switch(sum) {
    case CLASSIC:
      sum = RGBSUM;
      println("Detection mode: RGB sum.");
      break;
    case RGBSUM:
      sum = BRIGHT;
      println("Detection mode: brightness.");
      break;
    case BRIGHT:
      sum = CLASSIC;
      println("Detection mode: classic (R>G>B).");
      break;
    }
    break;

  case 'e':
  case 'E':
    if (toggle) active = true;
    else if (!toggle && !active) {
      active = true;
      println("Running..");
    }
    else {
      active = false;
      println("Stopped.");
    }
    break;  

  case 'r':
  case 'R':
    img = loadImage(fileName);
    image(img, 0, 0, width, height);
    println("Image reset.");
    break;

  case 'c':
  case 'C':
    lim = 1;
    println("Move divisor disabled.");
    break;


  case 'z':
  case 'Z':
    lim = (lim > 1) ? lim-1:lim;
    println("Move divisor: " + lim);
    break;

  case 'x':
  case 'X':
    lim++;
    println("Move divisor: " + lim);
    break;

  case 'v':
  case 'V':
    toggle = !toggle;
    println("Toggle switched.");
    break;

  case ENTER:
  case RETURN:
    img.save(fileName+"_vert_" + mode + "_" + sum + "_" + frameCount + ".png");
    println("File saved.");
    break;
  }
}

void tolKey() {
  switch(key) {  
  case '-':
  case 't':
  case 'T':
    tol = (tol > 1) ? tol-1 : tol;
    println("Tolerance: " + tol);
    break;

  case '+':
  case 'y':
  case 'Y':
    tol = (tol < 255.0) ? tol+1 : floor(tol);
    println("Tolerance: " + tol);
    break;

  case 'g':
  case 'G':
    rand = (rand > 0) ? rand - 0.5 : rand;
    println("Random: " + rand);
    break;

  case 'h':
  case 'H':
    rand +=0.5;
    println("Random: " + rand);
    break;
  }
}
