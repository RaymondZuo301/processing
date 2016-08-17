class Attractor {
  float mass;
  PVector loc;
  float G;

  Attractor() {
    loc = new PVector(width/2, height/2);
    mass = 20;
    G = 0.4;
  }

  PVector attract(Mover m) {
    PVector force = PVector.sub(loc, m.loc);
    float distance = force.mag();
    distance = constrain(distance, 5.0, 25.0);
    force.normalize();

    float strength = (G*mass*m.mass)/(distance*distance);
    force.mult(strength);
    return force;
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(loc.x, loc.y, 48, 48);
  }
}