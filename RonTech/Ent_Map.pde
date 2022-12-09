Map mapActif;

class Map {

  color GroundGrille[][];

  ArrayList<Player> AllPlayers;
  ArrayList<Solide> AllSolides;
  ArrayList<Loot> AllLoot;
  ArrayList<Attack> AllAttacks;
  ArrayList<Entity> AllEntities;
  ArrayList<Enemy> AllEnemies;
  ArrayList<Particles> AllParticles;
  int tailleCase = 50;

  ThreadUpdate threadUpdate;
  int timeThreadUpdate = 1;


  MapLoader mapLoader;


  Map() {
    println("Map Creation :");

    mapLoader = new MapLoader();
    mapLoader.LoadMap("map1.png");

    AllPlayers = new ArrayList<Player>();
    AllSolides = new ArrayList<Solide>();
    AllLoot = new ArrayList<Loot>();
    AllAttacks = new ArrayList<Attack>();
    AllEntities = new ArrayList<Entity>();
    AllEnemies = new ArrayList<Enemy>();
    AllParticles = new ArrayList<Particles>();

    int xP = 20, yP = 20;
    Player player = new Player(xP, yP);
    player.controllable = true;
    player.name = "Player0";
    AllPlayers.add(player);

    println("Map ajout d'un player en", xP, yP+ ", controllable :", player.controllable);

    threadUpdate = new ThreadUpdate();
    threadUpdate.start();


    println("Map Thread lance");
  }

  void Display() {
    try {

      DisplayGrille(AllPlayers.get(0));


      for (Solide m : AllSolides) {
        if (m.isDisplay) {
          m.Display();
        }
      }

      for (Player p : AllPlayers) {
        if (p.isDisplay) {
          p.Display();
        }
      }

      for (Enemy e : AllEnemies) {
        if (e.isDisplay) {
          e.Display();
        }
      }

      for (Loot l : AllLoot) {
        if (l.isDisplay) {
          if (l.isDisplay) {
            l.Display();
          }
        }
      }

      try {
        for (Attack a : AllAttacks) {
          a.Display();
        }
      }
      catch (Exception e) {
      }

      for (Entity e : AllEntities) {
        push();
        fill(0, 0, 0, 0);
        stroke(255, 0, 0);
        ellipse(e.getPos().x, e.getPos().y, 50, 50);
        pop();
      }

      try {
        for (Particles p : AllParticles) {
          p.Display();
        }
      }
      catch(Exception e) {
        println("cassé");
      }
    }
    catch (Exception e) {
    }
  }




  void Update() {

    for (Loot l : AllLoot) {
      l.Update();
    }

    for (Solide s : AllSolides) {
      s.Update();
    }

    try {
      for (int i=0; i<AllAttacks.size(); i++) {
        Attack a = AllAttacks.get(i);
        a.Update();
        if (a.isMort()) AllAttacks.remove(i);
      }
    }
    catch(Exception e) {
      println("FUCK");
      AllAttacks.clear();
    }

    for (int i=0; i<AllEnemies.size(); i++) {
      Enemy e = AllEnemies.get(i);
      e.Update();
      if (e.isMort) AllEnemies.remove(i);
    }
    
    for (Player p : AllPlayers) {
      p.Update();

      if (inputControl.leftClickUtiliser) {
        p.LeftClick();
      }
    }
  }




  void UpdateDisplay() {
    if (camera != null) {
      for (Loot l : AllLoot) {
        if (camera.isOnScreen(l, AllPlayers.get(0))) {
          l.isDisplay = true;
        } else l.isDisplay = false;
      }

      for (Solide m : AllSolides) {
        if (camera.isOnScreen(m, AllPlayers.get(0))) {
          m.isDisplay = true;
        } else m.isDisplay = false;
      }

      for (Player p : AllPlayers) {
        if (camera.isOnScreen(p, AllPlayers.get(0))) {
          p.isDisplay = true;
        } else p.isDisplay = false;
      }
    }
  }


  void UpdateData() {
    AllEntities.clear();

    for (Loot l : AllLoot) {
      AllEntities.add(l);
    }
    for (Solide m : AllSolides) {
      AllEntities.add(m);
    }
    for (Player p : AllPlayers) {
      AllEntities.add(p);
    }
  }


  class ThreadUpdate extends Thread {

    void run() {
      while (true) {
        if (gameManager.isPlay()) {
          Update();
          UpdateDisplay();
        }
        delay(timeThreadUpdate);
      }
    }
  }
  

  void DisplayGrille(Player p) {
    if (GroundGrille != null) {
      for (int x=int(p.pos.x-camera.ground_rd/2); x<p.pos.x+camera.ground_rd/2; x++) {
        for (int y=int(p.pos.y-camera.ground_rd/2); y<p.pos.y+camera.ground_rd/2; y++) {

          if (x>=0 && x<GroundGrille.length &&
            y>=0 && y<GroundGrille[0].length) {

            push();
            fill(GroundGrille[x][y]);
            noStroke();
            rect(x*tailleCase, y*tailleCase, tailleCase, tailleCase);
            pop();
          }
        }
      }
    }
  }

  class MapLoader {
    MapLoader() {
    }

    PImage mapImage;
    String basePath = "Map/";

    void LoadMap(String path) {
      mapImage = loadImage(basePath + path);
      GroundGrille = new color[mapImage.width][mapImage.height];

      println("Map Loaded : " + mapImage.width, "/", mapImage.height);

      for (int x=0; x<GroundGrille.length; x++) {
        for (int y=0; y<GroundGrille[0].length; y++) {
          GroundGrille[x][y] = mapImage.get(x, y);
        }
      }
    }
  }

  void Zoom(char k) {
    if (k == '+') tailleCase *= 1.2;
    else tailleCase /= 1.2;
    if (tailleCase <= 6) tailleCase = 6;
    if (tailleCase >= 105) tailleCase = 105;
    
    println("Map tailleCase : "+tailleCase);
  }


  void addParticles(int puissance, PVector p) {
    AllParticles.add(new Particles(puissance, p));
  }

  void addPlayer() {
  }
}
