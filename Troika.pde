PVector[] boardLoc=new PVector[6];
PGraphics[] board=new PGraphics[6]; //each player has their own board associated with them and board 0 is the middle
Tile[] tiles=new Tile[49];
int playerId=1;
int playerCount=1;
boolean holding=false; //whether or not a the player is holding a tile

void setup() {
  size(3000, 1800);
  for(int i=0; i<board.length; i++) {
    board[i]=createGraphics(700, 500);
  }
  int counter=0;
  for(int i=1; i<=15; i++) {
    for(int j=0; j<(i==7?7:3); j++) {
      tiles[counter]=new Tile(i, counter);
      counter++;
    }
  }
  for(int i=0; i<tiles.length; i++) {
    tiles[i].checkCollisions();
  }
  boardLoc[0]=new PVector(width/2-board[0].width/2, height/2-board[0].height/2-200);
  boardLoc[1]=new PVector(width/2-board[0].width/2, height/2-board[0].height/2+500);
}
void draw() {
  for(int i=0; i<tiles.length; i++) {
    tiles[i].update();
  }
  for(int i=0; i<tiles.length; i++) {
    tiles[i].checkBounds();
  }
  for(int i=0; i<board.length; i++) {
    board[i].beginDraw();
    board[i].strokeWeight(5);
    board[i].fill(255);
    board[i].rect(0, 0, board[i].width-1, board[i].height-1);
    board[i].endDraw();
  }
  for(int i=0; i<tiles.length; i++) {
    tiles[i].display();
  }
  for(int i=0; i<=playerCount; i++) {
    image(board[i], boardLoc[i].x, boardLoc[i].y);
  }
}
void mouseReleased() {
  holding=false;
  for(int i=0; i<tiles.length; i++) {
    tiles[i].held=false;
  }
}
