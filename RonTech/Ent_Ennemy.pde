class Enemy implements Entity, Damageable {
  float HP = 200, taille, tempsDepl;
  PVector pos, posC;
  boolean isDisplay = true;
  //la aussi

  Enemy() {
    Constructor();
  }

  Enemy(float x, float y) {
    Constructor();
    pos = new PVector(x, y);
  }

  void Constructor() {
    pos = new PVector();
    taille = mapActif.tailleCase*5;
  }

  void Display() {
    push();
    translate(pos.x * mapActif.tailleCase, pos.y * mapActif.tailleCase);
    fill(255, 0, 0);
    ellipse(0, 0, taille, taille);

    DisplayHealthBar();
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

  void DisplayHealthBar() {
    push();
    rectMode(CENTER);
    
    float tailleX = HP*1.5;
    float y = taille*0.75;
    
    translate(0, -y);
    
    fill(0);
    rect(0, 0, tailleX, 30);

    fill(255, 0, 0);
    rect(0, 0, tailleX-3, 30-3);

    /*et toc c tout cassé mdr
     ici aussi*/
    pop();
  }
}
