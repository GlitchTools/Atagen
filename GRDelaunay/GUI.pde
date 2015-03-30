

//file selection routine
void selectedSource(File selection) {
  if (selection == null) {
    exit();
  } else {
    fileName = split(selection.getAbsolutePath(), '.');
    orig = loadImage(fileName[0] + "." + fileName[1]);
    W = (orig.width < displayWidth-30) ? orig.width : (orig.width/4*3 < displayWidth-30) ? orig.width/4*3 : displayWidth-60;
    H = (orig.height < displayHeight-52) ? orig.height : (orig.height/4*3 < displayHeight-52) ? orig.height/4*3 : displayWidth-104;
    frame.setSize(W, H+22);
    size(W, H);
    makeGUI();
    ready = true;
    setVals();
  }
}


void delay(int delay)
{
  int time = millis();
  while (millis () - time <= delay);
}


void setVals() {
  area = (GArea.getValueI());
  qual = (GQual.getValueI());
  edgeO = (GEdgeO.getValueI());
  fillO = (GFillO.getValueI());
  edgeC = color(GEdgeCR.getValueI(), GEdgeCG.getValueI(), GEdgeCB.getValueI(), edgeO);
  fillC = color(GFillCR.getValueI(), GFillCG.getValueI(), GFillCB.getValueI(), fillO);
  lGArea.setText("Area: "+ str(area));
  lGQual.setText("Quality: "+ str(qual));
  Window.papplet.background(200);
}


void handleKnobEvents(GValueControl knob, GEvent event) {
  setVals();
  bang = false;
}



void btnExec(GButton button, GEvent event) {
  switch(vid) {
  case 1:
    gifExport = new GifMaker(this, fileName[0] + "_delaunay_ani_" + area + ".gif");
    gifExport.setDelay(0);
    gifExport.setRepeat(0);
    warmUp();
    for (int f = frames; f > 0; f--) {
      go();
      gifExport.addFrame();
      progress();
    }
    gifExport.finish();
    println("Saved as " + fileName[0] + "_delaunay_ani_" + area + ".gif");
    break;

  case 2:
    ani = Gif.getPImages(this, fileName[0]+"."+fileName[1]);
    gifExport = new GifMaker(this, fileName[0] + "_delauney_ani2.gif");
    gifExport.setDelay(0);
    gifExport.setRepeat(0);
    warmUp();
    for (int i = 0; i < ani.length; i++) {
      buffer = ani[i];
      go();
      gifExport.addFrame();
      progress();
    }
    gifExport.finish();
    println("Saved as " + fileName[0] + "_delauney_ani2.gif"); 
    break;

  default:
    warmUp();
    go(); 
    break;
  }
}

public void btnSave(GButton GSave, GEvent btnSave) {
  /*if (!bang) {
    go();
  }*/
  result.save(fileName[0]+"_delaunay_" + area + "_" + qual + "_" + cMode + ".png");
  println("Saved as " + fileName[0]+"_delaunay_" + area + "_" + qual + "_" + cMode + ".png.");
}


public void guiChangeS(GSlider source, GEvent guiChange) {
  setVals();
}

public void dropChange(GDropList source, GEvent dropChange) {
  setVals();
}


public void toggleChange(GOption source, GEvent toggleChange) {
  if (GEdge1.isSelected()) {
    edgeO = GEdgeO.getValueI();
    edgeC = color(0, 0, 0, edgeO); 
    image(orig, 0, 0);
  } else
    if (GEdge2.isSelected()) {
    setVals();
  }

  if (GFill1.isSelected()) {
    fillO = GFillO.getValueI();
    fillC = color(0, 0, 0, fillO);
    image(orig, 0, 0);
  } else
    if (GFill2.isSelected()) {
    setVals();
  }
  if (GCMode1.isSelected()) {
    cMode = 0;
  } else if (GCMode2.isSelected()) {
    cMode = 1;
  } else if (GCMode3.isSelected()) {
    cMode = 2;
  } else if (GCMode4.isSelected()) {
    cMode = 3;
  }

  if (GVid1.isSelected()) {
    vid = 0;
  } else 
    if (GVid2.isSelected()) {
    vid = 1;
  } else
    if (GVid3.isSelected()) {
    vid = 2;
  }
}

