class Projectile extends Entity implements Attack{

  PVector oriProj, baseSpeed;
  float damage = 5, speed = 0.00001, taille = 0.5,
    countdown = 0, timeOnStart, timeLimit = 2000;
  color couleur = color(255, 0, 0);
  Entity origine;

  Projectile(Entity e, PVector p, PVector o, PVector baseVel) {
    speed = random(speed/1.5, speed*1.5);

    origine = e;
    pos = p.copy();
    oriProj = o.copy();
    oriProj.setMag(speed);
    baseSpeed = baseVel.copy();
    timeOnStart = millis();
    isAttack = true;
  }

  void Update() {
    PVector ajout = oriProj.copy();
    ajout.mult(mapActif.tailleCase);
    ajout.div(time.getDeltaFrames());
    ajout.add(baseSpeed);
    pos.add(ajout);

    if (millis() - timeOnStart >= timeLimit) isMort = true;

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

  void CollisionMur() {

    for (Entity e : mapActif.entManager.getEntity()) {
      if (dist(pos.x, pos.y, e.getPos().x, e.getPos().y) < taille / 2 + e.getTaille() / 2 &&
        !getObjectClassName(e).equals("Player") && !getObjectClassName(e).equals("Projectile")) {
        isMort = true;
        //e.GetDamage(damage);
        mapActif.entManager.addParticles(new Particles(int(damage/2), pos.copy()));
      }
    }
  }
}
