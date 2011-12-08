var multiplayer = {
  print: function(message, success, fail) {
    PhoneGap.exec(success, fail, "MultiPlayer", "print", [message]);  
  },  
  getConnectedDevices: function(success, fail) {
    PhoneGap.exec(success, fail, "MultiPlayer", "getConnectedDevices", []);  
  }
};

document.addEventListener("deviceready", function() {
  testGetConnectedDevices();
}, false);

function testPrint() {
  multiplayer.print(
    "hellowolrd",
    function(result) {
      alert(result)
      console.log(result);
    },

    function(error) {
      alert(error)
      console.log(error);
    }
  );  
}

function testGetConnectedDevices() {
  multiplayer.getConnectedDevices(
    function(response) {
      response = JSON.parse(response);
      console.log(response);
    },

    function(error) {
      alert(error)
      console.log(error);
    }
  );
}