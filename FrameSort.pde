// img blur + asdfsort
// rob mac, 2014
//import processing.img.*;
import java.io.*;
import java.io.File;
// Main configuration
String basedir = "/Volumes/Data/temp/working"; // Specify the directory in which the frames are located. Use forward slashes.
String fileext = ".png"; // Change to the format your images are in.

int dec = 4; //how many numerals in the names (for framecount). be careful
//Movie img;
int thresh = 200; // threshold
boolean inv = true; // invert sort
int wig = 0; // sorting wigouts
String fileNames[];
PImage img;
java.io.File folder = new java.io.File(dataPath(basedir));
java.io.FilenameFilter extfilter = new java.io.FilenameFilter() {
  boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(fileext);
  }
};


void setup() {
  size(200, 200);
  fileNames = folder.list(extfilter);
}

void draw() {
  for (int f = 0; f < fileNames.length-1; f++) {
    img = loadImage(basedir+"/"+fileNames[f]);
    img.loadPixels();   
    int pos = 0;
    int thr = thresh + int(random(0-thresh/20, thresh/20));
    
    for (int x = 0; x < img.width; x++) {
      pos = 0;
      for (int y = 0; y < img.height; y++) {

        if (!inv) {
          if (brightness(img.pixels[x+(y*img.width)]) < thr) {
            int leng = y-pos;
            int moves = 1;
            color temp[] = new color[leng];
            for (int i = 0; i < leng-1; i++) {
              temp[i] = img.pixels[x+((y-leng+i)*img.width)];
            }
            while (moves > 0) {
              moves = 0;
              for (int i = 0; i < leng-1; i++) {
                if (temp[i] > temp[i+1]) {
                  color t = (wig>1) ? temp[i+1]-(wig<<8) : temp[i+1];
                  temp[i+1] = temp[i];
                  temp[i] = t;
                  moves++;
                }
              }
            }
            for (int i = 0; i < leng-1; i++) {
              img.pixels[x+((y-leng+i)*img.width)] = temp[i];
            }
            pos = y;
          }
        } else {

          if (brightness(img.pixels[x+(y*img.width)]) > thr) {
            int leng = y-pos;
            int moves = 1;
            color temp[] = new color[leng];
            for (int i = 0; i < leng-1; i++) {
              temp[i] = img.pixels[x+((y-leng+i)*img.width)];
            }
            while (moves > 0) {
              moves = 0;
              for (int i = leng-2; i > 0; i--) {
                if (temp[i] < temp[i+1]) {
 //                 color t = temp[i+1];
                  color t = (wig>1) ? temp[i+1]+(wig<<24/2) : temp[i+1];

                  temp[i+1] = temp[i];
                  temp[i] = t;
                  moves++;
                }
              }
            }
            for (int i = 0; i < leng-1; i++) {
              img.pixels[x+((y-leng+i)*img.width)] = temp[i];
            }
            pos = y;
          }
        }
      }
    }
    img.save(basedir+"/frames/"+nf(f, dec)+".png");
    println("done frame "+f);
    wig = (wig > 1) ? wig+int(random(wig)): wig;
  }
  println("done");
  noLoop();
  System.exit(0);
}
