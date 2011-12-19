function Application() {
  var self = this, 
      color;

  /* Available player colors */
  self.colors = ["yellow", "green", "blue", "red", "pink"];

  color = self.colors.shift();

  self.client = {
    name: "client_0", // the server would be the client 0
    color: color      // take the first color for the server
  };

  self.server = null;
  self.game = null;
  self.players = {};

  console.log("application instancied");
};

Application.prototype.init = function() {
  var self = this;

  self.multi = new Multiplayer();

  if(window.plugins === undefined) window.plugins = {};
  window.plugins.Multiplayer = self.multi; 

  /* look for the available local servers */
  self.searchServers();  

  $("#button-create_server").bind("click", function() {
    self.createServer();    
  });
};

Application.prototype.createGame = function() {
  var self = this;

  self.game = new Game();

  // create the callback on update
  self.game.onUpdate = function(position) {
    var message = {
      action: "move",
      client: self.client.name,
      position: position
    };

    if(self.server) self.multi.sendToClients(message); // send to clients if the user is the server
    else self.multi.sendToServer(message); // if he is the client send to server
  };
};

var application = new Application();