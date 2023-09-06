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

  SetupMap("mapNoise");
  camera = new Camera();

  console = new Console();

  fichiersLoader = new FichiersLoader("Loaders/", "index.loader");
  
  mapActif.entManager.addEntity(new Loot());
  mapActif.entManager.addEntity(new Loot(2, 6));
  mapActif.entManager.addEntity(new Loot(2, 7, "epee"));


  println("==============");
  println("RONTECH SETUP END");
  println("==============");
}

void draw() {
  background(50);

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
