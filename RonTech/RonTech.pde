int timeFactor = 300;

void setup() {

  println("==============");
  println("RONTECH SETUP");
  println("==============");

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
  gameManager.optionsManager.Setup("options.options");
  time = new Time();
  hud = new HUD();

  mapActif = new Map("map1");
  camera = new Camera();

  console = new Console();

  fichiersLoader = new FichiersLoader("Loaders/", "loader.loader");

  mapActif.AllPlayers.get(0).addModule(new ModuleSocleTourelle(mapActif.AllPlayers.get(0)), new Tourelle());
  mapActif.AllPlayers.get(0).addModule(new ModuleSocleTourelle(mapActif.AllPlayers.get(0)), new Bouclier());
  mapActif.AllPlayers.get(0).addModule(new ModuleSocleTourelle(mapActif.AllPlayers.get(0)), new Bouclier());
  mapActif.AllPlayers.get(0).addModule(new ModuleSocleTourelle(mapActif.AllPlayers.get(0)), new Bouclier());


  mapActif.AllSolides.add(new Solide(10, 5));
  mapActif.AllSolides.add(new Solide(10, 10));
  mapActif.AllSolides.add(new Solide(10, 7));
  mapActif.AllSolides.add(new Solide(20, 13));

  mapActif.AllLoot.add(new Loot());
  mapActif.AllLoot.add(new Loot(2, 6));
  mapActif.AllLoot.add(new Loot(2, 7, "epee"));

  mapActif.AllEnemies.add(new Enemy(15, 20, 5));
  mapActif.AllEnemies.add(new Enemy(15, 25, 2));
  mapActif.AllEnemies.add(new Enemy(15, 30, 0.1));

  println("==============");
  println("RONTECH SETUP END");
  println("==============");
}

void draw() {
  //background(#27813D);

  gameManager.PreUpdate();

  if (!gameManager.isTitle()) {
    //Display

    push();
    if (camera.trackCible) {
      camera.Update();
      camera.Translate();
    }

    mapActif.Display();
    pop();
  }

  gameManager.PostUpdate();

  console.add(frameRate);
  console.add(time.getDeltaFrames() * 1000);

  console.add(mapActif.AllPlayers.get(0).vel.toString());

  hud.Display();
}
