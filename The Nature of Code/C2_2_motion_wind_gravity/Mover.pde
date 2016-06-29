class Mover {
  PVector loc;
  PVector v;
  PVector a;
  PVector windforce;//风力
  PVector gravity;//重力
  
  float topspeed;
  float mass;
  float g = 0.0098;
  float r;
  Mover(float rr, float p_x, float p_y) {
    mass = rr;
    r = rr;
    
    loc = new PVector(p_x, p_y);
    v = new PVector(0, 0);
    a = new PVector(0, 0);
    gravity = new PVector(0, mass*g);

    topspeed = 5;
    

  }

  void update() {
    v.add(a);
    v.limit(topspeed);
    loc.add(v);
    a.mult(0);
  }

  void display() {
    stroke(0);
    fill(175);
    ellipse(loc.x, loc.y, r*2, r*2);
  }
  
  void applyForce(PVector force){
    PVector f = PVector.div(force, mass);
    a.add(force);
  }
  
  void bounce(){
    if(loc.x-r < 0){
      loc.x = r;
      v.x = v.x*-1;
    }
    else if(loc.x+r > width){
      loc.x = width-r;
      v.x = v.x*-1;
    }
    if(loc.y-r < 0){
      loc.y = r;
      v.y = v.y*-1; 
    }
    else if(loc.y+r > height){
      loc.y = height-r;
      v.y = v.y*-1; 
    }
  }
  
  PVector get_windForce(float tx, float ty){
    float wf_x = map(noise(tx), 0,1,-0.1,0.1);
    float wf_y = map(noise(ty), 0,1,-0.1,0.1);
    
    windforce = new PVector(wf_x, wf_y);

    
    return windforce;
  }
}