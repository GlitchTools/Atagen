PImage img;
PImage[] waste;
boolean sized = false;
boolean ready = false;
int W, H;
String[] fileName;
int its = 25;
void setup() {
  if (!sized) {
    size(100, 100);
    frame.setResizable(true);
    smooth();
    selectInput("Select an Image File", "selectedSource");
    while (img == null) {
      delay(200);
    }
    sized = true;
  }
  frame.setSize(W, H);
 // size(W, H, P2D);
   size(W, H, P3D);
  image(img, 0, 0);
  ready = true;
//  blendMode(MULTIPLY);
}

void delay(int delay)
{
  int time = millis();
  while (millis () - time <= delay);
}

void selectedSource(File selection) { // selection code
  if (selection == null) {
    System.exit(0);
  } else {
    fileName = split(selection.getAbsolutePath(), '.');
    waste = new PImage[its];
    for (int o = 0; o < its; o++) {
      waste[o] = loadImage(selection.getAbsolutePath());
      image(waste[o], 0, 0);
    }
    img = loadImage(selection.getAbsolutePath());
    W = img.width;
    H = img.height;
  }
}
