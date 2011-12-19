function Ball() {
  var self = this;

  self.position = {
    x: 0,
    y: 0
  };

  self.ball = $("<div />", {"class": "ball"}).appendTo($("#game"));
};

Ball.prototype.hide = function() {
  this.ball.hide();
};

Ball.prototype.show = function() {
  this.ball.show();
};

Ball.prototype.setColor = function(color) {
  this.ball.css("background", color);
};

Ball.prototype.update = function() {
  var self = this;

  self.ball.css({
    left: self.position.x + "px",
    top: self.position.y + "px"
  });
};

Ball.prototype.remove = function() {
  this.ball.remove();
};