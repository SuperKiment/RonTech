class Enemy implements Entity, Damageable {
  float HP, baseHP = 200, taille, tempsDepl;
  PVector pos, posC;
  boolean isDisplay = true, isMort = false;
  //la aussi

  Enemy() {
    Constructor();
  }

  Enemy(float x, float y, float ta) {
    Constructor();
    pos = new PVector(x, y);
    taille = ta;
  }

  void Constructor() {
    pos = new PVector();
    taille = mapActif.tailleCase*5;
    HP = baseHP;
  }

  void Display() {
    push();
    translate(pos.x * mapActif.tailleCase, pos.y * mapActif.tailleCase);
    fill(255, 0, 0);
    ellipse(0, 0, GrToSn(taille), GrToSn(taille));

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
    if (HP <= 0) {
      isMort = true;
      mapActif.addParticles(int(baseHP), pos);
    }
    if (HP > baseHP) HP = baseHP;
  }

  float GetHP() {
    return HP;
  }

  void DisplayHealthBar() {
    if (HP < baseHP) {
      push();
      rectMode(CENTER);

      float tailleXbase = baseHP*1.5;
      float tailleX = HP*1.5;
      float tailleY = taille/2;
      
      if (tailleY > mapActif.tailleCase/2) tailleY = mapActif.tailleCase/2;
      else if (tailleY < mapActif.tailleCase/5) tailleY = mapActif.tailleCase/5;
      
      if (tailleY <= 5) tailleY = 5;
      
      float y = GrToSn(taille)*0.75;
      
      translate(0, -y);

      fill(0);
      rect(0, 0, tailleXbase, tailleY);

      fill(255, 0, 0);
      rect(0, 0, tailleX-3, tailleY);

      /*et toc c tout cassé mdr
       ici aussi*/
      pop();
    }
  }
}
