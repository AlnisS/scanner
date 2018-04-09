import processing.video.*;

Capture cam;

float mousePressedX = 1;
float mousePressedY = 1;

void setup() {
  size(640, 480);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[1]);
    cam.start();     
  }      
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  //image(cam, 0, 0);
  //background(0);
  image(cam, 0, 0);
  noStroke();
  fill(0, 0, 0, 127);
  //rect(0, 0, width, height);
  
  PImage tempimg = cam.copy();
  /*
  tempimg.loadPixels();
  for(int i = 0; i<tempimg.pixels.length; i++) {
    boolean iswhite = red(tempimg.pixels[i])+green(tempimg.pixels[i])+blue(tempimg.pixels[i]) > 200;
    color c;
    if(iswhite) c = color(255);
    else c = color(0);
    tempimg.pixels[i] = c;
  }
  */
  //tempimg.filter(BLUR, 2);
  //tempimg.filter(THRESHOLD, .35);
  image(tempimg, 0, 0);
  
  stroke(color(0, 255, 0));
  for(int i = 0; i < height; i++) {
    //int i = 200;
    ArrayList<Integer> fulledges = getHorizontalEdges(tempimg, i);
    ArrayList<Integer> edges = filterArrayList(fulledges, 2, 6);
    int redge = 0;
    if(edges.size() != 0) redge = edges.get(0);
    int p = 0;
    if(redge != 0) p = getCenterFromEdge(fulledges, redge);
    //line(redge, 0, redge, height-1);
    line(p, 0, p, height-1);
    //line(0, 200, width-1, 200);
    /*
    for(int it: edges) {
      line(it, 0, it, height-1);
    }
    */
  }
  //color[] temp = getPixelLine(mousePressedX, mousePressedY, mouseX, mouseY, 400, cam);
  //drawPixelLine(mousePressedX, mousePressedY, mouseX, mouseY, temp);
  //float averagex = 0;
  //float valcount = 0;
  
  //for(int i = 0; i < height; i++) {
    
  //  //int i = 200;
  //  color[] temp = getPixelLine(0, i, cam.width-1, i, cam.width, cam);
  //  //drawPixelLine(0, i, cam.width-1, i, temp);
  //  float tempx = patternFinder(temp);
  //  if(tempx != 0.0) {
  //    averagex = (averagex * valcount + tempx) / (valcount + 1);
  //    valcount++;
  //  }
  //}
  //stroke(color(0, 255, 0));
  //line(averagex, 0, averagex, height-1);
  ////println(averagex);
  //color[] temp = getPixelLine(averagex, 0, averagex, height-1, cam.height, cam);
  //float tempy = patternFinder(temp);
  //line(0, tempy, width-1, tempy);
  //println(tempy);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}

void mousePressed() {
  mousePressedX = mouseX;
  mousePressedY = mouseY;
}