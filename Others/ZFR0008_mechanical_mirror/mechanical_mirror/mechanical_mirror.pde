import processing.video.*;  

Capture video;
int d_w = 640/25;
int d_h = 480/25;

void settings() {
  size(640, 480, P3D);
}

void setup() {
  background(255);
  smooth(8);
  colorMode(RGB);
  video = new Capture(this, width, height);
  video.start();  
  background(255);
  noStroke();
}

void draw() {
  background(0);
  video.read();
  video.loadPixels();
  directionalLight(245,222,179,0,1,-1);
  
  camera(-(mouseX-width/2)*4, -(mouseY-height/2)*4, 500, // eyeX, eyeY, eyeZ
    width/2, height/2, 0, // centerX, centerY, centerZ
    0.0, 1.0, 0.0);//upX, upY, upZ
    
  for (int i = 0; i<width/d_w; i++) {
    for (int j = 0; j<height/d_h; j++) {
      color c = video.get(i*d_w, j*d_h);
      float gray = (red(c)+blue(c)+green(c))/3;
      float rotate = map(gray,0,255,0,0.25);
      pushMatrix();
      translate(i*d_w, j*d_h);
      rotateX(PI*rotate);
      fill(255);
      //fill(gray);
      box(d_w, d_h, 5);
      popMatrix();
    }
  }
}