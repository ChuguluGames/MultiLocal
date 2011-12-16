/* connect to the server with his name (could be an IP + port?) */
Application.prototype.connectToServer = function(serverName) {
  var self = this;

  self.multi.connectToServer({
    clientName:   self.client.name,
    serverName:   serverName, 
    // when the client is connected to the host
    onConnection: function(response) {
      $("#button-create_server").hide();
      $("#servers").hide();      
      console.log("Connected to the server, waiting for response...");  

      $("#button-create_server").hide();
      $("#servers").hide();

      $("#game").show();
      self.createGame();         
    },
    // on message received from the server
    onMessage: function(response) {
      var message = JSON.parse(response.message);

      switch(message.action) {
        case "connection":
          self.client.name = message.clientName;
          self.game.start();     
        break;
        case "newClient":
        break;
        case "move": self.movePlayer(message); break;
      }
      console.log("Client received: " + message);    
    },
    // on error
    onError: function(response) {
      // var message = JSON.parse(response.message);

      console.log(response.error);
      
      self.game.stop();
      $("#game").hide();

      $("#button-create_server").show();
      $("#servers").show();        
    },
    // on error
    onDisconnection: function(response) {
      // var message = JSON.parse(response.message);

      console.log(response.error);
      
      self.game.stop();
      $("#game").hide();

      $("#button-create_server").show();
      $("#servers").show();   
      self.searchServers();   
    }
  }); 
};

Application.prototype.movePlayer = function(response) {
  var self = this;

  console.log("moving " + response.client + " to x:" + response.position.x + "px y:" + response.position.y + "px");

  if(self.players[response.client] === undefined) {
    self.players[response.client] = new Ball();
  }

  self.players[response.client].position = response.position;
  self.players[response.client].update();  
};