//GUI builds
void makeGUI() {
  G4P.messagesEnabled(false);
  frame.setTitle(".:: G//R Delaunay Filter");

  Window = new GWindow(this, ".:: G//R Delaunay Filter GUI", orig.width+(orig.width/5), orig.height/2, 600, 300, false, JAVA2D);
  Window.papplet.background(200);
  Window.setOnTop(false);

  GArea = new GSlider(Window.papplet, 80, -20, 500, 100, 10);
  GArea.setLimits(500, 2000, 1);
  GArea.setEasing(3.5);
  GArea.setNumberFormat(G4P.INTEGER, 0);
  GArea.addEventHandler(this, "guiChangeS");
  lGArea = new GLabel(Window.papplet, -10, 23, 100, 15);

  GQual = new GSlider(Window.papplet, 80, 0, 500, 100, 10);
  GQual.setLimits(5, 10, 1);
  GQual.setShowTicks(true);
  GQual.setNbrTicks(10);
  GQual.setStickToTicks(true);
  GQual.setEasing(2.0);
  GQual.setNumberFormat(G4P.INTEGER, 0);
  GQual.addEventHandler(this, "guiChangeS");
  lGQual = new GLabel(Window.papplet, -11, 45, 100, 15);

  GFillO = new GSlider(Window.papplet, 115, 80, 50, 100, 10);
  GFillO.setLimits(255, 0, 255);
  GFillO.setEasing(4.0);
  GFillO.setNumberFormat(G4P.INTEGER, 0);
  GFillO.addEventHandler(this, "guiChangeS");

  GEdgeO = new GSlider(Window.papplet, 45, 80, 50, 100, 10);
  GEdgeO.setLimits(255, 0, 255);
  GEdgeO.setEasing(4.0);
  GEdgeO.setNumberFormat(G4P.INTEGER, 0);
  GEdgeO.addEventHandler(this, "guiChangeS");

  GEdge = new GToggleGroup();
  GEdge.addControl(GEdge1 = new GOption(Window.papplet, 35, 75, 85, 12, "Orig. Edge"));
  GEdge.addControl(GEdge2 = new GOption(Window.papplet, 35, 90, 85, 12, "RGB Edge"));
  GEdge1.setSelected(true);
  GEdge1.addEventHandler(this, "toggleChange");
  GEdge2.addEventHandler(this, "toggleChange");

  GFill = new GToggleGroup();
  GFill.addControl(GFill1 = new GOption(Window.papplet, 110, 75, 65, 12, "Orig. Fill"));
  GFill.addControl(GFill2 = new GOption(Window.papplet, 110, 90, 65, 12, "RGB Fill"));
  GFill1.setSelected(true);
  GFill1.addEventHandler(this, "toggleChange");
  GFill2.addEventHandler(this, "toggleChange");

  GCMode = new GToggleGroup();
  GCMode.addControl(GCMode1 = new GOption(Window.papplet, 265, 75, 130, 20, "Normal Colour"));
  GCMode.addControl(GCMode2 = new GOption(Window.papplet, 265, 90, 130, 20, "Colour Flip"));
  GCMode.addControl(GCMode3 = new GOption(Window.papplet, 265, 105, 130, 20, "Rainbow mode"));
  GCMode.addControl(GCMode4 = new GOption(Window.papplet, 265, 120, 130, 20, "R'bow Invert"));
  GCMode1.setSelected(true);
  GCMode1.addEventHandler(this, "toggleChange");
  GCMode2.addEventHandler(this, "toggleChange");
  GCMode3.addEventHandler(this, "toggleChange");
  GCMode4.addEventHandler(this, "toggleChange");


  GVid = new GToggleGroup();
  GVid.addControl(GVid1 = new GOption(Window.papplet, 400, 150, 150, 12, "Static image"));
  GVid.addControl(GVid2 = new GOption(Window.papplet, 400, 165, 150, 12, "Static->animation"));
  GVid.addControl(GVid3 = new GOption(Window.papplet, 400, 180, 150, 12, "Process animation"));
  GVid1.setSelected(true);
  GVid1.addEventHandler(this, "toggleChange");
  GVid2.addEventHandler(this, "toggleChange");
  GVid3.addEventHandler(this, "toggleChange");

  GEdgeCR = new GKnob(Window.papplet, 50, 140, 40, 40, 1);
  GEdgeCR.setTurnRange(150, 270);
  GEdgeCR.setTurnMode(G4P.CTRL_ANGULAR);
  GEdgeCR.setArcPolicy(true, true, true);
  GEdgeCR.setLimits(127, 0, 255);
  GEdgeCR.setNbrTicks(9);
  GEdgeCR.setLocalColorScheme(G4P.RED_SCHEME);

  GEdgeCG = new GKnob(Window.papplet, 54, 140, 40, 40, 1);
  GEdgeCG.setTurnRange(270, 30);
  GEdgeCG.setTurnMode(G4P.CTRL_ANGULAR);
  GEdgeCG.setArcPolicy(true, true, true);
  GEdgeCG.setLimits(127, 0, 255);
  GEdgeCG.setNbrTicks(9);
  GEdgeCG.setLocalColorScheme(G4P.GREEN_SCHEME);

  GEdgeCB = new GKnob(Window.papplet, 52, 144, 40, 40, 1);
  GEdgeCB.setTurnRange(30, 150);
  GEdgeCB.setTurnMode(G4P.CTRL_ANGULAR);
  GEdgeCB.setArcPolicy(true, true, true);
  GEdgeCB.setLimits(127, 0, 255);
  GEdgeCB.setNbrTicks(9);
  GEdgeCB.setLocalColorScheme(G4P.BLUE_SCHEME);

  GFillCR = new GKnob(Window.papplet, 120, 140, 40, 40, 1);
  GFillCR.setTurnRange(150, 270);
  GFillCR.setTurnMode(G4P.CTRL_ANGULAR);
  GFillCR.setArcPolicy(true, true, true);
  GFillCR.setLimits(127, 0, 255);
  GFillCR.setNbrTicks(9);
  GFillCR.setLocalColorScheme(G4P.RED_SCHEME);

  GFillCG = new GKnob(Window.papplet, 124, 140, 40, 40, 1);
  GFillCG.setTurnRange(270, 30);
  GFillCG.setTurnMode(G4P.CTRL_ANGULAR);
  GFillCG.setArcPolicy(true, true, true);
  GFillCG.setLimits(127, 0, 255);
  GFillCG.setNbrTicks(9);
  GFillCG.setLocalColorScheme(G4P.GREEN_SCHEME);

  GFillCB = new GKnob(Window.papplet, 122, 144, 40, 40, 1);
  GFillCB.setTurnRange(30, 150);
  GFillCB.setTurnMode(G4P.CTRL_ANGULAR);
  GFillCB.setArcPolicy(true, true, true);
  GFillCB.setLimits(127, 0, 255);
  GFillCB.setNbrTicks(9);
  GFillCB.setLocalColorScheme(G4P.BLUE_SCHEME);

  lGDraws = new GLabel(Window.papplet, 62, 190, 80, 12);
  lGDraws.setText("Draw options");

  GWeight = new GTextField(Window.papplet, 115, 225, 22, 20, 0);
  GWeight.setText("1");
  lGWeight = new GLabel(Window.papplet, 85, 210, 80, 12);
  lGWeight.setText("Line weight");

  GFrame = new GTextField(Window.papplet, 145, 225, 22, 20, 0);
  GFrame.setText("25");
  lGFrame = new GLabel(Window.papplet, 130, 250, 60, 12);
  lGFrame.setText("Frames");

  lGProgs = new GLabel(Window.papplet, 270, 185, 150, 20);
  lGProgs.setText("Animation Options");
  GAProg = new GTextField(Window.papplet, 300, 225, 22, 20, 0);
  GAProg.setText("0");
  lGAProg = new GLabel(Window.papplet, 290, 205, 40, 20);
  lGAProg.setText("+Area");
  GWProg = new GTextField(Window.papplet, 340, 225, 22, 20, 0);
  GWProg.setText("0");
  lGWProg = new GLabel(Window.papplet, 320, 245, 60, 20);
  lGWProg.setText("+Weight");

  GExec = new GButton(Window.papplet, 400, 80, 100, 30, "Delaunayise..");
  GExec.addEventHandler(this, "btnExec");

  GSave = new GButton(Window.papplet, 400, 115, 100, 30, "Save file.");
  GSave.addEventHandler(this, "btnSave");
  //setVals();
}
