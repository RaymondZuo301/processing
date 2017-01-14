import controlP5.*;
import processing.video.*;  

PImage photo;
Capture video;

ControlFrame cf;

int d_w = 10;
int d_h = 10;
color c;

void settings() {
  size(640, 480, P3D);
}

void setup() {
  cf = new ControlFrame(this, 400, 400, "Controls");
  surface.setLocation(420, 10);

  smooth(8);
  colorMode(HSB);
  video = new Capture(this, width, height);
  video.start();  
  background(255);
  noStroke();
}

void draw() {
  background(255);
  video.read();
  video.loadPixels();
  //camera control
  lights();  
  camera(-(mouseX-width/2)*4, -(mouseY-height/2)*4, 500, // eyeX, eyeY, eyeZ
    width/2, height/2, 0, // centerX, centerY, centerZ
    0.0, 1.0, 0.0);//upX, upY, upZ

  //draw box
  for (int i = 0; i<width/d_w; i++) {
    for (int j = 0; j<height/d_h; j++) {
      c = video.get(i*d_w, j*d_h);
      float h = brightness(c)/2;
      pushMatrix();
      translate(i*d_w, j*d_h, h/2);
      fill(c);
      box(d_w, d_h, h);
      popMatrix();
    }
  }
  println(frameRate);
}