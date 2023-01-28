class Player extends Entity implements Damageable {

  PVector dirCible;
  boolean controllable = false;
  float speed = 5, taille = 1;
  String name = "";
  float HP = 100, stamina = 100, baseHP = 100;
  Inventaire inventaire;

  Player() {
    Constructor();
  }

  Player(float x, float y) {
    Constructor();
    pos = new PVector(x, y);
  }

  void Constructor() {
    pos = new PVector();
    vel = new PVector();
    dirCible = new PVector();
    inventaire = new Inventaire();
    moduleManager = new ModuleManager(this);
  }

  void Display() {

    console.add(moduleManager.AllModules.size());
    
    if (mapActif != null) {

      push();
      translate(pos.x * mapActif.tailleCase, pos.y * mapActif.tailleCase);

      ellipse(0, 0, GrToSn(taille), GrToSn(taille));

      pop();
    }
  }

  void Update() {
    CollisionEntity(this, taille, pos);
    Deplacement();
    RecupLoot();

    moduleManager.Update();

    if (inputControl.leftClickUtiliser) LeftClick();
  }

  void Deplacement() {
    dirCible = inputControl.keyDir;

    vel = dirCible;
    vel.setMag(speed * mapActif.timeThreadUpdate/timeFactor);

    pos.add(vel);
  }
  

  String Print() {
    String pr = name;
    if (pr.equals("")) pr = "NoName";

    return "Ensemble " + pr + " / Position " + pos;
  }

  void RecupLoot() {

    for (int i = 0; i < mapActif.entManager.getEntity().size(); i++) {
      if (getObjectClassName(mapActif.entManager.getEntity(i)).equals("Loot")) {

        Entity l = mapActif.entManager.getEntity(i);

        if (isTouch(this, l)) {
          inventaire.add(l);
          mapActif.entManager.getEntity().remove(i);
        }
      }
    }
  }

  void LeftClick() {
    moduleManager.Utiliser();
  }


  //INTERFACE DAMAGEABLE
  void GetDamage(float damage) {
    HP -= damage;

    camera.Shake(5);
  }

  void DisplayHealthBar() {
  }
}












class Inventaire {

  Entity[][] grille;

  Inventaire() {
    Constructor();
  }

  void Constructor() {
    grille = new Loot[5][5];
  }

  void add(Entity l) {
    boolean added = false;

    for (int x = 0; x < grille.length; x++) {
      for (int y = 0; y < grille[0].length; y++) {
        if (grille[x][y] == null) {
          grille[x][y] = l;
          added = true;
          println("ajout a l'inventaire en " + x, y + " de " + getObjectClassName(l));
          break;
        }
        if (added) break;
      }
      if (added) break;
    }

    if (!added) {
      println("Pas de place dans l'inventaire");
      mapActif.entManager.addEntity(l);
    }
  }
}















class Loot extends Entity {

  String nom;
  PVector pos, posC;
  float speed, taille;
  color couleur;
  boolean isDisplay = false;


  Loot() {
    Constructor();
  }

  Loot(float x, float y) {
    Constructor();
    setPos(x, y);
  }

  Loot(float x, float y, String n) {
    Constructor();
    setPos(x, y);
    nom = n;
  }

  void Constructor() {
    nom = "NoName";
    pos = new PVector(2, 5);
    posC = new PVector(2, 5);
    speed = 5;
    couleur = color(random(20, 255), random(20, 255), random(20, 255));
    taille = 0.5;
  }

  void Update() {
    //Lerp vers la position voulue
    pos.lerp(posC, speed * time.getDeltaFrames());
  }

  //Display sur la map avec le POS;
  void Display() {
    push();
    fill(couleur);
    translate(GrToSn(pos.x), GrToSn(pos.y));

    ellipse(0, 0, GrToSn(taille), GrToSn(taille));

    pop();
  }

  //Display dans l'inventaire donc sur l'écran
  void DisplayOnScreen(float x, float y) {
    push();

    fill(couleur);
    translate(x, y);
    ellipse(0, 0, GrToSn(taille) * 5, GrToSn(taille) * 5);

    pop();
  }

  void setPos(float x, float y) {
    pos = new PVector(x, y);
    posC = new PVector(x, y);
  }

  //INTERFACE ENTITY

  PVector getPos() {
    return pos;
  }

  PVector getVel() {
    return new PVector();
  }

  boolean isMort() {
    return false;
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
}
