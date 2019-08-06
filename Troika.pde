import processing.net.*;

//s is main server, gameS is one server for each client that joins the game
Server s, gameS[]=new Server[4];
Client c, gameC;

PVector[] boardLoc=new PVector[6], boardSize=new PVector[6];
PGraphics[] board=new PGraphics[6]; //each player has their own board associated with them and board 0 is the middle
Tile[] tiles=new Tile[49];
int playerId=0; //id of the player, 1 is the host. 0 is not an id because 0 is the central board and value before set
int playerCount=1; //how many players are in the game
int screenState=0; //0 is info, 1 is game
String Msg=""; //used for entering in the IP
boolean holding=false; //whether or not a the player is holding a tile

void setup() {
  size(3000, 1800, P2D);
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
  boardLoc[0]=new PVector(width/2-board[0].width/2, height/2-board[0].height/2-100);
  boardSize[0]=new PVector(700, 500);
}

void draw() {
  switch(screenState) {
    case 0: 
      infoScreen();
      break;
    case 1: 
      drawGame();
      if(playerId==1) {
        serverUpdate();
      } else clientUpdate();
      break;
  }
}

void serverUpdate() {
  String input="";
  c=s.available();
  if (c != null) {
    input = c.readString(); 
  }
  if(input.equals("NEW")) {
    playerCount++;
    c.write("ID|"+playerCount);
    updateBoardPositions();
  }
}

void clientUpdate() {
  
}

void drawGame() {
  background(180);
  for(int i=0; i<tiles.length; i++) {
    tiles[i].update();
  }
  for(int i=0; i<tiles.length; i++) {
    tiles[i].checkBounds();
  }
  boardDraw();
  for(int i=0; i<tiles.length; i++) {
    tiles[i].display();
  }
  boardTextDraw();
  for(int i=0; i<=playerCount; i++) {
    image(board[i], boardLoc[i].x, boardLoc[i].y, boardSize[i].x, boardSize[i].y);
  }
}

void infoScreen() {
  background(128);
  textSize(100);
  fill(0);
  textAlign(CENTER);
  if(playerId==0) {
    text("Press C for client and S for server", width/2, height/2);
    if(keyPressed&&key=='s') {
      s=new Server(this, 12340);
      for(int i=0; i<4; i++) {
        gameS[i]=new Server(this, 12341+i);
      }
      playerId=1;
      screenState++;
      updateBoardPositions();
    }
    if(keyPressed&&key=='c') {
      playerId=-1;
    }
  }
  if(playerId==-1) {
    text("Please enter the IP", width/2, height/2-50);
    textSize(80);
    text(Msg, width/2, height/2+50);
  }
  //if playerId=-2, then we are checking for the message to be received and to connect to the server
  if(playerId==-2) {
    String input, data[];
    if (c.available() > 0) { 
      input = c.readString(); 
      data=(split(input, '|'));
      if(data[0].equals("ID")&&data.length>1) {
        playerId=Integer.parseInt(data[1]);
        playerCount=playerId;
        gameC=new Client(this, Msg, 12339+playerId); //separate ports for each client, 12339+playerId will give a port between 12341 and 12345 and 12340 is the main server
        screenState=1;
        updateBoardPositions();
      }
    }
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

void mouseReleased() {
  holding=false;
  for(int i=0; i<tiles.length; i++) {
    tiles[i].held=false;
  }
}

void keyPressed() {
  if(screenState==0&&playerId==-1) {
    if(key==ENTER) {
      c=new Client(this, Msg, 12340);
      c.write("NEW");
      playerId--;
    }
    if (key==BACKSPACE) {
      if (0<Msg.length()) {
        Msg = Msg.substring(0, Msg.length()-1);
      }
    } else if (key!=CODED&&key!=ENTER) {
      Msg=(Msg+key);
    }
  }
}
