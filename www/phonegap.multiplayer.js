function Multiplayer() {
  this.events = {
    server: {},
    browser: {},
    client: {}
  };
};


Multiplayer.prototype.exec = function(method, options) {
  PhoneGap.exec(function() {}, function() {}, "MultiPlayer", method, options);   
};

Multiplayer.prototype.createServer = function(params) {
  var self = this;

  self.events.server.onCreate = params.onCreate;
  self.events.server.onMessage = params.onMessage;
  self.events.server.onError = params.onError;

  self.exec("createServer", [{}]);
};

Multiplayer.prototype.searchServers = function(params) {
  var self = this;

  self.events.browser.onUpdate = params.onUpdate;

  self.exec("searchServers", [{}]);  
};

Multiplayer.prototype.stopSearchServers = function(params) {
  var self = this;

  self.exec("stopSearchServers", [{}]);  
};

Multiplayer.prototype.connectToServer = function(params) {
  var self = this;

  self.events.client.onConnection = params.onConnection;
  self.events.client.onDisconnection = params.onDisconnection;  
  self.events.client.onMessage = params.onMessage;
  self.events.client.onError = params.onError;

  self.exec("connectToServer", [{name: params.serverName}]);  
};

Multiplayer.prototype.sendToServer = function(message) {
  var self = this;

  self.exec("sendToServer", [{message: message}]);  
};

Multiplayer.prototype.sendToClients = function(message) {
  var self = this;

  self.exec("sendToClients", [{message: message}]);  
};