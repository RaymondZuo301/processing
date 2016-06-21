class Walker{
  float x;
  float y;
  Walker(){
    x = width/2;
    y = height/2;
  }
  void display(){
    stroke(0);
    point(x,y);
  }
  
  void step(){
    /* 1 pixel per step
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
    /*
    int stepx = int(random(3))-1;
    int stepy = int(random(3))-1;
    x += stepx;
    y += stepy;
    */
    float stepx = random(-1, 1);
    float stepy = random(-1, 1);
    x += stepx;
    y += stepy;
    println(stepx,stepy);
  }
}
Walker w;
void setup(){
  size(640,360);
  w  = new Walker();
  background(255);
}
void draw(){
  w.step();
  w.display();
}