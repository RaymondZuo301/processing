int num =100;
float step, sz, offSet, theta, angle, perlin;

void setup(){
   size(800,600);
   strokeWeight(5);
   step = 8;
   
}

void draw() {
   
   background(20);
   translate(0, height/2);
   angle=0;
   for (int i=0; i<num; i++) {
      colorMode(HSB);
      stroke(color(abs(i*255/num-theta*80)%255,120,255));
      noFill();
      sz = i*step+10;
      float offSet = TWO_PI/num*i;
      float arcEnd = map(sin(theta+offSet),-1,1, 0, 100);
      line(sz, arcEnd*(noise(perlin)-1)*2, sz, -arcEnd*(noise(perlin)-1)*2);
      perlin+=0.01;
      //arc(0, 0, sz, sz, PI, arcEnd);
   }
   
   resetMatrix();
   theta += .04;
   
   
}