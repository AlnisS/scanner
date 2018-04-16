import processing.video.*;

Capture cam;

float mousePressedX = 1;
float mousePressedY = 1;
float tbx = 400*14.5/18;
float tby = 400*9.5/12;
int globalerror = 7;
int globalminimum = 2;
void setup() {
  size(1280, 720);
  //delay(10000);
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
  if (cam.available() == true && !keyPressed) {
    cam.read();
  }
  //image(cam, 0, 0);
  noStroke();
  fill(0, 0, 0, 127);
  PImage tempimg = cam.copy();
  tempimg.loadPixels();
  if(mousePressed) {
    for(int i = 0; i < tempimg.pixels.length; i++) {
    tempimg.pixels[i] = color(255*int(!isShaded(tempimg.pixels[i])));
    }
  }
  image(tempimg, 0, 0);
  //background(0);
  stroke(color(0, 255, 0));
  fill(color(0, 255, 0));
  ArrayList<PVector> coords = getTarget(tempimg, globalerror, globalminimum);
  for(int i = 0; i < coords.size(); i++) {
    PVector vect = coords.get(i);
    ArrayList<PVector> closePoints = new ArrayList<PVector>();
    for(int j = i+1; j < coords.size(); j++) {
      PVector vectb = coords.get(j);
      if(vect != vectb && vect.dist(vectb) < 10) {
        closePoints.add(coords.remove(j));
        j--;
      }
    }
    closePoints.add(vect);
    float xa = 0;
    float ya = 0;
    float count = 0;
    while(closePoints.size() != 0) {
      xa += closePoints.get(0).x;
      ya += closePoints.get(0).y;
      closePoints.remove(0);
      count++;
    }
    
    xa /= count;
    ya /= count;
    coords.set(i, new PVector(xa, ya));
  }
  for(PVector vect: coords) {
    rect(vect.x-3, vect.y-3, 6, 6);
  }
  PVector[] r = new PVector[4];
  //text(coords.size(), 10, 10);
  if(coords.size() == 4) {
    int low = 9999;
    int lowi = 0;
    int lowb = 9999;
    int lowbi = 0;
    for(int i = 0; i < 4; i++) {
      if(coords.get(i).y < low) {
        lowi = i;
        low = int(coords.get(i).y);
      }
    }
    for(int i = 0; i < 4; i++) {
      if(coords.get(i).y < lowb && i != lowi) {
        lowbi = i;
        lowb = int(coords.get(i).y);
      }
    }
    //println(coords.get(lowi).y);
    if(coords.get(lowi).x > coords.get(lowbi).x) {
      r[0] = coords.get(lowi);
      r[1] = coords.get(lowbi);
    } else {
      r[0] = coords.get(lowbi);
      r[1] = coords.get(lowi);
    }
    boolean[] taken = {false, false, false, false};
    taken[lowi] = true;
    taken[lowbi] = true;
    for(int i = 0; i < 4; i++) {
      if(!taken[i]) {
        lowi = i;
        i++;
        for(;i < 4; i++) {
          if(!taken[i]) {
            lowbi = i;
            i = 4;
          }
        }
      }
    }
    if(coords.get(lowi).x > coords.get(lowbi).x) {
      r[3] = coords.get(lowi);
      r[2] = coords.get(lowbi);
    } else {
      r[3] = coords.get(lowbi);
      r[2] = coords.get(lowi);
    }
    for(int i = 0; i < 4; i++) {
      //print(i, r[i].x, r[i].y, " ");
    }
    //println(" ");
    stroke(0, 0, 255);
    for(int i = 0; i < 4; i++) {
      line(r[i], r[i%4]);
    }
    /*
    int low = 9999;
    int lowi = 0;
    int lowb = 9999;
    int lowbi = 0;
    //println("foo");
    for(int i = 1; i < 4; i++) {
      if(coords.get(0).dist(coords.get(i)) < low) {
        lowi = i;
        low = int(coords.get(0).dist(coords.get(i)));
      }
    }
    for(int i = 1; i < 4; i++) {
      if(i != lowi && coords.get(0).dist(coords.get(i)) < lowb) {
        lowbi = i;
        lowb = int(coords.get(0).dist(coords.get(i)));
      }
    }
    //println(lowb, lowbi);
    boolean[] taken = {false, false, false};
    taken[lowi-1] = true;
    taken[lowbi-1] = true;
    int j;
    for(j = 0; j < 3; j++) {
      if(!taken[j]) break;
    }
    j++;
    stroke(color(0, 0, 255));
    line(coords.get(0), coords.get(lowi));
    line(coords.get(lowi), coords.get(j));
    line(coords.get(j), coords.get(lowbi));
    line(coords.get(lowbi), coords.get(0));
    r[0]=coords.get(0);
    r[1]=coords.get(lowi);
    r[2]=coords.get(j);
    r[3]=coords.get(lowbi);
    float hi = 9999; //looking for highest on screen, so actually lowest y
    int hii = 0; //arbitrary, set by following loops
    float hib = 9999;
    int hibi = 0;
    for(int i = 0; i < 4; i++) {
      if(r[i].y < hi) {
        hi = r[i].y;
        hii = i;
      }
    }
    for(int i = 0; i < 4; i++) {
      if(r[i].y < hib && i != hii) {
        hib = r[i].y;
        hibi = i;
      }
    }
    int base = 0;
    if(r[hii].x > r[hibi].x) {
      base = hii;
    } else {
      base = hibi;
    }
    PVector[] tempvectors = new PVector[4];
    for(int i = 0; i < 4; i++) {
      tempvectors[i] = r[(i + base) % 4];
    }
    r = tempvectors;
    if(r[1].y > r[3].y) {
      PVector hold = r[1];
      r[1] = r[3];
      r[3] = hold;
    }
    for(int i = 0; i < 4; i++) {
      text(i, r[i].x, r[i].y);
    }
    */
  }
  PImage t = createImage(1, 1, RGB);
  if(r[0] != null) {
    //for(int i = 0; i < 400; i +=1) {
    //  float p = float(i)/399.0;
    //  //println(r[0], r[1], r[2], r[3], p);
    //  color[] scan = getPixelLine(fade(r[1].x, r[2].x, p), fade(r[1].y, r[2].y, p),
    //                              fade(r[0].x, r[3].x, p), fade(r[0].y, r[3].y, p), 400, tempimg);
    //  //drawPixelLine(fade(r[0].x, r[3].x, p), fade(r[0].y, r[3].y, p),
    //  //              fade(r[1].x, r[2].x, p), fade(r[1].y, r[2].y, p), scan);
    //  drawPixelLine(0, i+.01, 398.1, i+.01, scan);
    //  //drawPixelLine(1, 2*i+.01, 399.1, 2*i+.01, scan);
    //  //drawPixelLine(0, 2*i+1.01, 398.1, 2*i+1.01, scan);
    //  //drawPixelLine(1, 2*i+1.01, 399.1, 2*i+1.01, scan);
    //}
    t = generateUndistort(tempimg, r);
    image(t, 0, 0);
  }
  if(mousePressed) drawThings(tempimg);
  text(mouseX, 10, 10);
  text(mouseY, 10, 20);
  //if(t.width != 1) text(int(getBubbleState(t, new PVector(345, 25))), 10, 30);
  line(tbx, tby-5, tbx, tby+5);
  line(tbx-5, tby, tbx+5, tby);
  if(t.width != 1 && getBubbleState(t, new PVector(tbx, tby))) {
    stroke(0, 255, 0);
    fill(0, 0, 255);
    rect(500, 50, 50, 50);
  }
}
void keyPressed() {
  switch(key) {
    /*
    case 'q': globalerror++;
              break;
    case 'a': globalerror--;
              break;
    case 'w': globalminimum++;
              break;
    case 's': globalminimum--;
              break;
    */
    case 'w': tby--;
              break;
    case 's': tby++;
              break;
    case 'a': tbx--;
              break;
    case 'd': tbx++;
              break;
  }
  //println(globalerror, globalminimum);
  println(tbx, tby);
}
void mousePressed() {
  mousePressedX = mouseX;
  mousePressedY = mouseY;
}
void line(PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}
float fade(float a, float b, float p) {
  return (1-p)*a + p*b;
}
