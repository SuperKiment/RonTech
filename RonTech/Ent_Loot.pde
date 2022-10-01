class Loot {

  String nom;
  PVector pos, posC;
  float speed, taille;
  color couleur;

  Loot() {
    Constructor();
  }
  Loot(float x, float y) {
    Constructor();
    setPos(x, y);
  }
  Loot(float x, float y, String n) {
    Constructor();
    setPos(x, y);
    nom = n;
  }

  void Constructor() {
    nom = "NoName";
    pos = new PVector(2, 5);
    posC = new PVector(2, 5);
    speed = 5;
    couleur = color(random(20, 255), random(20, 255), random(20, 255));
    taille = 10;
  }

  void Update() {
    pos.lerp(posC, speed * time.getDeltaFrames());
  }

  void Display() {
    push();

    fill(couleur);
    translate(GrToSn(pos.x), GrToSn(pos.y));
    ellipse(0, 0, taille, taille);

    pop();
  }

  void DisplayOnScreen(float x, float y) {
    push();

    fill(couleur);
    translate(x - taille, y - taille);
    ellipse(0, 0, taille * 5, taille * 5);

    pop();
  }

  void setPos(float x, float y) {
    pos = new PVector(x, y);
    posC = new PVector(x, y);
  }
}
