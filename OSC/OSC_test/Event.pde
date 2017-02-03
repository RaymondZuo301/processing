public void touch1(float x, float y){
  xy1[0] = y;
  xy1[1] = 1-x;
}
public void touch2(float x, float y){
  xy2[0] = y;
  xy2[1] = x;
}
public void touch3(float x, float y){
  xy3[0] = y;
  xy3[1] = x;
}
public void touch4(float x, float y){
  xy4[0] = y;
  xy4[1] = x;
}
public void touch5(float x, float y){
  xy5[0] = y;
  xy5[1] = x;
}

public void touch1_remove(float x){
  xy1[0] = -200;
  xy1[1] = -200;
}
public void touch2_remove(float x){
  xy2[0] = -200;
  xy2[1] = -200;
}
public void touch3_remove(float x){
  xy3[0] = -200;
  xy3[1] = -200;
}
public void touch4_remove(float x){
  xy4[0] = -200;
  xy4[1] = -200;
}
public void touch5_remove(float x){
  xy5[0] = -200;
  xy5[1] = -200;
}


public void colorSet_red(float x){
  red = int(x);
}

public void colorSet_green(float x){
  green = int(x);
}

public void colorSet_blue(float x){
  blue = int(x);
}

public void setSize(float x){
  size = x*200;
}