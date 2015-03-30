import java.io.*;
import java.io.File;


String path;
String dpath;
String[] fileNames;
PImage image;
boolean conv;
boolean s1 = false;

boolean dir = false;
boolean done = false;
boolean space = false;
boolean load = false;
String W = "";
String H = "";

java.io.FilenameFilter extfilter = new java.io.FilenameFilter() {
  boolean accept(File dir, String name) {
    if (!conv) {
      if ((name.toLowerCase().endsWith("jpg")) || (name.toLowerCase().endsWith("jpeg"))
        || (name.toLowerCase().endsWith("png")) || (name.toLowerCase().endsWith("gif"))
        || (name.toLowerCase().endsWith("bmp")))  return true;
    } else if (name.toLowerCase().endsWith("hsb")) return true;
    return false;
  }
};

void setup() {
  colorMode(HSB, 255);
  selectInput("Select target", "selectedSource");
  size(200, 50);
  textSize(14);
}

void selectedSource(File selection) {
  if (selection == null) {
    exit();
  } else {
    path = selection.getAbsolutePath();
    if (match(split(path, '.')[split(path, '.').length-1], "hsb") != null) { 
      conv = true;
    } else conv = false;
    load = true;
  }
}

void draw() {
  background(0);
  this.requestFocus();
  if (done) {
    if (!conv) { // we're encoding
      if (!dir) { //single image only
        image = loadImage(path);
        image.loadPixels(); 
        int len = image.pixels.length-1;
        byte[][] data = new byte[len][3];
        for (int i = 0; i < len; i++) {
          data[i][0] = byte(hue(image.pixels[i])-128);
          data[i][1] = byte(saturation(image.pixels[i])-128);
          data[i][2] = byte(brightness(image.pixels[i])-128);
        }
        byte[] write = new byte[len*3];
        String savepath;
        for (int i = 0; i < len; i++) {
          for (int o = 0; o < 3; o++) {
            write[i*3+o] = data[i][o];
          }
        }
        savepath = path.replaceFirst("[.][^.]+$", ".hsb");
        saveBytes(savepath, write);
        // println("Done! File at " + savepath);
        exit();
      } else { // directory
        dpath = path;
        java.io.File folder = new java.io.File(dataPath(dpath));
        fileNames = folder.list(extfilter);
        for (int f = 0; f < fileNames.length; f++) {
          path = dpath + fileNames[f];
          image = loadImage(path);
          image.loadPixels(); 
          int len = image.pixels.length-1;
          byte[][] data = new byte[len][3];
          for (int i = 0; i < len; i++) {
            data[i][0] = byte(hue(image.pixels[i])-128);
            data[i][1] = byte(saturation(image.pixels[i])-128);
            data[i][2] = byte(brightness(image.pixels[i])-128);
          }
          byte[] write = new byte[len*3];
          String savepath;
          for (int i = 0; i < len; i++) {
            for (int o = 0; o < 3; o++) {
              write[i*3+o] = data[i][o];
            }
          }
          savepath = path.replaceFirst("[.][^.]+$", ".hsb");
          saveBytes(savepath, write);
          // println("Done! File at " + savepath);
        }
        exit();
      }
    } else { // we're decoding
      if (!dir) { // single file
        byte[] read = loadBytes(path);
        PGraphics out = createGraphics(int(W), int(H));
        out.beginDraw();
        out.loadPixels();
        int p;
        for (int i = 0; i < read.length; p = constrain (i, 0, (read.length)-3), out.pixels[constrain(i/3, 0, out.pixels.length-1)] = color (int (read[p]+126), int(read[p+1]+126), int(read[p+2]+126)), i=i+3);

        out.updatePixels();
        String outpath = path.replaceFirst("[.][^.]+$", "_hsb.png");
        out.endDraw();
        out.save(outpath);
        // println("Done! File at " + outpath);
        exit();
      } else { // directory
        dpath = path;
        java.io.File folder = new java.io.File(dataPath(dpath));
        fileNames = folder.list(extfilter);
        // println(fileNames.length);
        for (int f = 0; f < fileNames.length; f++) {
          path = dpath + fileNames[f];
          byte[] read = loadBytes(path);
          PGraphics out = createGraphics(int(W), int(H));
          out.beginDraw();
          out.loadPixels();
          int p;
          for (int i = 0; i < read.length; p = constrain (i, 0, (read.length)-3), out.pixels[constrain(i/3, 0, out.pixels.length-1)] = color (int (read[p]+126), int(read[p+1]+126), int(read[p+2]+126)), i=i+3);

          out.updatePixels();
          String outpath = path.replaceFirst("[.][^.]+$", "_hsb.png");
          out.endDraw();
          out.save(outpath);
          out.clear();
         // println("Done! File at " + outpath);
        }
        exit();
      }
    }
  } else { // run loop
    if (load && !s1) {
      text("Z - single file", 10, 20); 
      text("X - directory", 10, 40); 
//      noLoop();
    } else if (s1) {
      textSize(11);
      text("Type the width & height, separated & finished with a space.", 0, 5, 200, 50);
//      noLoop();
    }
  }
}

void keyPressed() {
  if (!s1) {
    if (key == 'z' || key == 'Z') {
      dir = false; 
      s1 = true;
    } else if (key == 'x' || key == 'X') {
      dir = true;
      String temp[] = split(path, java.io.File.separator);
      temp[split(path, java.io.File.separator).length-1] = "";
      path = join(temp, java.io.File.separator);
      s1 = true;
    }
    if (!conv) {      
      done = true;
    }
    loop();
  } else {
    if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5'  || key == '6' || key == '7' || key == '8' || key == '9' || key == '0') {
      if (!space) W = W + key; 
      else H = H + key;
    } else if (key == ' ') {
      if (!space && W != "") space = true;
      else if (H != "") {
        done=true; 
        loop();
      }
    }
  }
}
