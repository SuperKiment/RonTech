class Solide implements Entity {

  PVector pos;
  float taille;
  color couleur;

  Solide() {
    Constructor(10, 5);
  }
  Solide(float x, float y) {
    Constructor(x, y);
  }

  void Constructor(float x, float y) {
    pos = new PVector(x, y);
    taille = 200;
    couleur = color(#98A3AD);
  }

  void Update() {
  }

  void Display() {
    push();
    fill(couleur);
    translate(GrToSn(pos.x), GrToSn(pos.y));
    ellipse(0, 0, taille, taille);
    pop();
  }

  //INTERFACE ENTITY
  boolean isDisplay = false;
  PVector getPos() {
    return pos;
  }
}
