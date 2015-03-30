/*
  An algorithm that uses a custom implementation of a Sobel/Scharr operator to get the significant points of a picture.
 */

static class EdgeDetector
{
  static final int [][][] OPERATOR  = new int[][][] {
    { 
      {
        2, 2, 0
      }
      , { 
        2, 0, -2
      }
      , {
        0, -2, -2
      }
    }
    , //Sobel kernel
    { 
      {
        6, 10, 0
      }
      , {
        10, 0, -10
      }
      , {
        0, -10, -6
      }
    }   //Scharr kernel
  };
  static final int SOBEL = 0, SCHARR = 1;  //Indexes of the kernels in the previous array

  //This method add significant points of the given picture to a given list
  static void extractPoints(List <PVector> vertices, PImage img, int op, int treshold, int res) 
  {     
    int col = 0, colSum = 0, W = img.width-1, H = img.height-1;

    //For any pixel in the image excepting borders            
    for (int Y = 1; Y < H; Y += res) for (int X = 1; X < W; X += res, colSum = 0) 
    {
      //Convolute surrounding pixels with desired operator       
      for (int y = -1; y <= 1; y++) for (int x = -1; x <= 1; x++, col = img.get ( (X+x), (Y+y))) 
        colSum += OPERATOR[op][x+1][y+1] * ((col>>16 & 0xFF)+(col>>8 & 0xFF)+(col & 0xFF));               
      //And if the resulting sum is over the treshold add pixel position to the list
      if (abs(colSum) > treshold) vertices.add(new PVector(X, Y));
    }
  }
}    
