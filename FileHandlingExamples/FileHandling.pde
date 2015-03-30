
import gifAnimation.*; // you need this library, use sketch->import library->add library to install it.
import java.io.*; // import io stuff
import java.io.File; // import file stuff specifically (not imported by *)

String path = "/Look/At/This/File/Path/Wow"; // your directory path
String[] fileNames; // empty array to store filenames in
PImage image; // a temporary image on which to operate
Gif GifRead; // instantiate the gifAnimation classes - a reader..
GifMaker GifWrite; // ..and a writer


java.io.FilenameFilter extfilter = new java.io.FilenameFilter() { // our filename filter
  // this is applied to the directory path to retreive+filter out a list of compatible files
  // of course, you may change the criteria to whatever you wish
  boolean accept(File dir, String name) {
    if (name.toLowerCase().endsWith("gif")) return true;
    else return false;
    /* the above code is better because it allows for more options using && or || operators
     however a cleaner version for single filenames would be simply:
     return name.toLowerCase().endsWith("gif");
     the "endsWidth" function can be passed directly, as it will return a boolean anyway */
  }
}; 

void setup() {
  size(200, 200);
  // normally the GifWrite stuff would go in here - I haven't tested it in the main loop tbh
  // we just use an arbitrary size since nothing occurs in display window
}

void draw() {
  java.io.File folder = new java.io.File(dataPath(path)); // set up a File object for the directory
  fileNames = folder.list(extfilter); // fill the fileNames string array with the result of filtering the directory listing eg. compatible files to our filter

    for (int f = 0; f < fileNames.length; f++) { // loop off the length of the filled filename array

    //now we set up our gif writer - as noted this would usually be in the setup and is untested in draw, but should work fine
    //there is some trickery here in order to get the filename right, not overwrite, and keep it dynamic
    //note also that for static images there is a cleaner method demonstrated below to handle the filename
    String temp[] = split(fileNames[f], '.'); // first we fill a string array with all the parts of the filename as separated by fullstops '.'
    temp[split(fileNames[f], '.').length-1] = "_done.gif"; // then we take the last entry of the filename eg. the file extension, and append something before it
    String writename = join(temp, '.'); // then we rejoin all the parts of the filename using the fullstops that would separate them (in case they were named 'file.001.gif' or something)
    GifWrite = new GifMaker(this, path + writename); // set the export filename
    GifWrite.setRepeat(0); // export a looping animation
    GifWrite.setDelay(0); // 0s delay on each frame

    //now for the gif reader to fill an array of PImages with all the frames of the gif
    PImage[] animation = GifRead.getPImages(this, fileNames[f]);

    for (int p = 0; p < animation.length-1; p++) { // now we loop through all the frames of this gif..    
      image = animation[p]; // fill the buffer with the current frame to process
      image.loadPixels(); 
      //    image.yourFunctionHere(); // obviously whatever you want to do to frames is executed here on your temporary image
      image.updatePixels();
      GifWrite.addFrame(image); // add the temporary image as a frame to the current gif
    }

    GifWrite.finish(); // finish this GIF; close writer off for now, save output to the earlier defined savepath

    /* if this were not for gifs and we simply used a file selection routine such as selectInput(), here is how we could handle the savepath in a better way using regex:
     
     String savepath;
     savepath = path.replaceFirst("[.][^.]+$", "_done.png"); // automatically finds the text after the last '.' fullstop and replaces it. replaceFirst still works because it's the first occurance of the last fullstop - if that makes sense
     image.save(savepath);
     println("Done! File at " + savepath);
     
     */
  } // filename loop completed - okay we're all done
  exit(); // close the program otherwise it'll just hang open doing nothing
}
