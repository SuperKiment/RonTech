class Projectile implements Attack {

  PVector pos, ori, baseSpeed;
  float damage = 5, speed = 0.00001, taille = 0.5,
    countdown = 0, timeOnStart, timeLimit = 2000;
  boolean mort = false;
  color couleur = color(255, 0, 0);
  Entity origine;

  Projectile(Entity e, PVector p, PVector o, PVector baseVel) {
    speed = random(speed/1.5, speed*1.5);

    origine = e;
    pos = p.copy();
    ori = o.copy();
    ori.setMag(speed);
    baseSpeed = baseVel.copy();
    timeOnStart = millis();
  }

  void Update() {
    PVector ajout = ori.copy();
    ajout.mult(mapActif.tailleCase);
    ajout.div(time.getDeltaFrames());
    ajout.add(baseSpeed);
    pos.add(ajout);

    if (millis() - timeOnStart >= timeLimit) mort = true;

    CollisionMur();
  }

  void Display() {
    push();
    fill(couleur);
    noStroke();
    rectMode(CENTER);
    ellipse(GrToSn(pos.x), GrToSn(pos.y), GrToSn(taille), GrToSn(taille));
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
      if (dist(pos.x, pos.y, m.pos.x, m.pos.y) < taille / 2 + m.taille / 2) {
        mort = true;
        mapActif.AllParticles.add(new Particles(int(damage/2), pos.copy()));
      }
    }

    for (Enemy e : mapActif.AllEnemies) {
      if (dist(pos.x, pos.y, e.pos.x, e.pos.y) < taille / 2 + e.taille / 2) {
        mort = true;
        e.GetDamage(damage);

        mapActif.AllParticles.add(new Particles(int(damage), pos.copy()));
      }
    }
  }
}
