import processing.video.*;

Capture cam;

float mousePressedX = 1;
float mousePressedY = 1;
int globalerror = 7;
int globalminimum = 4;
void setup() {
  size(1280, 720);

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
    cam = new Capture(this, cameras[10]);
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
  //tempimg.loadPixels();
  //for(int i = 0; i < tempimg.pixels.length; i++) {
  //  tempimg.pixels[i] = color(255*int(!isBlack(tempimg.pixels[i])));
  //}
  image(tempimg, 0, 0);
  stroke(color(0, 255, 0));
  fill(color(0, 255, 0));
  ArrayList<PVector> coords = getTarget(tempimg, globalerror, globalminimum);
  for(int i = coords.size()-1; i > 0; i--) {
    PVector vect = coords.get(i);
    for(PVector vectb: coords) {
      if(vect != vectb && vect.dist(vectb) < 10) {
        coords.remove(coords.indexOf(vect));
        break;
      }
    }
  }
  for(PVector vect: coords) {
    rect(vect.x-3, vect.y-3, 6, 6);
  }
  if(coords.size() == 4) {
    int low = 9999;
    int lowi = 0;
    int lowb = 9999;
    int lowbi = 0;
    for(int i = 1; i < 4; i++) {
      if(coords.get(0).dist(coords.get(i)) < low) {
        lowi = i;
        low = int(coords.get(0).dist(coords.get(i)));
      }
    }
    for(int i = 1; i < 4; i++) {
      if(i == lowi) continue;
      if(coords.get(lowi).dist(coords.get(i)) < lowb) {
        lowbi = i;
        lowb = int(coords.get(lowi).dist(coords.get(i)));
      }
    }
    boolean[] taken = {false, false, false};
    taken[lowi-1] = true;
    taken[lowbi-1] = true;
    int j;
    for(j = 0; j < 3; j++) {
      if(!taken[j]) break;
    }
    j++;
    stroke(color(0, 255, 0));
    line(coords.get(0), coords.get(lowi));
    line(coords.get(lowi), coords.get(lowbi));
    line(coords.get(lowbi), coords.get(j));
    line(coords.get(j), coords.get(0));
  }
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
void line(PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}