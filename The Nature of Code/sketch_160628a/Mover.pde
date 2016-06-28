class Mover {
  PVector loc;
  PVector v;
  PVector a;
  PVector windforce;//风力
  PVector buoyance;//浮力
  
  float topspeed;
  float tx, ty, wf_x, wf_y;
  float r = 50;//半径
  
  Mover() {
    loc = new PVector(random(width), random(height));
    v = new PVector(0, 0);
    a = new PVector(0, 0);
    buoyance = new PVector(0, -0.1);
    topspeed = 5;
    
    tx = random(1000);
    ty = random(1000,2000);
  }

  void update() {
    wf_x = map(noise(tx), 0,1,-1,1);
    wf_y = map(noise(ty), 0,1,-1,1);
    windforce = new PVector(wf_x, wf_y);
    applyForce(buoyance);
    v.add(a);
    v.limit(topspeed);
    loc.add(v);
    a.mult(0);
    tx += 0.1;
    ty += 0.1;
  }

  void display() {
    stroke(0);
    fill(175);
    ellipse(loc.x, loc.y, r*2, r*2);
  }
  
  void applyForce(PVector force){
    a.add(force);
  }
  
  void bounce(){
    if(loc.x-r < 0){
      loc.x = r;
      v.x = v.x*-1;
      v.mult(0.9);
    }
    else if(loc.x+r > width){
      loc.x = width-r;
      v.x = v.x*-1;
      v.mult(0.9);
    }
    if(loc.y-r < 0){
      loc.y = r;
      v.y = v.y*-1; 
      v.mult(0.9);
    }
    else if(loc.y+r > height){
      loc.y = height-r;
      v.y = v.y*-1; 
      v.mult(0.9);
    }
  }
}