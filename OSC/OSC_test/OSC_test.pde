import netP5.*;
import oscP5.*;

OscP5 oscReceive;
NetAddress oscSend;
//float [] xy = new float[2];
float[] xy1 = {-200, -200};
float[] xy2 = {-200, -200};
float[] xy3 = {-200, -200};
float[] xy4 = {-200, -200};
float[] xy5 = {-200, -200};
int red = 0;
int green = 0;
int blue = 0;
float size = 50;

void setup(){
  size(800, 800);
  background(255);
  
  oscReceive = new OscP5(this,12000);
  oscSend = new NetAddress("192.168.0.101",10000);
  
  oscReceive.plug(this,"touch1","/1/touch");
  //oscReceive.plug(this,"touch2","/1/touch/2");
  //oscReceive.plug(this,"touch3","/1/touch/3");
  //oscReceive.plug(this,"touch4","/1/touch/4");
  //oscReceive.plug(this,"touch5","/1/touch/5");
  oscReceive.plug(this,"touch1_remove","/1/touch/z");
  //oscReceive.plug(this,"touch2_remove","/1/touch/2/z");
  //oscReceive.plug(this,"touch3_remove","/1/touch/3/z");
  //oscReceive.plug(this,"touch4_remove","/1/touch/4/z");
  //oscReceive.plug(this,"touch5_remove","/1/touch/5/z");
  oscReceive.plug(this,"colorSet_red","/1/red");
  oscReceive.plug(this,"colorSet_green","/1/green");
  oscReceive.plug(this,"colorSet_blue","/1/blue");
  oscReceive.plug(this,"setSize","/1/size");
}

void draw(){
  //background(10);
  //fill(255,10);
  //rect(0,0,width,height);
  fill(color(red, green ,blue));
  noStroke();
  ellipse(xy1[0]*800,xy1[1]*800, size, size);
  //ellipse(xy2[0]*800,xy2[1]*800, size, size);
  //ellipse(xy3[0]*800,xy3[1]*800, size, size);
  //ellipse(xy4[0]*800,xy4[1]*800, size, size);
  //ellipse(xy5[0]*800,xy5[1]*800, size, size);
}

void mouseMoved(){

  xy1[0] = float(mouseX)/800;
  xy1[1] = float(mouseY)/800;
  oscReceive.send("/1/red", new Object[] {xy1[0]*255}, oscSend);
  //oscReceive.send("/1/touch/z", new Object[] {1.0}, oscSend);
  //oscReceive.send("/1/touch/1/z", new Object[] {1.0}, oscSend);
  oscReceive.send("/1/touch/1", new Object[] {(1-xy1[0]), xy1[1]}, oscSend);
  //println("move",xy1[0],xy1[1]);
  //OscMessage m = new OscMessage("/1/red");
  //m.add(xy1[0]*255);
  //m.add(xy1[1]);
  //oscReceive.send(m, oscSend); 
}

void oscEvent(OscMessage theOscMessage) {
  //println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
  //println(theOscMessage.arguments());
  //xy = float(split(theOscMessage.arguments().toString(), ' '));
  //println(theOscMessage.arguments());
  //xy[0] = theOscMessage.get(0).floatValue();
  //xy[1] = theOscMessage.get(1).floatValue();
}