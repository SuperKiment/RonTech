class Projectile implements Attack, Entity {

  PVector pos, ori, baseSpeed;
  float damage = 5, speed = 0.00001, taille = 0.5,
    countdown = 0, timeOnStart, timeLimit = 2000;
  boolean mort = false, isDisplay = false;
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

  //INTERFACE ENTITY

  PVector getPos() {
    return pos;
  }

  boolean isMort() {
    return mort;
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

    return json;
  }

  float getTaille() {
    return taille;
  }

  void CollisionMur() {

    for (Entity e : mapActif.entManager.getEntity()) {
      if (dist(pos.x, pos.y, e.getPos().x, e.getPos().y) < taille / 2 + e.getTaille() / 2 &&
        !getObjectClassName(e).equals("Player") && !getObjectClassName(e).equals("Projectile")) {
        mort = true;
        //e.GetDamage(damage);
        mapActif.entManager.addParticles(new Particles(int(damage/2), pos.copy()));
      }
    }
  }
}
