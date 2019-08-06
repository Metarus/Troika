//Any functions that control the game behavior

void gameUpdate() {
  background(180);
  boardDraw();
  tileUpdate();
  boardTextDraw();
  for(int i=0; i<=playerCount; i++) {
    image(board[i], boardLoc[i].x, boardLoc[i].y, boardSize[i].x, boardSize[i].y);
  }
}

void tileUpdate() {
  for(int i=0; i<tiles.length; i++) {
    tiles[i].moved=false;
  }
  for(int i=0; i<tiles.length; i++) {
    tiles[i].update();
  }
  for(int i=0; i<tiles.length; i++) {
    tiles[i].checkBounds();
  }
  
  for(int i=0; i<tiles.length; i++) {
    tiles[i].display();
  }
}

void boardDraw() {
  for(int i=0; i<board.length; i++) {
    board[i].beginDraw();
    board[i].strokeWeight(5);
    board[i].fill(255);
    board[i].rect(0, 0, board[i].width-1, board[i].height-1);
    board[i].endDraw();
  }
}

void boardTextDraw() {
  for(int i=0; i<board.length; i++) {
    board[i].beginDraw();
    board[i].textSize(30);
    board[i].fill(0);
    board[i].textAlign(CENTER);
    board[i].text(i==0?"Center":"Player "+i, board[i].width/2, 30);
    board[i].endDraw();
  }
}

void updateBoardPositions() {
  boardLoc[playerId]=new PVector(width/2-board[0].width/2, height/2-board[0].height/2+500);
  boardSize[playerId]=new PVector(700, 500);
  int count=0;
  for(int i=playerId+1; i<playerCount+playerId; i++) {
    int board=i;
    if(board>playerCount) board-=playerCount;
    boardLoc[board]=new PVector(width/2-(280+300*(playerCount-2)-600*count), 100);
    boardSize[board]=new PVector(560, 400);
    count++;
  }
}

void updateTile(String data) {
  String data2[];
  data2=split(data, ' ');
  if(data2.length==5) {
    tiles[Integer.parseInt(data2[0])].owner=Integer.parseInt(data2[1]);
    tiles[Integer.parseInt(data2[0])].pos=new PVector(Float.parseFloat(data2[2]), Float.parseFloat(data2[3]));
    tiles[Integer.parseInt(data2[0])].flipped=Integer.parseInt(data2[4])==1;
  }
}
