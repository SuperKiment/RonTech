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




    threadUpdate = new ThreadUpdate();
    threadUpdate.start();


    println("Map Thread lance");
  }

  void Display() {
    try {

      DisplayGrille(camera.focus);

      //Try pr ttes les entités
      try {
        for (Entity e : entManager.getEntity()) {
          if (e.isDisplay()) {
            e.Display();
          }
        }
      }
      catch (Exception e) {
      }

      //Try pr les particles
      try {
        for (Particles p : entManager.getParticles()) {
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

    if (!getObjectClassName(entManager.getPlayer()).equals("Player")) {
      for (int i=0; i<entManager.getEntity().size(); i++) {
        Entity e = entManager.getEntity(i);
        if (getObjectClassName(e).equals("Player")) {
          Player p = (Player)e;
          entManager.getEntity().remove(i);
          entManager.getEntity().add(0, p);
        }
      }
    }

    try {
      for (int i=0; i<entManager.getEntity().size(); i++) {
        Entity e = entManager.getEntity().get(i);

        e.Update();

        if (e.isMort()) entManager.getEntity().remove(i);
      }
    }
    catch(Exception e) {
      println("FUCK");
    }
  }



  //Update le isDisplay de chaque entité
  void UpdateDisplay() {
    if (camera != null) {

      for (Entity e : entManager.getEntity()) {
        if (camera.isOnScreen(e)) {
          e.setIsDisplay(true);
        } else e.setIsDisplay(false);
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

        entManager.addEntity(s);
      }
    }

    void SaveEntities() {
      JSONArray JSONAllEntities = new JSONArray();

      for (int i=0; i<entManager.getEntity().size(); i++) {
        Entity s = entManager.getEntity().get(i);
        JSONObject json = s.getJSON();

        JSONAllEntities.setJSONObject(i, json);
      }

      saveJSONArray(JSONAllEntities, basePath + "entities.json");
      println("Map Saved", mapName, "at", basePath, ":");
      println(JSONAllEntities);
    }
  }

  //=======================================================================================

  class EntityManager {

    ArrayList<Entity> AllEntities;
    ArrayList<Particles> AllParticles;

    EntityManager() {
      AllEntities = new ArrayList<Entity>();
      AllParticles = new ArrayList<Particles>();
    }

    //Entity

    ArrayList<Entity> getEntity() {
      return AllEntities;
    }

    Entity getEntity(int no) {
      return AllEntities.get(no);
    }

    void addEntity(Entity e) {
      getEntity().add(e);
    }
    void addEntity(int index, Entity e) {
      getEntity().add(index, e);
    }

    //Particles

    ArrayList<Particles> getParticles() {
      return AllParticles;
    }

    Particles getParticles(int no) {
      return AllParticles.get(no);
    }

    void addParticles(Particles p) {
      getParticles().add(p);
    }

    //Autres

    Entity getPlayer() {
      return getEntity(0);
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
    entManager.addParticles(new Particles(puissance, p));
  }

  void addPlayer() {
  }
}








void SetupMap(String nameMap) {
  mapActif = new Map(nameMap);

  int xP = 20, yP = 20;
  Player player = new Player(xP, yP);
  player.controllable = true;
  player.name = "Player0";
  mapActif.entManager.addEntity(0, player);

  println("Map ajout d'un player en", xP, yP+ ", controllable :", player.controllable);
}
