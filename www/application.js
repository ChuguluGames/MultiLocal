function Application() {
  var self = this;

  /* Client */
  self.client = {
    name: "client_" + (Math.round(Math.random() * 10000))
  };
  self.timerClientMessaging = null;

  /* Server */
  self.server = {
    domain:         "",
    port:           0,
    type:           "",
    name:           "",
    timerMessaging: null
  };
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

/* search accessible hosts */
Application.prototype.searchServers = function() {
  var self = this;

  console.log("calling native searchServers method");

  multiplayer.searchServers({
    onUpdate: function(response) {
      console.log("server lists updated");
      /* update the servers list */
      self.displayServers(response);
    }
  });
};

/* create a host */
Application.prototype.createServer = function() {
  var self = this;

  multiplayer.stopSearchServers(); // don't need anymore to look for server
  multiplayer.createServer({
    // on create server
    onCreate: function(response) {
      self.server.name = response[2];

      $("#console").show();
      $("#button-create_server").hide();
      $("#servers").hide();
      self.say("Server: " + self.server.name +" created");
      // multiplayer.connectToServer(response[2]);
      // console.log(response);

      self.startServerMessaging();
    }, 
    // on message from server
    onMessage: function(response) {
      // console.log("the server received a message");

      // console.log(response);

      self.say("Server received: " + response);
    },
    // on error
    onError: function(response) {
      console.log(response);
    }
  });
};

/* start an auto monologue with the clients */
Application.prototype.startServerMessaging = function() {
  var self = this, message;

  self.server.timerMessaging = setInterval(function() {
    message = self.server.name + " saying hello at " + new Date().getTime();
    multiplayer.sendToClients(message); // send a message to the server
  }, 3000);
};

Application.prototype.stopServerMessaging = function() {
  if(self.server.timerMessaging)
    clearInterval(self.server.timerMessaging);
};


/* connect to the server with his name (could be an IP + port?) */
Application.prototype.connectToServer = function(serverName) {
  var self = this;

  multiplayer.connectToServer({
    serverName:   serverName, 
    // when the client is connected to the host
    onConnection: function(response) {
      $("#console").show();
      $("#button-create_server").hide();
      $("#servers").hide();
      self.startClientMessaging(); // start the server discussion

      self.say("Connected to the server !");    
    },
    // on message received from the server
    onMessage: function(response) {
      // console.log("a message has been received from the server");
      self.say("Client received: " + response);    
    },
    // on error
    onError: function(response) {
      console.log(response);
      self.stopClientMessaging();
      $("#console").hide();
      $("#button-create_server").show();
      $("#servers").show();        
    },
    // on error
    onDisconnection: function(response) {
      console.log(response);
      self.stopClientMessaging();
      $("#console").hide();
      $("#button-create_server").show();
      $("#servers").show();   
      self.searchServers();   
    }
  }); 
};

/* start an auto monologue with the server */
Application.prototype.startClientMessaging = function() {
  var self = this, message;

  self.client.timerMessaging = setInterval(function() {
    message = self.client.name + " saying hello at " + new Date().getTime();
    multiplayer.sendToServer(message); // send a message to the server
  }, 3000);
};

Application.prototype.stopClientMessaging = function() {
  if(self.client.timerMessaging)
    clearInterval(self.client.timerMessaging);
};

Application.prototype.say = function(message) {
  console.log(message);

  // empty the console if too much messages
  if($("#console p").size() > 15) {
    $("#console").empty();
  }

  $("#console").append("<p>" + message + "</p>");
};

/* display the list of the hosts */
Application.prototype.displayServers = function(servers) {

  var self = this,
      serverElement,
      serversWrapper = $("#servers");

  serversWrapper.empty();

  for(var i = 0; i < servers.length; i++) {

    serverElement = $("<div />", {
      "class": "server"
    }).html(servers[i][2]).on("click", function() {
      self.connectToServer($(this).html());    
    }).appendTo(serversWrapper);
  }
};

var application = new Application();
var multiplayer = new Multiplayer();

application.wait();