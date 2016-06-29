Line line1, line2;

void setup() {
  size(400, 400, P3D);
  line1 = new Line(width/2, height, -width/2);
}

void draw() { 
  background(0);
  camera(-(mouseX-320)*3, -(mouseY-320)*3, 400.0, // eyeX, eyeY, eyeZ
    width/2, height/2, -(width/2), // centerX, centerY, centerZ
    0.0, 1.0, 0.0); // upX, upY, upZ
  noFill();
  stroke(255);
  translate(width/2, height/2, -(width/2));
  box(width, height, width);
  translate(-width/2, -height/2, (width/2));
  
  line1.update();
  line1.display();
  line2 = new Line(line1);
  line2.update();
  line2.display();
}