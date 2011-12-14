function Application() {
  var self = this;

/*
le client n'a pas besoin de recevoir les positions des autres
ce qui signifie qu'il notifie au serveur sa position et le serveur doit notifier aux autres sa position
donc le serveur doit envoyer a une liste precise de client

le client/serveur doit notifier aux autres clients sa position donc c'est la meme chose
en fait le client/serveur n'est pas un client, il ne peut donc pas envoyer de message au server
ce qui signifie que lui doit envoyer au client

on envoie un object il est mal parse
*/

  /* Client */
  self.client = {
    name: "client_0" // the server would be the client 0
  };
  self.timerClientMessaging = null;

  /* Server */
  self.server = null;

  /* Game */
  self.game = null;

  /* Plyaers */
  self.players = {};

  console.log("application instancied");

  $("#button-create_server").bind("click", function() {
    self.createServer();    
  });

}

/* wait until device ready */
Application.prototype.wait = function() {
  var self = this;

  /* when device is ready */
  document.addEventListener("deviceready", function() {
    console.log("on device ready");
    /* look for the available local servers */
    self.searchServers();
  }, false);
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
      multiplayer.sendToClients(message);
    else 
      multiplayer.sendToServer(message);
  };
};

var application = new Application();
var multiplayer = new Multiplayer();

application.wait();