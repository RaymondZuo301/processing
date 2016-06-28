Mover mover;

void setup(){
  size(400,400);
  
  mover = new Mover();
}

void draw(){
  background(255);
  if(mousePressed){
    mover.applyForce(windforce);
  }
  mover.update();
  mover.bounce();
  mover.display();
}