import processing.serial.*;

float r = 0;
void setup() {
  size(800, 800);
  strokeWeight(5);
  smooth();
}
void draw() {
  translate(width/2, height/2);
  background(255);
  float x=0;
  float y=0; 
  for (float st=0; st<2*PI; st+=0.01) {
    r = 50*(st-0+0.0001);
    float xx=r*cos(st);
    float yy=r*sin(st);
    stroke(0);
    line(x, y, xx, yy);
    x = xx;
    y = yy;
  }
}