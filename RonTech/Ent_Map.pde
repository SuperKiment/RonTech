Map mapActif;

class Map {

  color GroundGrille[][];

  int tailleCase = 50;

  String mapName = "";

  ThreadUpdate threadUpdate;
  ThreadUpdateIsDisplay threadUpdateIsDisplay;
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

    threadUpdateIsDisplay = new ThreadUpdateIsDisplay();
    threadUpdateIsDisplay.start();


    println("Map Thread lance");
  }

  void Display() {
    try {

      DisplayGrille(camera.focus);

      boolean okEnt = false;
      while (!okEnt) {
        //Try pr ttes les entités
        try {
          for (Entity e : entManager.getEntityDisplay()) {
            e.Display();
          }
          okEnt = true;
        }
        catch (Exception e) {
          //println("Erreur sur Display Entités");
          //println(e);
        }
      }

      //Try pr les particles
      try {
        for (Particles p : entManager.getParticles()) {
          p.Display();
        }
      }
      catch(Exception e) {
        println("Erreur sur Display Particules");
      }
    }
    catch (Exception e) {
      println("Erreur sur Display Map");
      println(e);
    }
  }




  void Update() {

    for (int i=0; i<entManager.getEntity().size(); i++) {
      Entity e = entManager.getEntity(i);
      try {

        e.Update();

        if (e.isMort()) {
          //println("Removed : " + e.toString(e));
          entManager.getEntity().remove(i);
        }
      }
      catch(Exception ex) {
        println("FUCK sur " + getObjectClassName(e) + " en " + e.getPos());
        println(ex);
      }
    }
  }


  class ThreadUpdate extends Thread {

    void run() {
      while (true) {
        if (gameManager.isPlay()) {
          Update();
        }
        delay(timeThreadUpdate);
      }
    }
  }

  //Update le isDisplay de chaque entité
  void UpdateDisplay() {
    try {
      if (camera != null) {

        for (Entity e : entManager.getEntity()) {
          if (camera.isOnScreen(e)) {
            e.setIsDisplay(true);
          } else e.setIsDisplay(false);
        }
      }
    }
    catch (Exception e) {
    }
  }

  class ThreadUpdateIsDisplay extends Thread {

    void run() {
      while (true) {
        UpdateDisplay();
        entManager.AllDisplayEntities.clear();
        for (Entity e : entManager.getEntity()) {
          if (e.isDisplay()) entManager.AllDisplayEntities.add(e);
        }
        delay(100);
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

    String[] entALoader = {"Solide", "Player", "onModule", "ModuleSocle", "Enemy", "Loot"};

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

      for (String className : entALoader) {
        try {
          print("loading : "+className);
          JSONArray array = JSONAllEntities.getJSONArray(className);
          for (int i=0; i<array.size(); i++) {

            if (className.equals("Solide")) {
              Solide s = new Solide(array.getJSONObject(i));
              entManager.addEntity(s);
            }
            
            /*
            
            if (className.equals("onModule")) {
              OnModule s = new OnModule(array.getJSONObject(i));
              entManager.addEntity(s);
            }
            
            if (className.equals("ModuleSocle")) {
              Solide s = new Solide(array.getJSONObject(i));
              entManager.addEntity(s);
            }
            
            if (className.equals("Enemy")) {
              Solide s = new Solide(array.getJSONObject(i));
              entManager.addEntity(s);
            }
            */
          }
          println(" / Success ! "+array.size()+" loaded !");
        }
        catch(Exception e) {
          println(" / Failed : " + e);
        }
      }
    }


    void SaveEntities() {
      JSONObject JSONAllEntities = new JSONObject();

      for (int i=0; i<entManager.getEntity().size(); i++) {
        Entity e = entManager.getEntity(i);
        JSONObject json = e.getJSON(e);
        String className = getObjectClassName(e);

        JSONArray entityArray = JSONAllEntities.getJSONArray(className);
        if (entityArray == null) {
          entityArray = new JSONArray();
          JSONAllEntities.setJSONArray(className, entityArray);
        }
        entityArray.setJSONObject(entityArray.size(), json);

        JSONAllEntities.setJSONArray(className, entityArray);
      }

      saveJSONObject(JSONAllEntities, basePath + "entities.json");
      println("Map Saved", mapName, "at", basePath, ":");
      println(JSONAllEntities);
    }
  }

  //=======================================================================================

  class EntityManager {

    ArrayList<Entity> AllEntities;
    ArrayList<Entity> AllDisplayEntities;
    ArrayList<Particles> AllParticles;

    EntityManager() {
      AllEntities = new ArrayList<Entity>();
      AllParticles = new ArrayList<Particles>();
      AllDisplayEntities = new ArrayList<Entity>();
    }

    //Entity

    ArrayList<Entity> getEntity() {
      return AllEntities;
    }

    ArrayList<Entity> getEntityDisplay() {
      //println(AllDisplayEntities.size());
      return AllDisplayEntities;
    }

    Entity getEntity(int no) {
      return AllEntities.get(no);
    }

    void addEntity(Entity e) {
      AllEntities.add(e);
    }
    void addEntity(int index, Entity e) {
      AllEntities.add(index, e);
    }

    void RemoveEntity(int i) {
      AllEntities.remove(i);
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
