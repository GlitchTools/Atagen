void doVor() {
  println("Mapping..");
  if (newparams) {
    vertices.clear();
    enabled.clear();
    if (newpoints) println("Custom regions will be purged.");
    schain = new int[img.width*img.height];
    EdgeDetector.extractPoints(vertices, img, EdgeDetector.SOBEL, area, qual);
  }

  numSites = vertices.size();

  for (int i = 0; i < numSites; i++) 
  {
    enabled.add(new Boolean(true));
  }

  for (int y = 0; y < img.height; y++) {   
    for (int x = 0; x < img.width; x++) {

      float minDistance = Float.MAX_VALUE;
      int closestIndex = 0;

      for (int i = 0; i < numSites; i++) {
        float distance;
        switch(mode) {
        case 1: //manhattan
          distance = abs(vertices.get(i).x - x) + abs(vertices.get(i).y - y);
          break;
        default: //ordinary
          distance = dist(x, y, vertices.get(i).x, vertices.get(i).y);
          break;
        }
        if (distance < minDistance) {
          closestIndex = i;
          minDistance = distance;
        }
      } //numSites
      schain[x+(y*img.width)] = closestIndex;
    }// y loop
  } // x loop

  newpoints = false;
  newparams = false;
  done = true;
  println("Mapped " + vertices.size() + " regions.");
}
