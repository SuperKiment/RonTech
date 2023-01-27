InputControl inputControl;
OutilsManager outilsManager;

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

//=================OUTILS






class OutilsManager {

  ModuleSocle clickedModule;

  OutilsManager() {
    clickedModule = null;
  }

  void Click() {
    switch(gameManager.outil) {
    case SwitchCam:
      for (Entity e : mapActif.entManager.getEntity()) {
        if (IsOnEntity(e, mouseX, mouseY)) {
          camera.SwitchFocus(e);
        }
      }
      break;

    case LiaisonModule:
      for (Entity e : mapActif.entManager.getEntity()) {
        if (IsOnEntity(e, mouseX, mouseY)) {

          if (clickedModule == null && e.isModule) {
            clickedModule = (ModuleSocle)e;
            println("Module set");
          } else if (clickedModule != null) {

            clickedModule.liaison = e;
            println("Module en "+clickedModule.getPos()+" lié à "+e.getPos());
            clickedModule = null;
          }
        }
      }
      break;

    case Play:
      break;
    }
  }
}



//======================KEYPRESSED AND SUCH


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
  /*
  if (key == 'l') {
   mapActif = new Map("map2");
   }
   */

  if (key == inputControl.keys.get("liaisonModule")) {
    gameManager.outil = Outil.LiaisonModule;
  }
  if (key == inputControl.keys.get("switchCamera")) {
    gameManager.outil = Outil.SwitchCam ;
  }
  if (key == inputControl.keys.get("play")) {
    gameManager.outil = Outil.Play;
  }
}


void keyReleased() {
  inputControl.setInput(key, false);
}

void mousePressed() {
  outilsManager.Click();
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
