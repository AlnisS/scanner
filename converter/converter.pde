Table bubbleStates;
Table bubbleTemplate;
Table outData;

void setup() {
  bubbleStates = loadTable("bubblestates.csv");
  bubbleTemplate = loadTable("bubbles.csv", "header");
  
  outData = loadTable("matchdata.csv", "header");
  if(outData == null) {
    outData = new Table();
    String[] s = {"autoglyphs","jewel","key","autopark","cipher","rows","columns","glyphs","balanced","zone1relics","zone2relics","zone3relics","standingRelics"};
    for(String t: s) {
      outData.addColumn(t);
    }
  }
  noLoop();
}
void draw() {
  for(TableRow row: bubbleStates.rows()) {
    parseStates(bubbleTemplate, row, outData.addRow());
    println(outData.getRowCount());
  }
  saveTable(outData, "data/matchdata.csv");
  println("saved!");
}
void parseStates(Table bubbles, TableRow states, TableRow result) {
  for(int i = 0; i < result.getColumnCount(); i++) {
    result.setInt(i, 0);
  }
  for(int i = 0; i < states.getColumnCount(); i++) {
    if(states.getInt(i) == 1) {
      String category = bubbles.getString(i, "category");
      result.setInt(category, bubbles.getInt(i, "value") + result.getInt(category));
    }
  }
}
