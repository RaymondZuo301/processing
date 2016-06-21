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
    float randomNum = random(1);
      if (randomNum<0.5) {//50%自由运动
        float stepx = random(-1, 1);
        float stepy = random(-1, 1);
        x += stepx;
        y += stepy;
      }
      else{//50%向鼠标运动
        float len = random(0,sqrt(2));
        float a = mouseX-x;
        float b = mouseY-y;
        float c = sqrt(sq(a)+sq(b));
        x += len*a/c;
        y += len*b/c;
      }
  }
}