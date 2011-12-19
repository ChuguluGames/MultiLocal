function Game() {
  var self = this;

  self.timerMove = null;
  self.timerMoveFrequency = 1000;

  self.bounds = {
    x: 480 - 50,
    y: 320 - 50
  }

  self.ball = new Ball();
  self.players = {};

  self.ball.hide();

  self.onUpdate = function() {};
};

Game.prototype.setColor = function(color) {
  var self = this,
      colorVisual = $("<div />", {
    "class": "colorVisual"
  }).css("background", color)
    .appendTo($("#game")); 

  self.ball.setColor(color);
};

Game.prototype.start = function() {
  var self = this;

  self.ball.show();

  self.timerMove = setInterval(function() {
    self.move();
  }, self.timerMoveFrequency);
};

Game.prototype.stop = function() {
  var self = this;

  if(self.timerMove)
    clearInterval(sef.timerMove);
};

Game.prototype.move = function() {
  var self = this;

  self.ball.position = {
    x: randomFromTo(0, self.bounds.x),
    y: randomFromTo(0, self.bounds.y)
  }; 
  
  self.onUpdate(self.ball.position);
  self.ball.update();  
};

Game.prototype.addPlayer = function(player) {
  var self = this;

  self.players[player] = new Ball();
};

Game.prototype.updatePlayer = function(player, position) {
  var self = this;

  self.players[player].position = position;
  self.players[player].update();
};

function randomFromTo(from, to){
  return Math.floor(Math.random() * (to - from + 1) + from);
};