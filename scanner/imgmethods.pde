PImage generateUndistort(PImage img, PVector[] b) {
  PImage result = createImage(400, 400, RGB);
  result.loadPixels();
  for(int i = 0; i < 400; i++) {
    float p = float(i)/399.0;
    //println(p);
    color[] scan = getPixelLine(fade(b[1].x, b[2].x, p), fade(b[1].y, b[2].y, p),
                                fade(b[0].x, b[3].x, p), fade(b[0].y, b[3].y, p), 400, img);
    for(int j = 0; j < 400; j++) {
      result.pixels[i*400 + j] = scan[j];
    }
    //drawPixelLine(0, i+.01, 398.1, i+.01, scan);
  }
  result.updatePixels();
  return result;
}

boolean getBubbleState(PImage img, PVector bp) {
  return isShaded(img.get(int(bp.x), int(bp.y)));
}

int getCenterFromEdge(ArrayList<Integer> ls, int val) {
  int pos = ls.indexOf(val);
  return (ls.get(pos-2)+ls.get(pos-3))/2;
}
boolean validatePoint(PImage img, PVector v) {
  //fill(color(255, 0, 0));
  //rect(v.x-2, v.y-2, 4, 4);
  ellipseMode(RADIUS);
  noFill();
  stroke(255, 255, 0);
  //ellipse(v.x, v.y, 2, 2);
  try {
    img.loadPixels();
    int i = 0;
    
    while(isBlack(img.pixels[int(v.y+i)*img.width+int(v.x+i++)])) {}
    while(!isBlack(img.pixels[int(v.y+i)*img.width+int(v.x+i++)])) {}
    while(isBlack(img.pixels[int(v.y+i)*img.width+int(v.x+i++)])) {}
    int j = i*5/2;
    //line(v.x-j/2, v.y-j/2, v.x+j/2, v.y+j/2);
    //line(v.x, v.y, v.x+i, v.y+i);
    boolean res = true;
    //ellipseMode(RADIUS);
    //noFill();
    //ellipse(v.x, v.y, j, j);
    for(float t = 0; t < TWO_PI; t += PI * .05) {
      float r = 0;
      while(isBlack(img.pixels[int(v.y+r*sin(t))*img.width+int(v.x+r++*cos(t))])&&r<j) {}
      while(!isBlack(img.pixels[int(v.y+r*sin(t))*img.width+int(v.x+r++*cos(t))])&&r<j) {}
      while(isBlack(img.pixels[int(v.y+r*sin(t))*img.width+int(v.x+r++*cos(t))])&&r<j) {}
      if(!(r<j)) res = false;
      while(!isBlack(img.pixels[int(v.y+r*sin(t))*img.width+int(v.x+r++*cos(t))])&&r<j) {}
      if(r<j) res = false;
      /*
      float xo = int(.5*i*cos(r));
      float yo = int(.5*i*sin(r));
      if(isBlack(img.pixels[int(v.y+yo)*img.width+int(v.x+xo)])) {
        res = false;
      }
      */
    }
    /*
    boolean res = !isBlack(img.pixels[int(v.y+j)*img.width+int(v.x+j)]) &&
           isBlack(img.pixels[int(v.y+j*2)*img.width+int(v.x+j*2)]) &&
           !isBlack(img.pixels[int(v.y-j)*img.width+int(v.x-j)]) &&
           isBlack(img.pixels[int(v.y-j*2)*img.width+int(v.x-j++*2)]) ||
           !isBlack(img.pixels[int(v.y+j)*img.width+int(v.x+j)]) &&
           isBlack(img.pixels[int(v.y+j*2)*img.width+int(v.x+j*2)]) &&
           !isBlack(img.pixels[int(v.y-j)*img.width+int(v.x-j)]) &&
           isBlack(img.pixels[int(v.y-j*2)*img.width+int(v.x-j*2)]);
    //if(!res) println("whoopie!");
    */
    return res;
  } catch(Exception e) {
    return false;
  }
}
ArrayList<Integer> getHorizontalEdges(PImage img, int y) {
  ArrayList<Integer> result = new ArrayList<Integer>();
  img.loadPixels();
  for(int i = 1; i < img.width; i++) {
    if(isBlack(img.pixels[y*img.width+i-1])^isBlack(img.pixels[y*img.width+i])) result.add(i);
  }
  return result;
}
ArrayList<Integer> getVerticalEdges(PImage img, int x) {
  ArrayList<Integer> result = new ArrayList<Integer>();
  img.loadPixels();
  for(int i = 1; i < img.height; i++) {
    if(isBlack(img.pixels[(i-1)*img.width+x])^isBlack(img.pixels[i*img.width+x])) result.add(i);
  }
  return result;
}
void renderHorizontalArraylist(ArrayList<Integer> ls) {
  for(int x: ls) {
    line(x, 0, x, height-1);
  }
}
void renderVerticalArraylist(ArrayList<Integer> ls) {
  for(int y: ls) {
    line(0, y, width-1, y);
  }
}
ArrayList<Integer> filterArrayList(ArrayList<Integer> ls_, int err, int min) {
  //removes values from arraylist which do not have 5 values within min/err before them
  //assumes arraylist is sorted
  ArrayList<Integer> ls = new ArrayList<Integer>(ls_);
  for(int i = ls.size()-1; i >= 0; i--) {
    int maxdiff = 0;
    int smallest = min+1;
    int first = 0;
    if(i!=0) first = ls.get(i)-ls.get(i-1);
    if(i > 4) {
      for(int j = 1; j < 6; j++) {
        int b = ls.get(i-j+1)-ls.get(i-j);
        maxdiff = max(maxdiff, abs(b-first));
        smallest = min(smallest, b);
      }
    } else {
      ls.remove(i);
    }
    if(maxdiff > err || smallest < min) ls.remove(i);
  }
  return ls;
}

