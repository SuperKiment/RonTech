class Projectile implements Attack {

  PVector pos, ori;
  float damage = 50, speed = 1, taille = 10, 
    countdown = 0, timeOnStart, timeLimit = 1000;
  boolean mort = false;
  color couleur = color(255, 0, 0);
  Entity origine;

  Projectile(Entity e, PVector p, PVector o) {
    origine = e;
    pos = p;
    ori = o;
    ori.setMag(speed);
    timeOnStart = millis();
  }

  void Update() {
    pos.add(ori);
    countdown = millis() - timeOnStart;

    if (countdown >= timeLimit) mort = true;
  }

  void Display() {
    push();
    fill(couleur);
    noStroke();
    rectMode(CENTER);
    ellipse(pos.x, pos.y, taille, taille);
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
}
