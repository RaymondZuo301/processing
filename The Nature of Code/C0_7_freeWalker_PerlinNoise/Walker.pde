class Walker {
  float x,y;
  float tx,ty;
  //初始化位置
  Walker() {
    tx = 0;
    ty = 1000;
  }
  void display() {
    stroke(0);
    point(x, y);
  }
  //行走规则
  void step() {
    x = map(noise(tx),0,1,0,width);
    y = map(noise(ty),0,1,0,height);
    tx += 0.001;
    ty += 0.001;
  }
}