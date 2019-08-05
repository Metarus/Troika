class Tile {
  boolean held;
  PVector pos;
  boolean flipped=true; //whether or not the value is visible
  int owner=0; //who owns the tile, 0 means in the middle
  int value; //actual value of the tile
  int index;
  Tile(int number, int _index) {
    index=_index;
    value=number;
    pos=new PVector(random(30, 770), random(30, 570));
  }
  void update() {
    if(mousePressed&&dist(mouseX, mouseY, boardLoc[owner].x+pos.x, boardLoc[owner].y+pos.y)<30&&!holding) {
      held=true; //local variable to track if this specific tile is being held
      holding=true; //global variable to track if player is holding something
    }
    if(held) {
      pos.x=mouseX-boardLoc[owner].x;
      pos.y=mouseY-boardLoc[owner].y;
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
    board[owner].text(""+(flipped?value:"?"), pos.x, pos.y+10);
    board[owner].endDraw();
  }
  void checkCollisions() {
    for(int i=0; i<tiles.length; i++) {
      float distance=dist(pos.x, pos.y, tiles[i].pos.x, tiles[i].pos.y);
      if(owner==tiles[i].owner&&distance<60&&i!=index) {
        PVector dir=pos.sub(tiles[i].pos);
        dir.normalize();
        dir=dir.mult(2*(70-distance));
        println(dir);
        pos=new PVector(pos.x+dir.x, pos.y+dir.y);
        tiles[i].pos=new PVector(tiles[i].pos.x-dir.x, tiles[i].pos.y-dir.y);
      }
    }
    if(pos.x<30) pos.x=30;
    if(pos.y<30) pos.y=30;
    if(pos.x>board[owner].width-30) pos.x=board[owner].width-30;
    if(pos.y>board[owner].height-30) pos.y=board[owner].height-30;
  }
}
