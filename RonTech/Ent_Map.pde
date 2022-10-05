Map mapActif;

class Map {

  color GroundGrille[][];

  ArrayList<Player> AllPlayers;
  ArrayList<Mur> AllMurs;
  ArrayList<Loot> AllLoot;
  int tailleCase = 50;
  float tailleBlocs = 20;

  ThreadUpdate threadUpdate;
  int timeThreadUpdate = 1;
  
  MapLoader mapLoader;


  Map() {
    mapLoader = new MapLoader();
    mapLoader.LoadMap("map1.png");
    
    AllPlayers = new ArrayList<Player>();    
    AllMurs = new ArrayList<Mur>();
    AllLoot = new ArrayList<Loot>();

    Player player = new Player(5, 5);
    player.controllable = true;

    AllPlayers.add(player);

    threadUpdate = new ThreadUpdate();
    threadUpdate.start();
  }

  void Display() {

    DisplayGrille();


    for (Mur m : AllMurs) {
      if (m.isDisplay) {
        m.Display();
      }
    }

    for (Player p : AllPlayers) {
      if (p.isDisplay) {
        p.Display();
      }
    }

    for (Loot l : AllLoot) {
      if (l.isDisplay) {
        if (l.isDisplay) {
          l.Display();
        }
      }
    }
  }

  void Update() {
    for (Player p : AllPlayers) {
      p.Update();
    }

    for (Loot l : AllLoot) {
      l.Update();
    }
  }

  void UpdateDisplay() {
    if (camera != null) {
      for (Loot l : AllLoot) {
        if (camera.isOnScreen(l, AllPlayers.get(0))) {
          l.isDisplay = true;
        } else l.isDisplay = false;
      }

      for (Mur m : AllMurs) {
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

  void DisplayGrille() {
    if (GroundGrille != null) {
      for (int x=0; x<GroundGrille.length; x++) {
        for (int y=0; y<GroundGrille[0].length; y++) {
          push();
          fill(GroundGrille[x][y]);
          noStroke();
          rect(x*tailleCase, y*tailleCase, tailleCase, tailleCase);
          pop();
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
      
      println("Loaded Map : " + mapImage.width,"/", mapImage.height);

      for (int x=0; x<GroundGrille.length; x++) {
        for (int y=0; y<GroundGrille[0].length; y++) {
          GroundGrille[x][y] = mapImage.get(x, y);
        }
      }
    }
  }
}
