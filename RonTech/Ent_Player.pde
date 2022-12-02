class Player implements Entity, Damageable {

  PVector pos, vel, dirCible, dir, acc, taille;
  boolean controllable = false;
  float speed = 5, rotSpeed = 0.1;
  String name = "";
  float HP = 100, stamina = 100;
  Inventaire inventaire;

  ArrayList<IModule> AllModules = new ArrayList<IModule>();
  int maxModules = 8;

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
    dir = new PVector();
    acc = new PVector();
    taille = new PVector(50, 50);
    inventaire = new Inventaire();
  }

  void Display() {

    for (IModule m : AllModules) {
      m.Display();
    }

    push();
    translate(pos.x * mapActif.tailleCase, pos.y * mapActif.tailleCase);

    ellipse(0, 0, taille.x, taille.y);

    pop();
  }

  void Update() {
    Deplacement();
    RecupLoot();

    for (int i = 0; i < AllModules.size(); i++) {
      IModule m = AllModules.get(i);
      m.Update(this);

      if (inputControl.space) {
      }
    }
  }

  void Deplacement() {
    dirCible = inputControl.keyDir;

    vel = dirCible;
    vel.setMag(speed * mapActif.timeThreadUpdate/timeFactor);

    pos.add(vel);

    CollisionMur();
  }

  void CollisionMur() {
    for (Solide m : mapActif.AllSolides) {
      if (dist(GrToSn(pos.x), GrToSn(pos.y), GrToSn(m.pos.x), GrToSn(m.pos.y)) < taille.x / 2 + m.taille / 2) {
        PVector colOri = new PVector(pos.x - m.pos.x, pos.y - m.pos.y);
        colOri.setMag(speed * time.getDeltaFrames());

        pos.add(colOri);
      }
    }
  }

  boolean IsOnPlayer(float x, float y) {
    float tailleCase = mapActif.tailleCase;
    if (x >= pos.x * tailleCase - taille.x / 2 &&
      x <= pos.x * tailleCase + taille.x / 2 &&
      y >= pos.y * tailleCase - taille.y / 2 &&
      y <= pos.y * tailleCase + taille.y / 2) {
      return true;
    } else return false;
  }

  String Print() {
    String pr = name;
    if (pr.equals("")) pr = "NoName";

    return "Ensemble " + pr + " / Position " + pos;
  }

  void RecupLoot() {

    for (int i = 0; i < mapActif.AllLoot.size(); i++) {
      Loot l = mapActif.AllLoot.get(i);

      if (isTouch(this, l)) {
        inventaire.add(l);
        mapActif.AllLoot.remove(i);
      }
    }
  }

  void LeftClick() {
    for (IModule m : AllModules) {
      m.Utiliser();
    }
  }

  void addModule(IModule m, OnModule om) {
    if (AllModules.size() < maxModules) {
      m.setOri((AllModules.size()-1) * (TWO_PI/maxModules));
      om.setModule(m, this);
      m.setOnModule(om);
      AllModules.add(m);
    } else {
      println("Pla Impossible d'ajouter le module");
    }
  }

  //INTERFACE ENTITY
  boolean isDisplay = false;
  PVector getPos() {
    return pos;
  }

  //INTERFACE DAMAGEABLE
  void GetDamage(float damage) {
    HP -= damage;
  }

  float GetHP() {
    return HP;
  }
}















class Inventaire {

  Loot[][] grille;

  Inventaire() {
    Constructor();
  }

  void Constructor() {
    grille = new Loot[5][5];
  }

  void add(Loot l) {
    boolean added = false;

    for (int x = 0; x < grille.length; x++) {
      for (int y = 0; y < grille[0].length; y++) {
        if (grille[x][y] == null) {
          grille[x][y] = l;
          added = true;
          println("ajout a l'inventaire en " + x, y + " de " + l.nom);
          break;
        }
        if (added) break;
      }
      if (added) break;
    }

    if (!added) {
      println("Pas de place dans l'inventaire");
      mapActif.AllLoot.add(l);
    }
  }
}















class Loot implements Entity {

  String nom;
  PVector pos, posC;
  float speed, taille;
  color couleur;


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
    taille = 10;
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

    ellipse(0, 0, taille, taille);

    pop();
  }

  //Display dans l'inventaire donc sur l'écran
  void DisplayOnScreen(float x, float y) {
    push();

    fill(couleur);
    translate(x - taille, y - taille);
    ellipse(0, 0, taille * 5, taille * 5);

    pop();
  }

  void setPos(float x, float y) {
    pos = new PVector(x, y);
    posC = new PVector(x, y);
  }

  //INTERFACE ENTITY
  boolean isDisplay = false;
  PVector getPos() {
    return pos;
  }
}
