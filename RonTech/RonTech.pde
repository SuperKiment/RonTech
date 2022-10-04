int timeFactor = 300;

void setup() { 
  size(1500, 1000);
  frameRate(200);
  surface.setTitle("RonTech");
  surface.setResizable(true);
  surface.setIcon(loadImage("icon.png"));

  rectMode(CENTER);
  textAlign(CENTER);
  imageMode(CENTER);
  strokeWeight(3);

  gameManager = new GameManager();
  time = new Time();
  hud = new HUD();

  mapActif = new Map();
  camera = new Camera();

  mapActif.AllPlayers.get(0).AllModules.add(new ModuleTest(mapActif.AllPlayers.get(0), 50, PI, 1, 1));
  mapActif.AllPlayers.get(0).AllModules.add(new ModuleTest(mapActif.AllPlayers.get(0), 40, PI / 2, 7, 2));
  mapActif.AllPlayers.get(0).AllModules.add(new ModuleTest(mapActif.AllPlayers.get(0), 100, PI * 3 / 4, 0.5, 3));
  mapActif.AllPlayers.get(0).AllModules.add(new ModuleTest(mapActif.AllPlayers.get(0), 20, 0, 2, 1));

  mapActif.AllMurs.add(new Mur(10, 5));
  mapActif.AllMurs.add(new Mur(10, 10));
  mapActif.AllMurs.add(new Mur(10, 7));

  mapActif.AllLoot.add(new Loot());
  mapActif.AllLoot.add(new Loot(2, 6));
  mapActif.AllLoot.add(new Loot(2, 7, "epee"));
}

void draw() {
  background(#27813D);

  gameManager.PreUpdate();

  if (!gameManager.isTitle()) {
    //Display

    push();
    if (camera.trackCible) {
      camera.Update();
      camera.Translate();
    }

    mapActif.Display();

    rectMode(CORNER);

    pop();
  }

  gameManager.PostUpdate();

  hud.Display();
}
