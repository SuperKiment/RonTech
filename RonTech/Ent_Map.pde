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
    entManager.addPlayer(player);

    println("Map ajout d'un player en", xP, yP+ ", controllable :", player.controllable);

    threadUpdate = new ThreadUpdate();
    threadUpdate.start();


    println("Map Thread lance");
  }

  void Display() {
    try {

      DisplayGrille(entManager.getPlayer(0));


      for (Solide m : entManager.getSolide()) {
        if (m.isDisplay) {
          m.Display();
        }
      }

      for (Player p : entManager.getPlayer()) {
        if (p.isDisplay) {
          p.Display();
        }
      }

      for (Enemy e : entManager.getEnemy()) {
        if (e.isDisplay) {
          e.Display();
        }
      }

      for (Loot l : entManager.getLoot()) {
        if (l.isDisplay) {
          if (l.isDisplay) {
            l.Display();
          }
        }
      }

      try {
        for (Attack a : entManager.getAttack()) {
          a.Display();
        }
      }
      catch (Exception e) {
      }

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

    for (Loot l : entManager.getLoot()) {
      l.Update();
    }

    for (Solide s : entManager.getSolide()) {
      s.Update();
    }

    try {
      for (int i=0; i<entManager.getAttack().size(); i++) {
        Attack a = entManager.getAttack().get(i);
        a.Update();
        if (a.isMort()) entManager.getAttack().remove(i);
      }
    }
    catch(Exception e) {
      println("FUCK");
      entManager.getAttack().clear();
    }

    for (int i=0; i<entManager.getEnemy().size(); i++) {
      Enemy e = entManager.getEnemy().get(i);
      e.Update();
      if (e.isMort) entManager.getEnemy().remove(i);
    }

    for (Player p : entManager.getPlayer()) {
      p.Update();

      if (inputControl.leftClickUtiliser) {
        p.LeftClick();
      }
    }
  }




  void UpdateDisplay() {
    if (camera != null) {
      for (Loot l : entManager.getLoot()) {
        if (camera.isOnScreen(l, entManager.getPlayer().get(0))) {
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

  class EntityManager {

    ArrayList<Player> AllPlayers;
    ArrayList<Solide> AllSolides;
    ArrayList<Loot> AllLoots;
    ArrayList<Attack> AllAttacks;
    ArrayList<Entity> AllEntities;
    ArrayList<Enemy> AllEnemies;
    ArrayList<Particles> AllParticles;


    EntityManager() {
      AllPlayers = new ArrayList<Player>();
      AllSolides = new ArrayList<Solide>();
      AllLoots = new ArrayList<Loot>();
      AllAttacks = new ArrayList<Attack>();
      AllEntities = new ArrayList<Entity>();
      AllEnemies = new ArrayList<Enemy>();
      AllParticles = new ArrayList<Particles>();
    }

    ArrayList<Solide> getSolide() {
      return AllSolides;
    }
    Solide getSolide(int no) {
      return AllSolides.get(no);
    }

    ArrayList<Player> getPlayer() {
      return AllPlayers;
    }
    Player getPlayer(int no) {
      return AllPlayers.get(no);
    }

    ArrayList<Loot> getLoot() {
      return AllLoots;
    }
    Loot getLoot(int no) {
      return AllLoots.get(no);
    }

    ArrayList<Attack> getAttack() {
      return AllAttacks;
    }
    Attack getAttack(int no) {
      return AllAttacks.get(no);
    }

    ArrayList<Entity> getEntity() {
      return AllEntities;
    }
    Entity getEntiti(int no) {
      return AllEntities.get(no);
    }

    ArrayList<Enemy> getEnemy() {
      return AllEnemies;
    }
    Enemy getEnemy(int no) {
      return AllEnemies.get(no);
    }

    ArrayList<Particles> getParticles() {
      return AllParticles;
    }
    Particles getParticle(int no) {
      return AllParticles.get(no);
    }



    void addSolide(Solide e) {
      getSolide().add(e);
    }
    void addPlayer(Player e) {
      getPlayer().add(e);
    }
    void addEnemy(Enemy e) {
      getEnemy().add(e);
    }
    void addParticles(Particles e) {
      getParticles().add(e);
    }
    void addLoot(Loot e) {
      getLoot().add(e);
    }
    void addEntity(Entity e) {
      getEntity().add(e);
    }
    void addAttack(Attack e) {
      getAttack().add(e);
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
