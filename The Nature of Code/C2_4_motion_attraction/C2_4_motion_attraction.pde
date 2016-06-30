Mover[] movers = new Mover[100];

void setup() {
  size(400, 400);

  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(5, 10), random(width), random(height));
  }
}

void draw() {
  background(255);
  for (int i = 0; i < movers.length; i++ ) {
    for (int j = 0; j < movers.length; j++ ) { 
      if (i != j) {
        PVector force = movers[j].attract(movers[i]);
        movers[i].applyForce(force);
      }
    }
    movers[i].bounce();//边缘反弹
    movers[i].update();
    movers[i].display();
  }
}