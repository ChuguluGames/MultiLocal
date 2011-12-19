/* search accessible hosts */
Application.prototype.searchServers = function() {
  var self = this;

  console.log("calling native searchServers method");

  self.multi.searchServers({
    onStart: function(response) {
      // console.log(response);
    },
    onUpdate: function(response) {
      if(typeof response == "string") response = JSON.parse(response);
      console.log(response)
      console.log("server lists updated");
      /* update the servers list */
      self.displayServers(response.servers);
    },
    onStop: function(response) {
      
    },
    onError: function(response) {
      
    }
  });
};

/* display the list of the hosts */
Application.prototype.displayServers = function(servers) {

  var self = this,
      serverElement,
      serversWrapper = $("#servers");

  serversWrapper.empty();

  for (var server in servers) {

    serverElement = $("<div />", {
      "class": "server"
    }).html(servers[server].name).on("click", function() {
      self.connectToServer($(this).html());    
    }).appendTo(serversWrapper);
  }
};