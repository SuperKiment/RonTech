class Player {

  PVector pos, vel, dirCible, dir, acc, taille;
  boolean controllable = false;
  float speed = 5, rotSpeed = 0.1;
  String name = "";
  float HP = 100, stamina = 100;
  Inventaire inventaire;

  ArrayList<ModuleTest> AllModules = new ArrayList<ModuleTest>();

  ThreadUpdate threadUpdate = new ThreadUpdate();
  ThreadLateStart threadLateStart = new ThreadLateStart();

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

    threadUpdate.start();
    //threadLateStart.start();
  }

  void Display() {

    for (ModuleTest m : AllModules) {
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
      ModuleTest m = AllModules.get(i);
      m.Update(pos);
    }
  }

  void Deplacement() {
    dirCible = inputControl.keyDir; 

    vel = dirCible; 
    vel.setMag(speed * time.getDeltaFrames()); 

    pos.add(vel);

    CollisionMur();
  }

  void CollisionMur() {
    for (Mur m : mapActif.AllMurs) {
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

  class ThreadUpdate extends Thread {
    void run() {
      Update();
    }
  }

  class ThreadLateStart extends Thread {

    void run() {
      delay(1000);
      threadUpdate.run();
    }
  }
}
