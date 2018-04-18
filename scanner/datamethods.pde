void setupOut() {
  outData = loadTable("matchdata.csv", "header");
  if(outData == null) {
    outData = new Table();
    String[] s = {"match","team","color","autoglyphs","jewel","key","autopark","cipher","rows","columns",
                  "glyphs","balanced","zone1relics","zone2relics","zone3relics","standingRelics"};
    for(String t: s) {
      outData.addColumn(t);
    }
  }
}
void parseStates(Table bubbles, TableRow states, TableRow result) {
  for(int i = 3; i < result.getColumnCount(); i++) {
    result.setInt(i, 0);
  }
  for(int i = 0; i < states.getColumnCount(); i++) {
    if(states.getInt(i) == 1) {
      String category = bubbles.getString(i, "category");
      result.setInt(category, bubbles.getInt(i, "value") + result.getInt(category));
    }
  }
}
void saveNewRowsAndClear() {
  addRows();
  bubbleStates.clearRows();
  scansDone = 0;
}
void addRows() {
  for(TableRow row: bubbleStates.rows()) {
    TableRow tmprow = outData.addRow();
    parseStates(bubbleTemplate, row, tmprow);
    println(outData.getRowCount());
  }
  saveTable(outData, "data/matchdata.csv");
  println("saved!");
}