class Mover {
  PVector loc;
  PVector v;
  PVector a;
  PVector gravity;//重力

  float mass;
  float g = 0.098;
  float r;
  Mover(float rr, float p_x, float p_y) {
    mass = rr;
    r = rr;

    loc = new PVector(p_x, p_y);
    v = new PVector(0, 0);
    a = new PVector(0, 0);
    gravity = new PVector(0, mass*g);
  }

  void update() {
    v.add(a);
    loc.add(v);
    a.mult(0);
  }

  void display() {
    stroke(0);
    fill(175);
    ellipse(loc.x, loc.y, r*2, r*2);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    a.add(f);
  }

  void bounce() {
    if (loc.x-r < 0) {
      loc.x = r;
      v.x = v.x*-1;
    } else if (loc.x+r > width) {
      loc.x = width-r;
      v.x = v.x*-1;
    }
    if (loc.y-r < 0) {
      loc.y = r;
      v.y = v.y*-1;
    } else if (loc.y+r > height) {
      loc.y = height-r;
      v.y = v.y*-1;
    }
  }
  
  boolean isInside(Liquid l) {//判断在液体内
    if (loc.x > l.x && loc.x < l.x+l.w &&loc.y > l.y && loc.y < l.y+l.h) {
      return true;
    } else {
      return false;
    }
  }
  
  void drag(Liquid l){
    float speed = v.mag();
    float dragMagnitude = l.c*speed*speed;
    
    PVector drag = v.get();
    drag.mult(-1);
    drag.normalize();
    drag.mult(dragMagnitude);
    applyForce(drag);
  }
}