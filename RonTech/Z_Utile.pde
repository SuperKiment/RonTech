float GrToSn(float x) {
  return x * mapActif.tailleCase;
}

float SnToGr(float x) {
  return x / mapActif.tailleCase;
}

PVector GrToSn(PVector v) {
  return new PVector(v.x * mapActif.tailleCase, v.y * mapActif.tailleCase);
}

PVector SnToGr(PVector v) {
  return new PVector(v.x / mapActif.tailleCase, v.y / mapActif.tailleCase);
}

PVector Rotate(PVector v, float a) {
  PVector r = new PVector();

  r.x = v.x * cos(a) - v.y * sin(a);
  r.y = v.x * sin(a) + v.y * cos(a);

  return r;
}

boolean isTouch(Player p, Entity l) {
  if (dist(  p.pos.x, p.pos.y, l.getPos().x, l.getPos().y  )
    <= p.taille / 2 + l.getTaille() / 2) {

    return true;
  }
  return false;
}

PVector MousePosScreen() {
  PVector pos = new PVector(mouseX, mouseY);

  pos.sub(camera.translate);

  return pos;
}

PVector MousePosScreenGr() {
  return SnToGr(MousePosScreen());
}

String getObjectClassName(Object o) {
  return split(o.getClass().getName(), '$')[1];
}

boolean IsOnEntity(Entity e, float x, float y) {
  PVector dist = e.getPos().copy();
  dist.sub(MousePosScreenGr());

  /*
  if (x >= e.getPos().x * tailleCase - e.getTaille() / 2 &&
   x <= e.getPos().x * tailleCase + e.getTaille() / 2 &&
   y >= e.getPos().y * tailleCase - e.getTaille() / 2 &&
   y <= e.getPos().y * tailleCase + e.getTaille() / 2) {
   
   return true;
   } else return false;
   */

  if (dist.mag() < e.getTaille()/2) return true;
  return false;
}