color[] getPixelLine(float x1, float y1, float x2, float y2, int steps, PImage img) {
  //println(x1, y1, x2, y2, steps);
  color[] result = new color[steps];
  img.loadPixels();
  if(img.pixels.length != 0) {
    for(int i = 0; i < steps; i++) {
      float p = ((float) i) / ((float) steps - 1.0);
      //println(img.pixels.length, i, p, (img.width*(((1-p)*y1)+p*y2) + ((1-p)*x1)+p*x2));
      //uses proportion along length to crossfade x and y
      result[i] = img.pixels[int(int(fade(y1,y2,p))*img.width + fade(x1,x2,p))];
    }
  }
  return result;
}
void highlightPixel(float x1, float y1, float x2, float y2, color[] line, int pos) {
  stroke(color(0, 255, 0));
  float p = ((float) pos) / ((float) line.length - 1);
  rect((int) (((1-p)*x1)+p*x2)-2, (int) (((1-p)*y1)+p*y2)-2, 4, 4);
}
void drawPixelLine(float x1, float y1, float x2, float y2, color[] line) {
 for(int i = 0; i < line.length; i++) {
   float p = ((float) i) / ((float) line.length - 1);
   set(int(fade(x1,x2,p)), int(fade(y1,y2,p)), line[i]);
 }
}


int patternFinder(color[] line) {
  int lba = 0; //left black accumulator
  int mba = 0; //middle black accumulator
  int rba = 0; //right black accumulator
  int lwa = 0; //left white accumulator
  int rwa = 0; //right white accumulator
  boolean lb = false;
    
  for(int i = 0; i < line.length; i++) {
    color tcol = line[i];
    if(red(tcol)+green(tcol)+blue(tcol) > 200) {//if pixel in line is white
      //if last pixel was black, shift white accumulaors back and start new white one at 0
      if(lb) {
        lwa = rwa;
        rwa = 0;
      }
      //increment rightmost accumulator
      rwa++;
      lb = false;
    } else {//if pixel in line is black
      //if last pixel was white, shift black accumulators back and start new black one at 0
      if(!lb) {
        lba = mba;
        mba = rba;
        rba = 0;
      }
      //increment rightmost accumulator
      rba++;
      lb = true;
    }
    
    int maxdiff = 0; //maximum difference between two accumulators
    maxdiff = max(maxdiff, abs(lba-mba));
    maxdiff = max(maxdiff, abs(lba-rba));
    maxdiff = max(maxdiff, abs(lba-lwa));
    maxdiff = max(maxdiff, abs(lwa-rwa));
    //print(maxdiff + "\t");
    //return if all accumulators are close to each other and they are big enough to be meaningful
    if(maxdiff < 4 && lba > 10) {
      color tcolb = line[i];
      if(red(tcolb)+green(tcolb)+blue(tcolb) < 200) {
        for(int j = 0; j<=10; j++) {
          if(i+j >= line.length) break;
          tcolb = line[i+j];
          if(red(tcolb)+green(tcolb)+blue(tcolb) > 200) {
            return marchBack(i+j, line);
          }
        }
      }
    }
  }
  //println(lba, mba, rba, lwa, rwa);
  return 0;
}
boolean isBlack(color c) {
  return red(c)+green(c)+blue(c) < 230; //230
}
boolean isShaded(color c) {
  return red(c)+green(c)+blue(c) < 300; 
}
int marchBack(int p, color[] line) {
  p--;
  while(isBlack(line[p])) p--;
  while(!isBlack(line[p])) p--;
  int x1 = p;
  while(isBlack(line[p])) p--;
  return (p + x1)/2;
}
