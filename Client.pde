//Any functions for the clients to use

void clientUpdate() {
  String input, data[];
  if(gameC.available()>0) {
    input=gameC.readString()+"";
    println(input);
    data=split(input, '|'); //to parse into sets of coordinates and for any instructions
    for(int i=0; i<data.length; i++) {
      if(input.equals("NEW")) {
        playerCount++;
        updateBoardPositions();
      } else {
        String data2[]; //for parsing the coordinates down
        data2=split(data[i], ' ');
        if(data2.length==5) {
          tiles[Integer.parseInt(data2[0])].owner=Integer.parseInt(data2[1]);
          tiles[Integer.parseInt(data2[0])].pos=new PVector(Float.parseFloat(data2[2]), Float.parseFloat(data2[3]));
          tiles[Integer.parseInt(data2[0])].flipped=Integer.parseInt(data2[4])==1;
        }
      }
    }
  }
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
