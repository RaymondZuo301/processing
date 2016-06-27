void setup(){
  size(640,640);
  background(0);
}
float time = 0.0;
void draw(){ 
  loadPixels();
  float xoff = 0.0;
  for (int x = 0;x < width; x++){
    xoff += 0.01;
    float yoff = 0.0;
    for (int y = 0; y < height; y++){
      yoff += 0.01;
      float bright = noise(xoff,yoff,time)*255;
     // float bright = map(noise(xoff,yoff),0,1,0,255);
      pixels[x+y*width] = color(bright);
    }    
  }
  updatePixels();
  time += 0.01;
}