class Enemy implements Entity, Damageable {
  float HP = 100, taille;
  PVector pos, posC;
  boolean isDisplay = true;


  Enemy() {
    Constructor();
  }

  Enemy(float x, float y) {
    Constructor();
    pos = new PVector(x, y);
  }

  void Constructor() {
    pos = new PVector();
    taille = mapActif.tailleCase/2;
  }

  void Display() {
    push();
    translate(pos.x * mapActif.tailleCase, pos.y * mapActif.tailleCase);
    fill(255, 0, 0);
    ellipse(0, 0, taille, taille);

    pop();
  }

  void Update() {
    Collisions();
    RandomMvt();
  }

  void Collisions() {
  }

  void RandomMvt() {
  }

  PVector getPos() {
    return pos;
  }

  //INTERFACE DAMAGEABLE
  void GetDamage(float damage) {
    HP -= damage;
  }

  float GetHP() {
    return HP;
  }
}
