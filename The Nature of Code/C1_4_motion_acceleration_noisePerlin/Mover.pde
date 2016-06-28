class Mover {
  PVector loc;
  PVector v;
  PVector a;

  float topspeed;
  float tx, ty, ax, ay;
  Mover() {
    loc = new PVector(random(width), random(height));
    v = new PVector(0, 0);
    topspeed = 5;
    tx = random(1000);
    ty = random(1000,2000);
  }

  void update() {
    ax = map(noise(tx), 0,1,-1,1);
    ay = map(noise(ty), 0,1,-1,1);
    a = new PVector(ax, ay);
    a.mult(10);
    v.add(a);
    v.limit(topspeed);
    loc.add(v);
    tx += 0.1;
    ty += 0.1;
    println(a);
  }

  void display() {
    stroke(0);
    fill(175);
    ellipse(loc.x, loc.y, 16, 16);
  }

  void checkEdges() {
    if (loc.x > width) {
      loc.x = 0;
    } else if (loc.x < 0) {
      loc.x = width;
    }

    if (loc.y > height) {
      loc.y = 0;
    } else if (loc.y < 0) {
      loc.y = height;
    }
  }
}