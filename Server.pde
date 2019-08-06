//Any functions for the server to use

void serverUpdate() {
  String input="";
  c=s.available();
  if (c!=null) {
    input=c.readString(); 
  }
  if(input.equals("NEW")) {
    for(int i=0; i<playerCount-1; i++) { //sending data to other clients
      gameS[i].write("NEW|");
    }
    playerCount++;
    updateBoardPositions();
    s.write("ID|"+playerCount);
  }
  s_checkTileUpdates();
  s_receiveUpdates();
}

void s_receiveUpdates() {
  String input, data[];
  for(int i=0; i<playerCount-1; i++) {
    gameC=gameS[i].available();
    if(gameC!=null) {
      input=gameC.readString(); 
      data=split(input, '|');
      for(int j=0; j<data.length; j++) {
        if(data[i].equals("UPDATE")) {
          s_sendAllTileUpdates();
        } else {
          updateTile(data[i]);
        }
      }
    }
  }
}

void s_sendAllTileUpdates() {
  for(int i=0; i<tiles.length; i++) {
    s_sendTileUpdates(i);
  }
}

void s_checkTileUpdates() {
  for(int i=0; i<tiles.length; i++) {
    if(tiles[i].moved) {
      s_sendTileUpdates(i);
    }
  }
}

void s_sendTileUpdates(int ind) {
  for(int i=0; i<playerCount-1; i++) {
    gameS[i].write(ind+" "+tiles[ind].owner+" "+tiles[ind].pos.x+" "+tiles[ind].pos.y+" "+(tiles[ind].flipped?"1":"0")+"|");
  }
}
