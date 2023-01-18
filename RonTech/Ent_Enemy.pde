class Enemy implements Entity, Damageable {
  float HP, baseHP = 200, taille;
  PVector pos, posC;
  boolean isDisplay = true, isMort = false;

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

  //INTERFACE ENTITY

  PVector getPos() {
    return pos;
  }

  boolean isMort() {
    return isMort;
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
    json.setFloat("HP", HP);
    json.setFloat("baseHP", baseHP);

    return json;
  }

  float getTaille() {
    return taille;
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
