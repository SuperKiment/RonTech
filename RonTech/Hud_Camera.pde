Camera camera;

class Camera {
  Player focus;
  PVector cible, ecran, translate;
  boolean trackCible = true;
  float ground_rd = 5;
  float entities_rd = 5;

  float cameraSpeed = 0.1;

  Camera() {
    ground_rd = gameManager.optionsManager.ground_rd;
    entities_rd = gameManager.optionsManager.entities_rd;
    
    focus = mapActif.AllPlayers.get(0);

    cible = new PVector( -focus.pos.x * mapActif.tailleCase + width / 2, -focus.pos.y * mapActif.tailleCase + height / 2);

    translate = cible;
  }

  void Update() {    
    cible = new PVector( -focus.pos.x * mapActif.tailleCase + width / 2, -focus.pos.y * mapActif.tailleCase + height / 2);

    translate.lerp(cible, cameraSpeed);
  }

  String Print() {
    return "Camera Focus : " + focus.Print();
  }

  void Translate() {
    translate(translate.x, translate.y);
  }

  void SwitchFocus(Player e) {
    focus = e;
  }



  boolean isOnScreen(Entity e, Player p) {
    PVector posE, posP;

    posE = e.getPos().copy();
    posP = p.getPos().copy();

    posE.sub(posP);

    float dist = posE.mag();

    if (dist <= entities_rd*0.75) {
      return true;
    } else return false;
  }
}
