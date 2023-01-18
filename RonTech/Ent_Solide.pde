class Solide implements Entity {

  PVector pos;
  float taille = 4;
  color couleur;
  boolean isDisplay = false;

  Solide() {
    Constructor(10, 5);
  }
  Solide(float x, float y) {
    Constructor(x, y);
  }

  void Constructor(float x, float y) {
    pos = new PVector(x, y);
    couleur = color(#98A3AD);
  }

  void Update() {
  }

  void Display() {
    push();
    fill(couleur);
    translate(GrToSn(pos.x), GrToSn(pos.y));
    ellipse(0, 0, GrToSn(taille), GrToSn(taille));
    pop();
  }

  //INTERFACE ENTITY
  //INTERFACE ENTITY

  PVector getPos() {
    return pos;
  }

  boolean isMort() {
    return false;
  }

  boolean isDisplay() {
    return isDisplay;
  }

  void setIsDisplay(boolean b) {
    isDisplay = b;
  }

  JSONObject getJSON() {
    JSONObject json = new JSONObject();

    json.setString("Class", getObjectClassName(this));
    json.setFloat("pos.x", pos.x);
    json.setFloat("pos.y", pos.y);
    json.setFloat("taille", taille);

    return json;
  }

  float getTaille() {
    return taille;
  }
}
