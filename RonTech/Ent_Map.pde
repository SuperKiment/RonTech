Map mapActif;

class Map {

  ArrayList<Player> AllPlayers;
  ArrayList<Mur> AllMurs;
  ArrayList<Loot> AllLoot;
  int tailleCase = 50;
  float tailleBlocs = 20;

  ThreadUpdate threadUpdate;
  int timeThreadUpdate = 1;


  Map() {
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

    LignesDisplay();

    for (Mur m : AllMurs) {
      m.Display();
    }

    for (Player p : AllPlayers) {
      p.Display();
    }

    for (Loot l : AllLoot) {
      l.Display();
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

  void LignesDisplay() {
    push();
    stroke(255);
    strokeWeight(0.1);
    for (int x = 1; x <=  10 * tailleCase; x += tailleCase) {
      line(x, 0, x, 10000);
      push();
      fill(255);
      textSize(10);
      text(x - 1 + " , " + x / tailleCase, x, 0);
      pop();
    }

    for (int y = 1; y <=  10 * tailleCase; y += tailleCase) {      
      line(0, y, 10000, y);
      push();
      fill(255);
      textSize(10);
      text(y - 1 + " , " + y / tailleCase, 0, y);
      pop();
    }
    pop();
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
}
