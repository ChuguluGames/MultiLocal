function Application() {
  var self = this;

  /* Client */
  self.client = {
    name: "client_0" // the server would be the client 0
  };

  /* Server */
  self.server = null;

  /* Game */
  self.game = null;

  /* Plyaers */
  self.players = {};

  console.log("application instancied");
}

/* wait until device ready */
Application.prototype.wait = function() {
  var self = this;

  console.log("waiting device response...");

  /* when device is ready */
  document.addEventListener("deviceready", function() {
    console.log("on device ready");

    self.init();

  }, false);
};

Application.prototype.init = function() {
  var self = this;

  PhoneGap.addPlugin("Multiplayer", new Multiplayer());
  self.multi = window.plugins.Multiplayer;

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
      self.multi.Multiplayer.sendToClients(message);
    else 
      self.multi.sendToServer(message);
  };
};

var application = new Application();