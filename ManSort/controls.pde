
void keyPressed() {
  switch(key) { 

  case 'f':
  case 'F':  
    colorOffset = (colorOffset < 10000.0 && colorOffset >= 0 ) ? colorOffset + 200 : constrain(colorOffset + 200, 200, 10000);
    println("colorOffset: " + colorOffset);  
    break;

  case 'v':
  case 'V':  
    colorOffset = (colorOffset < 10000.0 && colorOffset >= 0 ) ? colorOffset - 200 : constrain(colorOffset - 200, 200, 10000);
    println("colorOffset: " + colorOffset);    
    break;

  case 'z':
  case 'Z':
    switch(mode) {
    case 1:
      mode = 0;
      println("Ordinary voronoi engaged.");
      newparams = true;
      break;
    default:
      mode = 1;
      println("Manhattan distance engaged.");
      newparams = true;
      break;
    }
    break;

  case 'w':
  case 'W':
    qual++;
    println("Quality: " + qual);
    newparams = true;
    break;

  case 's':
  case 'S':
    qual = (qual > 2) ? qual - 1 : qual;
    println("Quality: " + qual);
    newparams = true;
    break;

  case 'q':
  case 'Q':
    area = (area >= 100) ? area + 50 : area + 10;
    println("Area: " + area);
    newparams = true;
    break;

  case 'a':
  case 'A':
    area = (area >= 100) ? area - 50 : constrain(area-10, 10, area);
    println("Area: " + area);
    newparams = true;
    break;

  case 'e':
  case 'E':
  case '+':
  case '=':
    thresh = (thresh < 255.0 && thresh >= 5 ) ? thresh + 5 : constrain(thresh + 0.5, 0.5, 255.0);
    println("Thresh: " + thresh);
    break;

  case 'd':
  case 'D':
  case '-':
    thresh = (thresh > 5.0) ? thresh - 5 : constrain(thresh-0.5, 0.5, 255.0);
    println("Thresh: " + thresh);
    break;

  case 'c':
  case 'C':
    baffle = (baffle < 21.0 && baffle >= 1 ) ? baffle + 1 : constrain(baffle + 1, 1, 255);
    println("Baffle: " + baffle);
    break;

  case 'x':
  case 'X':
    baffle = (baffle > 1.0) ? baffle - 1 : constrain(baffle-1, 1, 255);
    println("Baffle: " + baffle);
    break;

  case 't':
  case 'T':
  case '0':
    if (!running) {
      if ((newpoints) || (newparams)) {
        println("New points detected.");
        doVor();
      }
      running  = true;
      println("Executing..");
      //      loop();
    } else {
      running = false;
      println("Stopping.");
      //      noLoop();
    }
    break;

  case 'R':
  case 'r':
    running = false;
    println("Resetting image and stopping.");
    img = loadImage(fileName);
    image(img, 0, 0, W, H);
    redraw();
    break;

  case 'G':
  case 'g':
    println("Exporting gif frames..");
    if (!saveFrames) {
      saveFrames = true;
      String[] saveGif;
      saveGif = split(fileName, '.');
      gifExport = new GifMaker(this, saveGif[0]+"_"+frameCount+"_vronoi.gif");
      gifExport.setRepeat(0);
      gifExport.setDelay(0);
    } else {
      saveFrames = false;
      gifExport.finish();
      println("Gif saved!");
    } 
    break;

  case ENTER:
  case RETURN:
    img.save(split(fileName, '.')[0] + "_man_"+frameCount+".png");
    println("Saved.");
    break;

  case 'P':
  case 'p':
    if (mousePoints) {
      mousePoints = false;
      println("Region disable mode engaged.");
    } else {
      mousePoints = true;
      println("Region define mode engaged.");
    }
    break;

  case 'i':
  case 'I':
    for (int i = 0; i < numSites-1; i++, enabled.set(i, !enabled.get(i)));
    println("Regions inverted.");
  break;

  case '8': // up
    direction = 1; 
    break;

  case '4': // left
    direction = 2; 
    break;

  case '2': // down
    direction = 3; 
    break;

  case '6': // right
    direction = 4; 
    break;

  case '7': // up left
    direction = 5;
    break;

  case '9': // up right
    direction = 6;
    break;

  case '1': // down left
    direction = 7;
    break;

  case '3': // down right
    direction = 8;
    break;
  }
}

void mousePressed()
{
  if (mousePoints) {
    if (running) {
      println("Stopping for new points.");
      running = false;
    }
    vertices.add(new PVector(mouseX, mouseY));
    println("New point at: " + mouseX + ", " + mouseY + ".");
    newpoints = true;
  } else {

    int clickedRegion = schain[mouseX+(mouseY*img.width)];
    if (enabled.get(clickedRegion) == true) {
      enabled.set(clickedRegion, false);
      println("Area " + clickedRegion + " disabled.");
    } else {
      enabled.set(clickedRegion, true);
      println("Area " + clickedRegion + " enabled.");
    }
  }
}

void selectedSource(File selection) { // selection code
  if (selection == null) {
    System.exit(0);
  } else {
    fileName = selection.getAbsolutePath();
    img = loadImage(fileName);
    W = (img.width > displayWidth) ? img.width/2:img.width;
    H = (img.height > displayHeight) ? img.height/2:img.height;

  }
}

void swap(int x, int y, int xc, int yc) {
  color c = img.pixels[x+(y*img.width)];
  img.pixels[x+(y*img.width)] =  img.pixels[xc+(yc*img.width)]*baffle;
  img.pixels[xc+((yc)*img.width)] = c + colorOffset;
}
