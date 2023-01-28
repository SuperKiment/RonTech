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

  inputControl = new InputControl();
  outilsManager = new OutilsManager();
  gameManager = new GameManager();
  gameManager.optionsManager.Setup("options.options");
  time = new Time();
  hud = new HUD();

  SetupMap("map1");
  camera = new Camera();

  console = new Console();

  fichiersLoader = new FichiersLoader("Loaders/", "loader.loader");
  
  mapActif.entManager.getEntity().add(new Loot());
  mapActif.entManager.getEntity().add(new Loot(2, 6));
  mapActif.entManager.getEntity().add(new Loot(2, 7, "epee"));

  mapActif.entManager.getEntity().add(new Enemy(15, 20, 5));
  mapActif.entManager.getEntity().add(new Enemy(15, 25, 2));
  mapActif.entManager.getEntity().add(new Enemy(15, 30, 0.1));

  mapActif.entManager.addEntity(new ModuleSocle(15, 19));
  mapActif.entManager.addEntity(new ModuleSocle(15, 10));
  mapActif.entManager.addEntity(new ModuleSocle(15, 11));
  mapActif.entManager.addEntity(new ModuleSocle(15, 12));
  mapActif.entManager.addEntity(new ModuleSocle(15, 13));

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

  console.add("FrameRate : "+frameRate);
  console.add("delta Frames (ms) : "+time.getDeltaFrames() * 1000);

  //console.add(mapActif.AllPlayers.get(0).vel.toString());

  console.add("Objet en [0] Entité (Should be Player) : "+getObjectClassName(mapActif.entManager.getPlayer()));

  hud.Display();
}
