Walker w;
void setup() {
  size(400,400);
  w  = new Walker();
  background(255);
}
void draw() {
  w.step();
  w.display();
}