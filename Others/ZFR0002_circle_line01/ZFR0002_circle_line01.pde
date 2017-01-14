int num =30;
float step, sz, offSet, theta;

void setup() {
  size(800, 800);
  strokeWeight(5);
  step = 20;
  colorMode(HSB);
}

void draw() {
  background(0);
  translate(width/2, height/2);
  for (int i=0; i<num; i++) {    
    stroke(color(i*255/num, 150, 255));
    noFill();
    sz = i*step;
    float offSet = TWO_PI/num*i;
    float arcEnd = map(sin(theta+offSet), -1, 1, 0, PI);
    arc(0, 0, sz, sz, (arcEnd-PI), arcEnd);
    //arc(0, 0, sz, sz, PI, arcEnd);
  }
  theta += .04;
}