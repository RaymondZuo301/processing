class Line{
  float start_x, end_x, start_y, end_y, start_z, end_z;
  float len = 100;
  float r_x, r_y, r_z;
  
  PVector dir;
  PVector line;
  PVector endline;
  PVector trans;
  
  Line(Line l){
    dir = new PVector(0, -1, 0);
    trans = new PVector(l.end_x, l.end_y, l.end_z);
    start_x = l.end_x; start_y = l.end_y; start_z = l.end_z;
    println(1);
    println(trans);
  }
  Line(float x, float y, float z){
    dir = new PVector(0, -1, 0);
    trans = new PVector(x, y, z);
    start_x = x; start_y = y; start_z = z;
  }
  
  void rotattion(){
    
  }
  void update(){
    line = PVector.mult(dir, len);
    endline = PVector.add(line, trans);
    end_x = endline.x; 
    end_y = endline.y;
    end_z = endline.z;
  }
  void display(){  
    stroke(255);

    pushMatrix();
    translate(trans.x, trans.y, trans.z);
    rotateX(-PI/4);
    line(0, 0, 0, line.x, line.y, line.z);
    popMatrix();
  }
}