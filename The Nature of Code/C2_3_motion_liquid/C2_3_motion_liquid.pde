Mover[] movers = new Mover[100];
Liquid liquid;

void setup(){
  size(400,400);
  liquid = new Liquid(0, height/2, width, height/2, 0.5);
  
  for (int i = 0; i < movers.length; i++){
    movers[i] = new Mover(random(5, 10), random(width), random(height/2));    
  }

}

void draw(){
  background(255);
  liquid.display();
  
  for (int i = 0; i < movers.length; i++ ){
    if (movers[i].isInside(liquid)){
      movers[i].drag(liquid);
    }
    movers[i].applyForce(movers[i].gravity);//施加重力
    movers[i].bounce();//边缘反弹
    movers[i].update();
    movers[i].display();     
  }
}