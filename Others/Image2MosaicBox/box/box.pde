PImage photo;
int d_w = 10;
int d_h = 10;
color c;

void setup() {
  photo = loadImage("2.jpg");
  size(1920,1080, P3D);
  background(255);
  noStroke();
}

void draw() {
  background(255);

  /*camera control*/
  lights();  
  camera(-(mouseX-width/2)*4, -(mouseY-height/2)*4, 1600, // eyeX, eyeY, eyeZ
    width/2, height/2, 0, // centerX, centerY, centerZ
    0.0,1.0,0.0);//upX, upY, upZ

  /*draw box*/
  for (int i = 0; i<width/d_w; i++) {
    for (int j = 0; j<height/d_h; j++) {
      c = photo.get(i*d_w+int(random(5)), j*d_h+int(random(5)));
      float h = (green(c)+red(c)+blue(c))/4;
      pushMatrix();
      translate(i*d_w, j*d_h, h/2);
      fill(c);
//      if (h*4>650) {
//               box(d_w, d_h, h);
//      } else {
        box(d_w, d_h, h);
//      }
      popMatrix();
    }
  }
}