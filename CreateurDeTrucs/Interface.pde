class HUD {
  HashMap<String, Button> AllButtons;

  HUD() {
    AllButtons = new HashMap<String, Button>();


    AllButtons.put("salut", new Button());
  }

  void Update() {
  }

  void Display() {
    for (HashMap.Entry<String, Button> set : AllButtons.entrySet()) {
      set.getValue().Display();
    }
  }

  void click() {
    for (HashMap.Entry<String, Button> set : AllButtons.entrySet()) {
      if (set.getValue().isMouseOnTop()) {
        println("Click sur " + set.getKey());
        break;
      }
    }
  }
}

class Button {

  PVector pos, dim;
  color couleur = color(125);

  Button() {
    pos = new PVector(50, 50);
    dim = new PVector(50, 50);
  }

  Button(float xp, float yp, float xd, float yd) {
    pos = new PVector(xp, yp);
    dim = new PVector(xd, yd);
  }

  void Display() {
    push();
    float mult = 1;
    if (isMouseOnTop()) {
      setColor(color(200));
      mult = 1.1;
    } else setColor(color(100));
    translate(pos.x, pos.y);
    fill(couleur);
    rect(0, 0, dim.x*mult, dim.y*mult, 10);
    pop();
  }

  void setPos(float x, float y) {
    pos = new PVector(x, y);
  }

  void setDim(float x, float y) {
    dim = new PVector(x, y);
  }

  void setColor(color col) {
    couleur = col;
  }

  boolean isMouseOnTop() {
    if (mouseX > pos.x-dim.x/2 && mouseX < pos.x+dim.x/2 &&
      mouseY > pos.y-dim.y/2 && mouseY < pos.y+dim.y/2) return true;
    return false;
  }
}
