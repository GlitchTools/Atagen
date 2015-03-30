// All these parameters are operatable from the GUI.
// Any parameters here not included in GUI are legacy
// and may not function as expected, if at all.


String[] fileName;
String altImg = "";
int area = 500; // size of filter area
int qual = 5; // sharpness of edge detection, 1 is sharpest

color edgeC = color(0, 0, 0); // edge colour if using RGB edge or rainbow mode
int edgeO = 255; // edge opacity
color fillC = color(0, 0, 0); // fill colour as above
int fillO = 255; // fill opacity
int bgO = 255; // background opacity
int bgS = 0; // background chooser, 0 blank/transparent, 1 original image, 2 alternate image, 3 clean render

int xOf = 0; // horizontal redraw offset
int yOf = 0; // vertical redraw offset
int cMode = 0; // color mode, 0 normal, 1 xy colour sample flip, 2 rainbow mode, 3 invert
int weight = 1; //line drawing weight - min 1
int blend = BLEND; // blend mode value
int stroke = MITER; // stroke join mode
// hmm.. int tpasc = 0; // only allow second pass fills if 1 greater, 2 lesser (0 all)


//animation options
int vid = 0; //enable animation - 1 animated processing of static image, 2 animation processing
int aprog = 0; //increases or decreases area per frame
int wprog = 0; // as above, for line weight
int frames = 25; //number of frames to bounce
