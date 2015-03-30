/*G/R Delaunay Filter v3 ***************************************\
 | ---------------------------                                   |
 | Original code by Ale González, 2013.                          |
 | Modified for G l i t c h / / R e q u e s t, 2014.             |
 | https://www.facebook.com/groups/glitchrequest/438057916331995/|
 | Additional code, concepts, debugging by:                      |
 | Clif Pottberg, rob mac, Adam Tuerff.                          |
 | GUI by rob mac.                                               |
 | Implements G4P and gifAnimation libraries.                    |
 | (use Sketch->Import Library->Add Library..)                   |
 | Then simply run the sketch and the GUI will handle the rest.  |
 \_Enjoy.********************************************************/


/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/117808*@* 
 !do not delete the line above, required for linking your tweak if you upload again */


import java.util.List;
import java.util.LinkedList;
import gifAnimation.*;
import g4p_controls.*;

int W, H;
boolean bang = false;
boolean ready = false;
boolean clean = false;
int[] colors;
int[] flips;
PImage orig, buffer;
PImage[] ani;
PGraphics result, bk;
ArrayList<Triangle> triangles;

GWindow Window;
GToggleGroup GEdge, GFill, GTPasc, GVid, GCMode;
GSlider GArea, GQual, GEdgeO, GFillO;
GKnob GEdgeCR, GEdgeCG, GEdgeCB, GFillCR, GFillCG, GFillCB;
GTextField GWig, GWeight, GAProg, GFrame, GWProg;
GOption GEdge1, GEdge2, GFill1, GFill2, GCMode1, GCMode2, GCMode3, GCMode4, GVid1, GVid2, GVid3; 
GButton GExec, GSave;
GLabel lGEdge, lGArea, lGQual, lGEdgeC, lGFill, lGWeight, lGFrame, lGProgs, lGDraws, lGAProg, lGWProg;
GifMaker gifExport;

void setup() 
{
  size(100, 100);
  frame.setResizable(true);
  frameRate(30);
  smooth(2);
  selectInput("Select an Image File", "selectedSource");
}

void go() {
  //Load our image
  buffer = orig;
  //Extract significant points of the picture
  ArrayList<PVector> vertices = new ArrayList<PVector>();
  EdgeDetector.extractPoints(vertices, buffer, EdgeDetector.SOBEL, area, qual);

  //Get the triangles using qhull algorithm. 
  //The algorithm is a custom refactoring of Triangulate library by Florian Jennet (a port of Paul Bourke... not surprisingly... :D) 
  triangles = new ArrayList<Triangle>();
  new Triangulator().triangulate(vertices, triangles);

  //Prune triangles with vertices outside of the canvas.
  Triangle t = new Triangle();
  for (int i=0; i < triangles.size (); i++) {
    t = triangles.get(i); 
    if (vertexOutside(t.p1) || vertexOutside(t.p2) || vertexOutside(t.p3)) triangles.remove(i);
  }

  //Get colors from the triangle centers
  int tSize = triangles.size();
  colors = new int[tSize*3];
  PVector c = new PVector();

  for (int i = 0; i < tSize; i++) {
    c = triangles.get(i).center();
    colors[i] = buffer.get(int(c.x), int(c.y));
  }
  if (cMode == 1) {
    flips = new int[tSize*3];
    for (int i = 0; i < tSize; i++) {
      c = triangles.get(i).center();
      flips[i] = (buffer.get(int(c.y), int(c.x)) == 0) ? buffer.get(int(c.x), int(c.y)) : buffer.get(int(c.y), int(c.x));
    }
  }

  //And display the result
  //  blendMode(blend);
  displayMesh();
  //  blendMode(BLEND);
}

//Util function to prune triangles with vertices out of bounds  
boolean vertexOutside(PVector v) { 
  return v.x < 0 || v.x > buffer.width || v.y < 0 || v.y > buffer.height;
}  


//Display the mesh of triangles  
void displayMesh()
{
  result = createGraphics(buffer.width, buffer.height);
  result.beginDraw();
//  bk.loadPixels();
  result.loadPixels();
//  arrayCopy(bk.pixels, result.pixels);
  result.strokeWeight(weight);
  Triangle t = new Triangle();
  result.beginShape(TRIANGLES);
  switch(cMode) {
  case 1:
    for (int i = 0; i < triangles.size (); i++) {
      t = triangles.get(i); 
      if (fillO > 0) result.fill(flips[i], fillO);
      else noFill();
      edgeC = (GEdge2.isSelected()) ? flips[i] : color((flips[i] >> 16) & 0xFF, (flips[i] >> 8) & 0xFF, flips[i] & 0xFF, edgeO);
      result.stroke(edgeC);
      result.vertex(t.p1.x, t.p1.y);
      result.vertex(t.p2.x, t.p2.y);
      result.vertex(t.p3.x, t.p3.y);
    }  
    break;

  case 2: // rainbow mode
  case 3: // rainbow mode invert
    for (int i = 0; i < triangles.size (); i++) {
      t = triangles.get(i); 
      if (fillO > 0) result.fill(randomColor());
      else noFill();
      edgeC = (GEdge2.isSelected()) ? randomColor() : color((colors[i] >> 16) & 0xFF, (colors[i] >> 8) & 0xFF, colors[i] & 0xFF, edgeO);
      result.stroke(edgeC);
      result.vertex(t.p1.x, t.p1.y);
      result.vertex(t.p2.x, t.p2.y);
      result.vertex(t.p3.x, t.p3.y);
    }
    break;

  default:
    for (int i = 0; i < triangles.size (); i++) {
      t = triangles.get(i);
      /* if (fillO > 0) {*/      fillC = (GFill2.isSelected()) ? colors[i] : color((colors[i] >> 16) & 0xFF, (colors[i] >> 8) & 0xFF, colors[i] & 0xFF, fillO);
      result.fill(fillC); /*}
       else noFill();*/
      edgeC = (GEdge2.isSelected()) ? colors[i] : color((colors[i] >> 16) & 0xFF, (colors[i] >> 8) & 0xFF, colors[i] & 0xFF, edgeO);
      result.stroke(edgeC);
      result.vertex(t.p1.x, t.p1.y);
      result.vertex(t.p2.x, t.p2.y);
      result.vertex(t.p3.x, t.p3.y);
    }
    break;
  }
  result.endShape();
  result.endDraw();
  background(255);
  image(result, 0, 0, width, height);
}  

void draw() {
  delay(200);
  //display stuff for colour selectors
  if ((!bang) && (ready)) {
    image(orig, 0, 0, width, height);
    if (GEdge2.isSelected()) {
      fill(edgeC, edgeO);
      rect(20, 10, 30, 30);
    }
    if (GFill2.isSelected()) {
      fill(fillC, fillO);
      rect(60, 10, 30, 30);
    }
  }
}

void warmUp() {
  weight = int(GWeight.getText());
  frames = int(GFrame.getText());
  aprog = int(GAProg.getText());
  wprog = int(GWProg.getText());
  setVals();
  bang = true;
}

void progress() { //progressive exec for animation loop
  area = area + aprog;
  weight = weight + wprog;
}

//random colour generator code
color randomColor() {
  if (GCMode4.isSelected()) { // if we're in invert rainbow, take fillC as max value
    return color(random(0, (fillC >> 16) & 0xFF), random(0, (fillC >> 8) & 0xFF), random(0, fillC & 0xFF), fillO);
  } else { // otherwise take it as min
    return color(random((fillC >> 16) & 0xFF, 255), random((fillC >> 8) & 0xFF, 255), random(fillC & 0xFF, 255), fillO);
  }
}
