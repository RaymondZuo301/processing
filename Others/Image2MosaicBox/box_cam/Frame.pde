class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(10, 10);
    cp5 = new ControlP5(this);

    cp5.addSlider("d_w")
      .plugTo(parent, "d_w")
      .setPosition(100, 50)
      .setSize(200, 20)
      .setRange(1, 30)
      .setValue(10);
      
    cp5.addSlider("d_h")
      .plugTo(parent, "d_h")
      .setPosition(100, 100)
      .setSize(200, 20)
      .setRange(1, 30)
      .setValue(10);
  }

  void draw() {
    background(0);
  }
}