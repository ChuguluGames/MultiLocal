var multiplayer = {
  onUpdateServices: function(services) {
    console.log(services)
    var service,
        container = $("#services");

    container.empty();

    for(var i = 0; i < services.length; i++) {
      service = services[i];
      console.log(service)
      container.append("<p>a service is on domain: " + service[0] + " with type: " + service[1] + " with name: " + service[2] + "</p>");
    }
  },
  onCreateService: function(service) {
    console.log(service)

    $("#myservice").html("my service is on domain: " + service[0] + " with type: " + service[1] + " with name: " + service[2]);
  },
  onMessage: function(message) {
    console.log(message);
  },
  createHost: function(success, fail) {
    PhoneGap.exec(function() {}, function() {}, "MultiPlayer", "searchServices", [{callbackOnUpdateServices: "onUpdateServices"}]);
    PhoneGap.exec(function() {}, function() {}, "MultiPlayer", "createService", [{callbackOnCreateService: "onCreateService", callbackOnMessage: "onMessage"}]);  
  }
};

document.addEventListener("deviceready", function() {
  multiplayer.createHost();
}, false);