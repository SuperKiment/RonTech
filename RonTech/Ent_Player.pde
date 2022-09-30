class Player {

  PVector pos, vel, dirCible, dir, acc, taille;
  boolean controllable = false;
  float speed = 5, rotSpeed = 0.1;
  String name = "";
  float HP = 100, stamina = 100;
  Inventaire inventaire;

  ArrayList<Module> AllModules = new ArrayList<Module>();

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

    for (Module m : AllModules) {
      m.Display();
    }

    push();
    translate(pos.x*mapActif.tailleCase, pos.y*mapActif.tailleCase);

    ellipse(0, 0, taille.x, taille.y);

    pop();
  }

  void Update() {
    Deplacement();
    RecupLoot();

    for (int i=0; i<AllModules.size(); i++) {
      Module m = AllModules.get(i);
      m.Update(pos);
    }
  }

  void Deplacement() {
    dirCible = inputControl.keyDir; 

    vel = dirCible; 
    vel.setMag(speed*time.getDeltaFrames()); 

    pos.add(vel);

    CollisionMur();
  }

  void CollisionMur() {
    for (Mur m : mapActif.AllMurs) {
      if (dist(GrToSn(pos.x), GrToSn(pos.y), GrToSn(m.pos.x), GrToSn(m.pos.y)) < taille.x/2 + m.taille/2) {      
        PVector colOri = new PVector(pos.x - m.pos.x, pos.y - m.pos.y);
        colOri.setMag(speed*time.getDeltaFrames());

        pos.add(colOri);
      }
    }
  }

  boolean IsOnPlayer(float x, float y) {
    float tailleCase = mapActif.tailleCase; 
    if (x >= pos.x * tailleCase - taille.x/2 &&
      x <= pos.x * tailleCase + taille.x/2 &&
      y >= pos.y * tailleCase - taille.y/2 &&
      y <= pos.y * tailleCase + taille.y/2) {
      return true;
    } else return false;
  }

  String Print() {
    String pr = name; 
    if (pr.equals("")) pr = "NoName"; 

    return "Ensemble " + pr + " / Position " + pos;
  }

  void RecupLoot() {

    for (int i=0; i<mapActif.AllLoot.size(); i++) {
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













class Module {

  PVector pos;
  Player player;
  float speed, taille, distance = 50, ori;
  color couleur;

  Module() {
    Constructor();
  }

  Module(Player p, float t, float o, float s, float d) {
    Constructor();
    player = p;
    taille = t;
    ori = o;
    speed = s;
    distance = d;
    pos.x = p.pos.x;
    pos.y = p.pos.y;
  }

  void Constructor() {
    player = new Player();    
    pos = player.pos;
    taille = 50;
    speed = 0.02;
    couleur = color(255, 255, 255);
    distance = 2;
  }

  void Update(PVector p) {
    pos.lerp(p, speed*time.getDeltaFrames());
  }

  void Display() {

    if (player != null) {
      push();
      stroke(0);
      strokeWeight(5);      //Ligne

      line(PosOnScr().x, PosOnScr().y, GrToSn(player.pos.x), GrToSn(player.pos.y));

      pop();
    }


    push();
    translate(GrToSn(pos.x), GrToSn(pos.y));
    rotate(-ori);
    fill(couleur);                          //Rond
    ellipse(GrToSn(distance), 0, taille, taille);
    pop();

    push();
    fill(0);
    text(taille +"  "+PosOnScr().x +" "+PosOnScr().y, PosOnScr().x, PosOnScr().y);
    pop();
  }

  PVector PosOnScr() {
    PVector posS = new PVector();
    PVector ajout = new PVector(1, 0);

    ajout = Rotate(ajout, -ori);
    ajout.setMag(distance);

    posS = pos.copy();

    posS.add(ajout);
    posS.mult(mapActif.tailleCase);
    return posS;
  }
}
