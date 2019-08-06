class Tile {
  boolean held;
  PVector pos;
  boolean flipped=false; //whether or not the value is visible
  int owner=0; //who owns the tile, 0 means in the middle
  int value; //actual value of the tile
  int index;
  Tile(int number, int _index) {
    index=_index;
    value=number;
    pos=new PVector(random(30, 670), random(30, 470));
  }
  void update() {
    if(mousePressed&&mouseButton==LEFT&&cursorOnTile()&&!holding&&(owner==playerId||owner==0)) {
      held=true; //local variable to track if this specific tile is being held
      holding=true; //global variable to track if player is holding something
    }
    if(held) {
      pos.x=mouseX-boardLoc[owner].x;
      pos.y=mouseY-boardLoc[owner].y;
    }
    if(mousePressed&&mouseButton==RIGHT&&cursorOnTile()) {
      owner=playerId;
    }
    if(cursorOnTile()&&key=='a'&&keyPressed) {
      flipped=true;
    }
    checkCollisions();
  }
  void display() {
    board[owner].beginDraw();
    board[owner].strokeWeight(1);
    board[owner].fill(100, 180, 255);
    board[owner].ellipse(pos.x, pos.y, 60, 60);
    board[owner].fill(0);
    board[owner].textAlign(CENTER);
    board[owner].textSize(30);
    board[owner].text(""+(flipped?value:""), pos.x, pos.y+10);
    board[owner].endDraw();
  }
  void checkCollisions() { //checks collisions against all other tiles and ensures that they can't stack
    for(int i=0; i<tiles.length; i++) {
      float distance=dist(pos.x, pos.y, tiles[i].pos.x, tiles[i].pos.y);
      if(owner==tiles[i].owner&&distance<60&&i!=index) {
        PVector dir=new PVector(pos.x-tiles[i].pos.x, pos.y-tiles[i].pos.y);
        dir.normalize();
        dir=dir.mult(70-distance);
        pos=new PVector(pos.x+dir.x, pos.y+dir.y);
        tiles[i].pos=new PVector(tiles[i].pos.x-dir.x, tiles[i].pos.y-dir.y);
      }
    }
  }
  void checkBounds() { //checks the walls to make sure all tiles are in bounds
    if(pos.x<30) pos.x=30;
    if(pos.y<30) pos.y=30;
    if(pos.x>board[owner].width-30) pos.x=board[owner].width-30;
    if(pos.y>board[owner].height-30) pos.y=board[owner].height-30;
  }
  boolean cursorOnTile() { return dist(mouseX, mouseY, boardLoc[owner].x+pos.x, boardLoc[owner].y+pos.y)<30; }
}
