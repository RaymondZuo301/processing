class Mover {
  PVector loc;
  PVector v;

  Mover() {
    loc = new PVector(random(width), random(height));
    v = new PVector(random(-10, 10), random(-10, 10));
  }

  void update() {
    loc.add(v);
  }

  void display() {
    stroke(0);
    fill(175);
    ellipse(loc.x, loc.y, 16, 16);
  }

  void checkEdges() {
    if (loc.x > width) {
      loc.x = 0;
    } 
    else if (loc.x < 0) {
      loc.x = width;
    }

    if (loc.y > height) {
      loc.y = 0;
    } 
    else if (loc.y < 0) {
      loc.y = height;
    }
  }
}