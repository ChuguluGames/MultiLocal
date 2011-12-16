/* create a host */
Application.prototype.createServer = function() {
  var self = this;

  multiplayer.stopSearchServers(); // don't need anymore to look for server
  multiplayer.createServer({
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
      self.game.start();
    }, 
    // on client connection
    onConnection: function(response) {
      if(typeof response == "string") response = JSON.parse(response);

      console.log("new client:" + response.clientName);

      // tell the clients about the connection
      multiplayer.sendToClients({
        action: "newClient",
        client: response.clientName
      }, self.server.clients);

      // tell the user about his connection and his name
      multiplayer.sendToClient(response.clientName, {
        action:     "connection",
        clientName: response.clientName
      });

      self.server.clients.push(response.clientName);
    },
    // on client disconnection
    onDisconnection: function(response) {
      if(typeof response == "string") response = JSON.parse(response);

      for(var i = 0; i < self.server.clients.length; i++) {
        if(self.server.clients[i] == response.clientName) {
          
          // delete it from the update list
          self.server.clients.splice (i, 1);

          // tell the clients about the deconnection
          if (self.server.clients.length > 0)
            multiplayer.sendToClients({
              action: "deconnection",
              client: response.clientName
            }, self.server.clients);

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
      var clients = [];

      for(var clientName in self.server.clients) {
        if(client != message.client) {
          clients.push(client);
        }
      }

      if(clients.length > 0) {
        multiplayer.sendToClients(message, clients);
      }
    },
    // on error
    onError: function(response) {
      console.log(response.error);
    }
  });
};