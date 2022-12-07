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

boolean isTouch(Player p, Loot l) {
  if (dist(GrToSn(p.pos.x), GrToSn(p.pos.y), 
    GrToSn(l.pos.x), GrToSn(l.pos.y)) 

    <= p.taille / 2 + l.taille / 2) {

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

float OrientationFromVector(PVector ori) {
  float x = 0;
  
  
  
  return x;
}
