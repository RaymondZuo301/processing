Mover[] movers = new Mover[100];

float tx,ty;

void setup(){
  size(400,400);
  tx = random(1000);
  ty = random(1000,2000);
  
  for (int i = 0; i < movers.length; i++){
    movers[i] = new Mover(random(5, 10), random(width), random(height));    
  }

}

void draw(){
  background(255);
  for (int i = 0; i < movers.length; i++ ){
    movers[i].applyForce(movers[i].get_windForce(tx,ty));//施加风力
    movers[i].applyForce(movers[i].gravity);//施加重力
    
    movers[i].bounce();//边缘反弹
    movers[i].update();
    movers[i].display();     
  }
  tx += 0.1;
  ty += 0.1;
}