class Mover {
  PVector loc;
  PVector v;
  PVector a;

  float mass;
  float r;
  float G = 0.1;

  Mover(float rr, float p_x, float p_y) {
    mass = rr;
    r = rr;

    loc = new PVector(p_x, p_y);
    v = new PVector(0, 0);
    a = new PVector(0, 0);
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

  PVector attract(Mover m) {
    PVector force = PVector.sub(loc, m.loc);
    float distance = force.mag();
    distance = constrain(distance, 5.0, 25.0);
    force.normalize();

    float strength = (G*mass*mass)/(distance*distance);
    force.mult(strength);
    return force;
  }
}