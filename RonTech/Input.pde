InputControl inputControl;

class InputControl {

  PVector keyDir;
  boolean leftClickUtiliser = false;

  HashMap<String, Character> keys;
  HashMap<Character, Boolean> keysInput;

  InputControl() {
    keyDir = new PVector();
    keys = new HashMap<String, Character>();
    keysInput = new HashMap<Character, Boolean>();

    String[] keysFile = loadStrings("key-binding.options");

    println();
    println("Key Keys :");

    for (String l : keysFile) {
      String[] line = split(l, " : ");
      char c = line[1].toCharArray()[0];
      println("Key "+l);

      keys.put(line[0], c);
      keysInput.put(c, false);
    }

    println();
  }

  void setInput(char ke, boolean set) {
    keysInput.put(ke, set);

    UpdateKeyDir();
  }

  void UpdateKeyDir() {
    keyDir = new PVector();

    if (keysInput.get(keys.get("up"))) keyDir.y--;
    if (keysInput.get(keys.get("down"))) keyDir.y++;
    if (keysInput.get(keys.get("left"))) keyDir.x--;
    if (keysInput.get(keys.get("right"))) keyDir.x++;

    keyDir.normalize();
  }
}


void keyPressed() {
  inputControl.setInput(key, true);

  if (key == inputControl.keys.get("inventory")) {

    if (gameManager.isPlay()) {
      gameManager.setInventory();
      println("inv");
    } else if (gameManager.isInventory()) {
      gameManager.setPlay();
      println("play");
    }
  }

  if (key == inputControl.keys.get("console")) {
    if (consoleDisplay) {
      consoleDisplay = false;
    } else consoleDisplay = true;
    println("Console Display : "+consoleDisplay);
  }
  if (key == inputControl.keys.get("infos")) {
    if (infosDisplay) {
      infosDisplay = false;
    } else infosDisplay = true;
    println("Infos Display : "+infosDisplay);
  }

  if (key == inputControl.keys.get("mapZoom") || key == inputControl.keys.get("mapDeZoom")) mapActif.Zoom(key);
  //if (key == 'l') mapActif.mapLoader.SaveEntities();
  if (key == 'l') {
    mapActif = new Map("map2");
  }
}


void keyReleased() {
  inputControl.setInput(key, false);
}

void mousePressed() {
  for (Entity e : mapActif.entManager.getEntity()) {

    if (IsOnEntity(e, mouseX, mouseY)) {
      if (gameManager.outil == Outil.SwitchCam) camera.SwitchFocus(e);
    }
  }

  if (mouseButton == LEFT && gameManager.isPlay()) {
    inputControl.leftClickUtiliser = true;
  }
}

void mouseReleased() {
  if (gameManager.isTitle()) {
    hud.title.MouseClick();
  }

  if (gameManager.isInventory()) hud.inventoryHUD.ClickG();

  if (mouseButton == LEFT && gameManager.isPlay()) {
    inputControl.leftClickUtiliser = false;
  }
}
