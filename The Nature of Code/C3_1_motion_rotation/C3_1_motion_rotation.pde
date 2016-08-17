Mover[] movers = new Mover[20];

Attractor a;

void setup() {
  size(500,500);
  background(255);

  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(5,20), random(width), random(height));
  }
  a = new Attractor();
}

void draw() {
  background(255);
  
  a.display();
  
  for (int i = 0; i < movers.length; i++) {
    PVector force = a.attract(movers[i]);
    movers[i].applyForce(force);
    
    movers[i].bounce();//边缘反弹
    movers[i].update();//更新数据
    movers[i].display();//显示
  }
}