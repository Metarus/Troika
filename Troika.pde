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
      gameUpdate();
      if(playerId==1) {
        serverUpdate();
      } else clientUpdate();
      break;
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
    newClientCheck();
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
