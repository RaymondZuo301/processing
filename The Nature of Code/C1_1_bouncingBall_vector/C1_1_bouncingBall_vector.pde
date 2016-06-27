PVector location;
PVector velocity;

void setup() {
  size(200, 200);
//  smooth();
  location = new PVector(100, 100);
  velocity = new PVector(2.5 ,5);
  background(255); 
}

void draw(){ 
  //覆盖一个透明白色块以实现运动轨迹↓
  noStroke();
  fill(255,10);
  rect(0,0,width,height);
  location.add(velocity);
  //↑
  
  if((location.x > width) || (location.x < 0)){
    velocity.x = velocity.x*-1;
  }
  if((location.y > height) || (location.y < 0)){
    velocity.y = velocity.y*-1;  
  }
  stroke(0);
  fill(175);
  ellipse(location.x, location.y, 16, 16);
}