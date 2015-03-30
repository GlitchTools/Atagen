
boolean moveit = false;
boolean overwrite = true;
float thresh = 40;

int video_width = 640; 
int video_height = 480; 
int pass = 1;
int video_slice_x = video_width/2; 
int window_width;
int window_height = video_height; 
int draw_position_x = 0; 
boolean newFrame = false; 
void setup() {   
  window_width = (video_width*2 < displayWidth) ? video_width*2 : displayWidth;
  size(window_width, window_height);   
  background(0);
} 

void draw() {   
  PImage myVideo = loadImage("http://192.168.0.10:8080/shot.jpg");
  loadPixels();     
  for (int y=0; y<window_height; y++) {       
    int setPixelIndex = y*(window_width) + draw_position_x;       
    int getPixelIndex = y*(video_width) + video_slice_x;
    if (pass % 2 != 0) {
      if (overwrite && brightness(pixels[setPixelIndex])-thresh > brightness(myVideo.pixels[getPixelIndex])) {
      } else {
        pixels[setPixelIndex] = myVideo.pixels[getPixelIndex];
      }
    } else {
      if (overwrite && brightness(pixels[setPixelIndex])-thresh < brightness(myVideo.pixels[getPixelIndex])) {
      } else {
        pixels[setPixelIndex] = myVideo.pixels[getPixelIndex];
      }
    }
  }
  updatePixels();          
  draw_position_x++;     
  if (moveit && video_slice_x > video_width/2 + video_width/4) {
    video_slice_x--;
  } else if (moveit) {
    video_slice_x++;
  }

  if (draw_position_x >= window_width) {  
    saveFrame("slitscan-####.png"); 
    pass++;    
    draw_position_x = 0;
  }
}
