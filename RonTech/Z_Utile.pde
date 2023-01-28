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

  return pos.copy();
}

PVector MousePosScreenGr() {
  return SnToGr(MousePosScreen());
}

static String getObjectClassName(Object o) {
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


void CollisionEntity(Entity me, float taille, PVector pos) {
  if (!getObjectClassName(me).equals("EntityOnMouse")) {
    try {
      for (Entity e : mapActif.entManager.getEntity()) {
        if (!getObjectClassName(e).equals("EntityOnMouse")) {

          float d = dist(pos.x, pos.y, e.getPos().x, e.getPos().y);

          if (e != me && d < (taille + e.getTaille()) / 2) {
            ModuleSocle m = new ModuleSocle();
            if (e.isModule) m = (ModuleSocle)e;

            if (m.liaison == null || m.liaison != me) {

              PVector colOri = new PVector(pos.x - e.getPos().x, pos.y - e.getPos().y);
              float mag = -(d - (taille + e.getTaille())/2);

              //console.add("Collision : "+getObjectClassName(me)+" / "+getObjectClassName(e)+" / pos : "+e.getPos());

              colOri.setMag(mag);

              pos.add(colOri);
            }
          }
        }
      }
    }
    catch (Exception e) {
      println("Collision fail");
    }
  }
}
