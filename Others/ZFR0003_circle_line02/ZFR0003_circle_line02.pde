int num =90;
float step, sz, offSet, theta1, theta2, angle;
void setup(){
   size(800,800);
   strokeWeight(3.5);
   step = 9;
   
}

void draw() {
   
   background(20);
   translate(width/2, height/2);
   angle=0;
   for (int i=0; i<num; i++) {
      colorMode(HSB);
      stroke(color(i*255/num,150,255));
      noFill();
      sz = i*step;
      float offSet = TWO_PI/num*i;
      //float arcEnd = map(sin(theta+offSet),-1,1, PI, PI*3);
      if(i%2==0){
         arc(0, 0, sz, sz, offSet+theta1-PI/2,offSet+theta1+PI/2);
      }
      else{
         arc(0, 0, sz, sz, offSet+theta2-PI/2,offSet+theta2+PI/2);
      }
      //arc(0, 0, sz, sz, PI, arcEnd);
   }
   
   resetMatrix();
   theta1 += 0.05;
   theta2 += -0.05;
}