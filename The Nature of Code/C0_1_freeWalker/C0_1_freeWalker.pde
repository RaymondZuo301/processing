//Walker类
class Walker {
  float x;
  float y;
  //初始化位置
  Walker() {
    x = width/2;
    y = height/2;
  }
  void display() {
    stroke(0);
    point(x, y);
  }
  //行走规则
  void step() {
    /*每轴1像素，4个随机方向
     int choice = int(random(4));
     if (choice == 0){
     x++;
     }
     else if (choice == 1){
     x--;
     }
     else if (choice == 2){
     y++;
     }
     else{
     y--;
     }
     */
    /*每轴[-1,0,1],8个方向
     int stepx = int(random(3))-1;
     int stepy = int(random(3))-1;
     x += stepx;
     y += stepy;
     */
    //每轴（-1, 1）浮点数
    float stepx = random(-1, 1);
    float stepy = random(-1, 1);
    x += stepx;
    y += stepy;
  }
}
Walker w;
void setup() {
  size(200,200);
  w  = new Walker();
  background(255);
}
void draw() {
  w.step();
  w.display();
}