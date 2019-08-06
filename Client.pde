//Any functions for the clients to use

void clientUpdate() {
  String input, data[];
  if(gameC.available()>0) {
    input=gameC.readString()+"";
    println(input);
    data=split(input, '|'); //to parse into sets of coordinates and for any instructions
    for(int i=0; i<data.length; i++) {
      if(data[i].equals("NEW")) {
        playerCount++;
        updateBoardPositions();
      } else {
        updateTile(data[i]);
      }
    }
  }
  c_checkTileUpdates();
}

void newClientCheck() { //checks if the server has sent a new client; if already connected this will just add a player
  String input, data[];
  if(c.available()>0) { 
    input=c.readString(); 
    data=split(input, '|');
    if(data[0].equals("ID")&&data.length>1) {
      if(playerId==-2) {
        playerId=Integer.parseInt(data[1]);
        screenState=1;
        gameC=new Client(this, Msg, 12339+playerId); //separate ports for each client, 12339+playerId will give a port between 12341 and 12345 and 12340 is the main server
        gameC.write("UPDATE|");
      }
      playerCount=Integer.parseInt(data[1]);
      updateBoardPositions();
    }
  }
}

void c_checkTileUpdates() {
  for(int i=0; i<tiles.length; i++) {
    if(tiles[i].moved) {
      c_sendTileUpdates(i);
    }
  }
}

void c_sendTileUpdates(int ind) {
  gameC.write(ind+" "+tiles[ind].owner+" "+tiles[ind].pos.x+" "+tiles[ind].pos.y+" "+(tiles[ind].flipped?"1":"0")+"|");
}
