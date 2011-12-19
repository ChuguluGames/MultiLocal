/* connect to the server with his name (could be an IP + port?) */
Application.prototype.connectToServer = function(serverName) {
  var self = this;

  self.multi.connectToServer({
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
    onSend: function(response) {},
    // on message received from the server
    onMessage: function(response) {
      var message = JSON.parse(response.message);

      console.log("receiving message with action " + message.action)

      switch(message.action) {
        case "connection":
          self.client.name = message.clientName;
          self.client.color = message.color;
          self.game.setColor(message.color);
          self.game.start();     

          for(var i = 0; i < message.clients.length; i++) {
            var ball = new Ball();
            ball.setColor(message.clients[i].color);
            self.players[message.clients[i].name] = ball;               
          }
        break;
        case "clientConnected":
          console.log("add ball player " + message.client + " and setting his color to " + message.color);
          // add the player
          var ball = new Ball();
          ball.setColor(message.color);
          self.players[message.client] = ball;
        break;
        case "clientDisconnected":
          // remove player
          self.players[message.client].remove();
          delete self.players[message.client];

        break;        
        case "move": self.movePlayer(message); break;
      }
      console.log("Client received: " + message);    
    },
    // on error
    onError: function(response) {
      console.log(response.error);
    },
    // on disconnection
    onDisconnection: function(response) {
      self.game.stop();
      $("#game").hide();

      $("#button-create_server").show();
      $("#servers").show();   
      self.searchServers();   
    }
  }); 
};

Application.prototype.movePlayer = function(data) {
  var self = this;

  console.log("moving " + data.client + " to x:" + data.position.x + "px y:" + data.position.y + "px");

  if(self.players[data.client] !== undefined) {
    self.players[data.client].position = data.position;
    self.players[data.client].update();  
  }


};