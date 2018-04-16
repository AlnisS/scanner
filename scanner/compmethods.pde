class Bubble {
  PVector pos;
  String cat;
  int val;
  Bubble(TableRow bd) {
    this.pos = new PVector();
    this.pos.x = bd.getFloat("x");
    this.pos.y = bd.getFloat("y");
    this.cat = bd.getString("category");
    this.val = bd.getInt("value");
  }
}
void drawThings(PImage tempimg) {
  stroke(255, 0, 0);
  renderHorizontalArraylist(getHorizontalEdges(tempimg, mouseY));
  renderVerticalArraylist(getVerticalEdges(tempimg, mouseX));
  stroke(0, 255, 255);
  renderHorizontalArraylist(filterArrayList(getHorizontalEdges(tempimg, mouseY), globalerror, globalminimum));
  renderVerticalArraylist(filterArrayList(getVerticalEdges(tempimg, mouseX), globalerror, globalminimum));
}
ArrayList<PVector> getTarget(PImage tempimg, int error, int minimum) {
  ArrayList<Integer> foundedges = new ArrayList<Integer>();
  ArrayList<PVector> results = new ArrayList<PVector>();
  for(int i = 0; i < tempimg.height; i++) {
    //int i = 200;
    ArrayList<Integer> fulledges = getHorizontalEdges(tempimg, i);
    ArrayList<Integer> edges = filterArrayList(fulledges, error, minimum);
    for(int redge: edges) {
      //problem is that it is only doing the first edge!
      //int redge = 0; //right edge x position
      //if(edges.size() != 0) redge = edges.get(0);
      int p = 0; //center of target position
      if(redge != 0) p = getCenterFromEdge(fulledges, redge);
      //line(redge, 0, redge, height-1);
      //line(p, 0, p, height-1);
      if(p != 0) {
        foundedges.add(p);
      }
    }
    //line(0, 200, width-1, 200);
    /*
    for(int it: edges) {
      line(it, 0, it, height-1);
    }
    */
  }
  for(int i: foundedges) {
    ArrayList<Integer> fulledges = getVerticalEdges(tempimg, i);
    ArrayList<Integer> edges = filterArrayList(fulledges, error, minimum);
    for(int redge: edges) {
      int p = 0;
      if(redge != 0) p = getCenterFromEdge(fulledges, redge);
      //line(redge, 0, redge, height-1);
      //line(0, p, width-1, p);
      PVector testvector = new PVector(i, p);
      if(p != 0 && validatePoint(tempimg, testvector)) {
        results.add(testvector);
        stroke(255, 0, 255);
        line(testvector.x-10, testvector.y-10, testvector.x+10, testvector.y+10);
        line(testvector.x-10, testvector.y+10, testvector.x+10, testvector.y-10);
      }
    }
  }
  return results;
}
