// OBJ exporting delaunay script
// q/w to adjust Quality
// +/- to adjust Area
// z to turn OBJ export on/off
// atagen 2015
import nervoussystem.obj.*;
// Main configuration

import java.util.List;
import java.util.LinkedList;
// dimensions of your window, not the image
int w = 1024;
int h = 768;
// filename
String filename = "citywobble2.jpg";
// don't mess w this
boolean export = false;
float high = 100;
// default area/quality
int area = 1000;
int qual = 8;
// blah blah blah
color[] colors;
ArrayList<Triangle> triangles;
PGraphics pg;
PImage input;

void setup()
{
  smooth(8);
  input = loadImage(filename);
  size(w, h);
  pg = createGraphics(input.width, input.height);
  doThis(input);
}

void draw() {
}

void keyPressed() {
  if (key == ' ') doThis(input);
  else {
    if (key == 'q') area-=5;
    if (key == 'w') area+=5;
    if (key == 'a') if(qual>2)qual--;
    if (key == 's') qual++;
    if (key == 'z') export=!export;
    println("Area: "+area+". Quality: "+qual+". Export: "+export+".");
  }
}

void doThis(PImage buffer) {
  println("Triangulating. Area: " + area + ". Quality: " + qual + ".");
  //Extract significant points of the picture
  ArrayList<PVector> vertices = new ArrayList<PVector>(); 
  EdgeDetector.extractPoints(vertices, buffer, EdgeDetector.SOBEL, area, qual); 
  //Add some points in the border of the canvas to complete all space
  for (float i = 0, h = 0, v = 0; i<=1; i+=.05, h = width*i, v = height*i) {
    vertices.add(new PVector(h, 0)); 
    vertices.add(new PVector(h, input.height)); 
    vertices.add(new PVector(0, v)); 
    vertices.add(new PVector(input.width, v));
  }

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

  //And display the result
  displayMesh();
}

//Util function to prune triangles with vertices out of bounds 
boolean vertexOutside(PVector v) { 
  return v.x < 0 || v.x > input.width || v.y < 0 || v.y > input.height;
} 

//Display the mesh of triangles 
void displayMesh()
{
  g.clear();
  pg.clear();
  pg.beginDraw();
  Triangle t = new Triangle(); 

  if (export) {
    println("Exporting..");
    OBJExport obj = (OBJExport) createGraphics(10, 10, "nervoussystem.obj.OBJExport", "output.obj");
    obj.setColor(true);
    obj.beginDraw();
    obj.beginShape(TRIANGLES);
    for (int i = 0; i < triangles.size (); i++)
    {
      t = triangles.get(i); 
      obj.fill(colors[i]); 
      obj.stroke(colors[i]); 
      obj.vertex(t.p1.x, t.p1.y, map(brightness(input.get((int)t.p1.x, (int)t.p1.y)), 0, 255, 0, high)); 
      obj.vertex(t.p2.x, t.p2.y, map(brightness(input.get((int)t.p2.x, (int)t.p2.y)), 0, 255, 0, high)); 
      obj.vertex(t.p3.x, t.p3.y, map(brightness(input.get((int)t.p3.x, (int)t.p3.y)), 0, 255, 0, high));
    }
    obj.endShape();
    obj.endDraw();
    obj.dispose();
    export=!export;
  }

  pg.beginShape(TRIANGLES); 
  for (int i = 0; i < triangles.size (); i++)
  {
    t = triangles.get(i); 
    pg.fill(colors[i]); 
    pg.stroke(colors[i]); 
    pg.vertex(t.p1.x, t.p1.y); 
    pg.vertex(t.p2.x, t.p2.y); 
    pg.vertex(t.p3.x, t.p3.y);
  }
  pg.endShape();
  pg.endDraw();
  image(pg, 0, 0, w, h);
  pg.save("DONE-"+random(2000)+".png");
  println("Done.");
} 

