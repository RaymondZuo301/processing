void setup(){
  size(640,640);
  background(255);
}
void draw() {
  float sd = 100;
  float mean = 320;
  float x = sd*randomGaussian()+320;
  float y = sd*randomGaussian()+320;
  noStroke();
  fill(int(random(255)),int(random(255)),int(random(255)));
  ellipse(x, y, 16, 16);
}