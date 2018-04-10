ArrayList<PVector> getTarget(PImage tempimg, int error, int minimum) {
  ArrayList<Integer> foundedges = new ArrayList<Integer>();
  ArrayList<PVector> results = new ArrayList<PVector>();
  for(int i = 0; i < height; i++) {
    //int i = 200;
    ArrayList<Integer> fulledges = getHorizontalEdges(tempimg, i);
    ArrayList<Integer> edges = filterArrayList(fulledges, error, minimum);
    int redge = 0;
    if(edges.size() != 0) redge = edges.get(0);
    int p = 0;
    if(redge != 0) p = getCenterFromEdge(fulledges, redge);
    //line(redge, 0, redge, height-1);
    //line(p, 0, p, height-1);
    foundedges.add(p);
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
    int redge = 0;
    if(edges.size() != 0) redge = edges.get(0);
    int p = 0;
    if(redge != 0) p = getCenterFromEdge(fulledges, redge);
    //line(redge, 0, redge, height-1);
    //line(0, p, width-1, p);
    if(p != 0) results.add(new PVector(i, p));
  }
  return results;
}