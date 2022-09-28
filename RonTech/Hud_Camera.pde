Camera camera;

class Camera {
  Player focus;
  PVector cible, ecran, translate;
  boolean trackCible = true;

  float cameraSpeed = 0.1;

  Camera() {
    focus = mapActif.AllPlayers.get(0);

    cible = new PVector(-focus.pos.x * mapActif.tailleCase + width/2, -focus.pos.y * mapActif.tailleCase+height/2);

    translate = cible;
  }

  void Update() {
    cible = new PVector(-focus.pos.x * mapActif.tailleCase + width/2, -focus.pos.y * mapActif.tailleCase+height/2);

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
}
