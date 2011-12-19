/* create a host */
Application.prototype.createServer = function() {
  var self = this;

  self.multi.stopSearchServers(); // don't need anymore to look for server
  self.multi.createServer({
    // on create server
    onCreate: function(response) {
      if(typeof response == "string") response = JSON.parse(response);

      self.server = response.server;
      self.server.clients = [];

      $("#button-create_server").hide();
      $("#servers").hide();
      console.log("Server: " + self.server.name +" created");

      $("#game").show();

      self.createGame();

      self.game.setColor(self.client.color);
      self.game.start();
    }, 
    // on client connection
    onConnection: function(response) {
      if(typeof response == "string") response = JSON.parse(response);

      console.log("new client:" + response.clientName);
        
      var color = self.colors.shift();

      var clientsName = [];
      for(var i = 0; i < self.server.clients.length; i++) {
        clientsName.push(self.server.clients[i].name);
      }

      // tell the clients about the connection
      self.multi.sendToClients({
        action: "clientConnected",
        client: response.clientName,
        color:  color
      }, clientsName);

      // tell the user about his connection and his name
      self.multi.sendToClient(response.clientName, {
        action:     "connection",
        clientName: response.clientName,
        color:      color,
        clients:    [self.client].concat(self.server.clients)
      });

      var ball = new Ball();
      ball.setColor(color);
      self.players[response.clientName] = ball;      

      self.server.clients.push({
        name:   response.clientName,
        color:  color
      });
    },
    // on client disconnection
    onDisconnection: function(response) {
      if(typeof response == "string") response = JSON.parse(response);

      for(var i = 0; i < self.server.clients.length; i++) {
        if(self.server.clients[i].name == response.clientName) {
          
          // delete it from the update list
          self.server.clients.splice (i, 1);

          // create the clients name list
          var clientsName = [];
          for(var i = 0; i < self.server.clients.length; i++) {
            clientsName.push(self.server.clients[i].name);
          }

          // tell the clients about the deconnection
          self.multi.sendToClients({
            action: "clientDisconnected",
            client: response.clientName
          }, clientsName);

          return;
        }
      }
    },    
    // on message from server
    onMessage: function(response) {
      var message = JSON.parse(response.message);

      console.log("Server received: " + message);

      switch(message.action) {
        case "newPlayer":
        break;
        case "move": self.movePlayer(message); break;
      }

      // on doit renvoyer aux clients le message sauf le sender
      var clientsName = [];

      for(var i = 0; i < self.server.clients.length; i++) {
        if(self.server.clients[i].name != message.client) {
          clientsName.push(self.server.clients[i].name);
        }
      }

      self.multi.sendToClients(message, clientsName);
    },
    // on error
    onError: function(response) {
      console.log(response.error);
    }
  });
};