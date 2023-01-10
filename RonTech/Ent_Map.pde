Map mapActif;

class Map {

  color GroundGrille[][];
  
  int tailleCase = 50;

  String mapName = "";

  ThreadUpdate threadUpdate;
  int timeThreadUpdate = 1;

  EntityManager entManager;

  MapLoader mapLoader;


  Map() {
    mapName = "map1";
    Constructor();
  }

  Map(String n) {
    mapName = n;
    Constructor();
  }

  void Constructor() {
    println();
    println("Map Creation :");

    entManager = new EntityManager();

    mapLoader = new MapLoader();
    mapLoader.LoadMap();
    mapLoader.LoadEntities();

    int xP = 20, yP = 20;
    Player player = new Player(xP, yP);
    player.controllable = true;
    player.name = "Player0";
    entManager.add(player);

    println("Map ajout d'un player en", xP, yP+ ", controllable :", player.controllable);

    threadUpdate = new ThreadUpdate();
    threadUpdate.start();


    println("Map Thread lance");
  }

  void Display() {
    try {

      DisplayGrille(entManager.get("Player").get(0));


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


  void DisplayGrille(Entity p) {
    if (GroundGrille != null) {
      for (int x=int(p.getPos().x-camera.ground_rd/2); x<p.getPos().x+camera.ground_rd/2; x++) {
        for (int y=int(p.getPos().y-camera.ground_rd/2); y<p.getPos().y+camera.ground_rd/2; y++) {

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

  //=======================================================================================

  class MapLoader {

    PImage mapImage;
    String basePath = "Map/";

    MapLoader() {
      basePath += mapName+"/";
    }

    void LoadMap() {
      mapImage = loadImage(basePath + "fond.png");
      GroundGrille = new color[mapImage.width][mapImage.height];

      println("Map Loaded : " + mapImage.width, "/", mapImage.height + ", name : " + mapName);

      for (int x=0; x<GroundGrille.length; x++) {
        for (int y=0; y<GroundGrille[0].length; y++) {
          GroundGrille[x][y] = mapImage.get(x, y);
        }
      }
    }

    void LoadEntities() {
      JSONObject JSONAllEntities = loadJSONObject(basePath+"entities.json");
      JSONArray JSONAllSolides = JSONAllEntities.getJSONArray("Solide");

      for (int i=0; i<JSONAllSolides.size(); i++) {
        Solide s = new Solide();
        JSONObject solide = JSONAllSolides.getJSONObject(i);
        s.pos = new PVector(solide.getFloat("pos.x"), solide.getFloat("pos.y"));
        s.taille = solide.getFloat("taille");
        s.couleur = solide.getInt("couleur");

        AllSolides.add(s);
      }
    }

    void SaveEntities() {
      JSONObject JSONAllEntities = new JSONObject();
      JSONArray JSONAllSolides = new JSONArray();

      for (int i=0; i<AllSolides.size(); i++) {
        Solide s = AllSolides.get(i);
        JSONObject json = new JSONObject();

        json.setFloat("pos.x", s.pos.x);
        json.setFloat("pos.y", s.pos.y);
        json.setFloat("taille", s.taille);
        json.setInt("couleur", s.couleur);

        JSONAllSolides.setJSONObject(i, json);
      }

      JSONAllEntities.setJSONArray("Solide", JSONAllSolides);
      saveJSONObject(JSONAllEntities, basePath + "entities.json");
      println("Map Saved", mapName, "at", basePath, ":");
      println(JSONAllEntities);
    }
  }

  //=======================================================================================

  private class EntityManager {

    private HashMap<String, ArrayList> AllEntities;

    EntityManager() {
      AllEntities = new HashMap<String, ArrayList>();

      AllEntities.put("Solide", new ArrayList<Solide>());
      AllEntities.put("Player", new ArrayList<Player>());
      AllEntities.put("Loot", new ArrayList<Loot>());
      AllEntities.put("Attack", new ArrayList<Attack>());
      AllEntities.put("Enemy", new ArrayList<Enemy>());
      AllEntities.put("Particles", new ArrayList<Particles>());
    }

    ArrayList get(String array) {
      return AllEntities.get(array);
    }

    void add(Object o) {
      AllEntities.get(getObjectClassName(o)).add(o);
    }
  }

  //=======================================================================================

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
