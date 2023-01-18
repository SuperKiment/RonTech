Camera camera;

class Camera {
  Entity focus;
  PVector cible, ecran, translate;
  boolean trackCible = true;
  float ground_rd = 5;
  float entities_rd = 5;

  float cameraSpeed = 0.1;

  float shakingX = 0, shakingY = 0;

  Camera() {
    ground_rd = gameManager.optionsManager.ground_rd;
    entities_rd = gameManager.optionsManager.entities_rd;

    focus = mapActif.entManager.getPlayer();

    cible = new PVector( -focus.getPos().x * mapActif.tailleCase + width / 2, -focus.getPos().y * mapActif.tailleCase + height / 2);

    translate = cible;
  }

  void Update() {
    cible = new PVector( -focus.getPos().x * mapActif.tailleCase + width / 2, -focus.getPos().y * mapActif.tailleCase + height / 2);

    translate.lerp(cible, cameraSpeed);

    translate.x += random(-shakingX, shakingX);
    translate.y += random(-shakingY, shakingY);

    shakingX = lerp(shakingX, 0, 0.2);
    shakingY = lerp(shakingY, 0, 0.2);
  }

  String Print() {
    return "Camera Focus : " + getObjectClassName(focus) + " / pos : " + focus.getPos();
  }

  void Translate() {
    translate(translate.x, translate.y);
  }

  void SwitchFocus(Entity e) {
    focus = e;
  }



  boolean isOnScreen(Entity e, Entity p) {
    PVector posE, posP;

    posE = e.getPos().copy();
    posP = p.getPos().copy();

    posE.sub(posP);

    float dist = posE.mag();

    if (dist <= entities_rd*0.75) {
      return true;
    }
    return false;
  }

  void Shake(float shake) {
    shakingX = random(shake/3, shake*2);
    shakingY = random(shake/3, shake*2);
  }
}
