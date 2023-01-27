class Solide extends Entity {

  float taille = 4;
  color couleur;

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

  void Display() {
    push();
    fill(couleur);
    translate(GrToSn(pos.x), GrToSn(pos.y));
    ellipse(0, 0, GrToSn(taille), GrToSn(taille));
    pop();
  }
}
