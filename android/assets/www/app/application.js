function Application() {
  var self = this, 
      color;

  /* Available colors */
  self.colors = ["yellow", "green", "blue", "red", "pink"];

  color = self.colors.shift();

  /* Client */
  self.client = {
    name: "client_0", // the server would be the client 0
    color: color // take the first color for the server
  };

  /* Server */
  self.server = null;

  /* Game */
  self.game = null;

  /* Players */
  self.players = {};

  console.log("application instancied");
};

Application.prototype.init = function() {
  var self = this;

  self.multi = new Multiplayer();

  if(window.plugins === undefined) window.plugins = {};
  window.plugins.Multiplayer = self.multi; 

  console.log("bug");

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

    if(self.server)
      self.multi.sendToClients(message);
    else 
      self.multi.sendToServer(message);
  };
};

var application = new Application();