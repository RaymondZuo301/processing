Mover mover;

void setup(){
  size(400,400);
  
  mover = new Mover();
}

void draw(){
  background(255);
  mover.checkPress();
  mover.update();
  mover.bounce();
  mover.display();
}