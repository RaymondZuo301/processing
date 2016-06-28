void setup() {
  size(640, 640, P3D);
  smooth();
  loc = new PVector(width/2, height/2, -(width/2));
  v = new PVector(random(10), random(10), random(10));
}
PVector loc;
PVector v;

void draw() {
  background(0);
  lights();  
    camera(-(mouseX-320)*3, -(mouseY-320)*3, 800.0, // eyeX, eyeY, eyeZ
         width/2, height/2, -(width/2), // centerX, centerY, centerZ
         0.0, 1.0, 0.0); // upX, upY, upZ
  noFill();
  stroke(255);
  translate(width/2, height/2, -(width/2));
  box(width, height, width);
  translate(-width/2, -height/2, (width/2));

  loc.add(v);
  if ((loc.x > width)  ||  (loc.x < 0)) {
    v.x = v.x*-1;
  }
  if ((loc.y > height)  ||  (loc.y < 0)) {
    v.y = v.y*-1;
  }
  if ((loc.z < -width)  ||  (loc.z > 0)) {
    v.z = v.z*-1;
  }
  translate(loc.x, loc.y, loc.z);
  stroke(255);
  sphere(16);
  translate(-loc.x, -loc.y, -loc.z);
}