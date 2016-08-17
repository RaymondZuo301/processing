class Mover {
  PVector loc;//位置
  PVector v;//速度
  PVector a;//加速度
  float mass;//质量
  float r;//半径

  float angle = 0;//角度
  float angleV = 0;//角速度
  float angleA = 0;//角加速度

  Mover(float rr, float p_x, float p_y) {
    mass = rr;
    r = rr;

    loc = new PVector(p_x, p_y);
    v = new PVector(random(-1, 1), random(-1, 1));
    a = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    a.add(f);
  }

  void update() {
    v.add(a);
    loc.add(v);

    angleA = a.x / 10.0;
    angleV += angleA;
    angleV = constrain(angleV, -0.01, 0.1);//constrain限制角速度
    angle += angleV;

    a.mult(0);
  }

  void display() {
    stroke(0);
    fill(175, 200);
    rectMode(CENTER);
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(angle);
    rect(0, 0, r, r);
    popMatrix();
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
}