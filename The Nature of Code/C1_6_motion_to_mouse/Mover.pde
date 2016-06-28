class Mover{
  PVector loc;
  PVector v;
  PVector a;
  
  float topspeed;

  Mover(){
    loc = new PVector(width/2, height/2);
    v = new PVector(0,0);

    topspeed = 10;   
  }
  
  void update(){
    PVector mouse = new PVector(mouseX, mouseY);
    PVector dir = PVector.sub(mouse, loc);
    PVector a = new PVector(0, 0);
    dir.normalize();
    dir.mult(0.5);
    a = dir;
    v.add(a);
    v.limit(topspeed);
    loc.add(v);
  }
  
  void display(){
    stroke(10);
    fill(175);
    ellipse(loc.x, loc.y, 16, 16);
  }

  void checkEdges(){
    if(loc.x > width){
      loc.x = 0;
    }
    else if(loc.x < 0){
      loc.x = width;
    }
    if(loc.y > height){
      loc.y = 0;
    }
    else if(loc.y < 0){
      loc.y = height;
    } 
  }
}