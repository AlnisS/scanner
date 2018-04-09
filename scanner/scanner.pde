import processing.video.*;

Capture cam;

float mousePressedX = 1;
float mousePressedY = 1;
int globalerror = 7;
int globalminimum = 4;
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
  image(cam, 0, 0);
  noStroke();
  fill(0, 0, 0, 127);
  PImage tempimg = cam.copy();
  image(tempimg, 0, 0);
  stroke(color(0, 255, 0));
  fill(color(0, 255, 0));
  PVector coords = getTarget(tempimg, globalerror, globalminimum);
  rect(coords.x-3, coords.y-3, 6, 6);
}
void keyPressed() {
  switch(key) {
    case 'q': globalerror++;
              break;
    case 'a': globalerror--;
              break;
    case 'w': globalminimum++;
              break;
    case 's': globalminimum--;
              break;
  }
  println(globalerror, globalminimum);
}
void mousePressed() {
  mousePressedX = mouseX;
  mousePressedY = mouseY;
}