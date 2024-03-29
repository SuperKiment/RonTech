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

  float liaisonRange = 6;

  OutilsManager() {
    clickedModule = null;
  }

  void Display() {
    if (clickedModule != null) {
      push();
      stroke(#20C4E3);

      line(mouseX, mouseY, GrToSn(clickedModule.getPos().x)+camera.translate.x, GrToSn(clickedModule.getPos().y)+camera.translate.y);

      pop();
    }
  }

  void Click() {
    switch(gameManager.outil) {
    case SwitchCam:
      for (Entity e : mapActif.entManager.getEntity()) {
        if (IsMouseOnEntity(e)) {
          camera.SwitchFocus(e);
        }
      }
      break;

    case LiaisonModule:
      boolean clickOnEnt = false;
      for (Entity e : mapActif.entManager.getEntity()) {
        if (IsMouseOnEntity(e)) {

          clickOnEnt = true;

          //Si c'est le premier click
          if (clickedModule == null && e.isModule) {
            clickedModule = (ModuleSocle)e;
          } else if (clickedModule != null) {
            if (PVector.sub(clickedModule.pos, e.pos).mag() <= liaisonRange) {
              //Si c'est le second click
              LierModuleEntity(clickedModule, e);
              clickedModule = null;
            } else hudAlerteManager.add("Trop loin !");
          }
        }
      }

      //Délier un module
      if (!clickOnEnt && clickedModule != null) {
        LierModuleEntity(clickedModule, null);
        clickedModule = null;
      }
      break;

    case Play:
      break;
    }
  }

  void LierModuleEntity(ModuleSocle m, Entity e) {
    if (e != null) {
      if (e.moduleManager != null) {

        //Supp de l'ancienne liaison
        if (m.liaison != null && m.liaison.moduleManager.AllModules.size() > 0) {
          m.liaison.moduleManager.suppModule(m);
        }

        //Ajout dans l'entité
        if (e.moduleManager.addModule(m)) {
          //Ajout dans le module
          m.setLiaison(e);
        }
      }
    } else {
      //Délier
      if (m.liaison != null && m.liaison.moduleManager.AllModules.size() > 0) {
        m.liaison.moduleManager.suppModule(m);
      }
      m.SuppLiaison();
    }
  }
}



//======================ENTITY ON MOUSE



class EntityOnMouse extends Entity {

  EntityOnMouse() {
    moduleManager = new ModuleManager(this);
    moduleManager.maxModules = 1;
  }

  void Display() {
    push();
    translate(GrToSn(pos.x), GrToSn(pos.y));
    ellipse(0, 0, 10, 10);
    pop();
  }

  void Update() {
    pos = SnToGr(MousePosScreen().copy());
  }
}



//======================KEYPRESSED AND SUCH


void keyPressed() {
  if (key == inputControl.keys.get("writing")) {
    println("fez");
    console.isWriting = !console.isWriting;
  }

  if (!console.isWriting) {
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
      consoleDisplay = !consoleDisplay;
      println("Console Display : "+consoleDisplay);
    }

    if (key == inputControl.keys.get("infos")) {
      infosDisplay = !infosDisplay;
      println("Infos Display : "+infosDisplay);
    }

    if (key == inputControl.keys.get("mapZoom") || key == inputControl.keys.get("mapDeZoom")) mapActif.Zoom(key);
    if (key == 'l') mapActif.mapLoader.SaveEntities();
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
  } else {
    if (key != inputControl.keys.get("writing") && key != '\n')
      console.Write(key);
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
