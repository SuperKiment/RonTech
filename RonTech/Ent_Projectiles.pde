class Projectile implements Attack {

  PVector pos, ori, baseSpeed;
  float damage = 50, speed = 4, taille = 10, 
    countdown = 0, timeOnStart, timeLimit = 2000;
  boolean mort = false;
  color couleur = color(255, 0, 0);
  Entity origine;

  Projectile(Entity e, PVector p, PVector o, PVector b) {
    speed = random(speed/1.5, speed*1.5);

    origine = e;
    pos = p.copy();
    ori = o.copy();
    ori.setMag(speed);
    ori.add(b);
    timeOnStart = millis();
  }

  void Update() {
    pos.add(SnToGr(ori));

    if (millis() - timeOnStart >= timeLimit) mort = true;

    CollisionMur();
  }

  void Display() {
    push();
    fill(couleur);
    noStroke();
    rectMode(CENTER);
    ellipse(GrToSn(pos.x), GrToSn(pos.y), taille, taille);
    pop();
  }

  PVector getPos() {
    return pos;
  }

  float getTaille() {
    return taille;
  }

  boolean isMort() {
    return mort;
  }

  void CollisionMur() {
    for (Solide m : mapActif.AllSolides) {
      if (dist(GrToSn(pos.x), GrToSn(pos.y), GrToSn(m.pos.x), GrToSn(m.pos.y)) < taille / 2 + m.taille / 2) {
        mort = true;
      }
    }
    
    for (Enemy e : mapActif.AllEnemies) {
      if (dist(GrToSn(pos.x), GrToSn(pos.y), GrToSn(e.pos.x), GrToSn(e.pos.y)) < taille / 2 + e.taille / 2) {
        mort = true;
        println("touché");
      }
    }
  }
}
