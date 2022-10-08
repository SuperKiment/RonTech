InputControl inputControl = new InputControl();

class InputControl {

  PVector keyDir;
  boolean z = false, q = false, s = false, d = false, space = false, b = false;

  InputControl() {
    keyDir = new PVector();
  }

  void setInput(char ke, boolean set) {

    switch(ke) {
    case 'z' : 
      z = set;
      break;

    case 'q' : 
      q = set;  
      break;

    case 's' : 
      s = set;  
      break;

    case 'd' : 
      d = set;
      break;

    case ' ':
      space = set;
      break;

    case 'b' : 
      b = set;  
      break;
    }

    UpdateKeyDir();
  }

  void UpdateKeyDir() {
    keyDir = new PVector();

    if (z) keyDir.y--;
    if (s) keyDir.y++;
    if (q) keyDir.x--;
    if (d) keyDir.x++;

    keyDir.normalize();
  }
}


void keyPressed() {
  inputControl.setInput(key, true);

  if (key == 'b') {

    if (gameManager.isPlay()) {
      gameManager.setInventory();
      println("inv");
    } else if (gameManager.isInventory()) {
      gameManager.setPlay();
      println("play");
    }
  }
}
void keyReleased() {
  inputControl.setInput(key, false);
}

void mousePressed() {
  for (Player e : mapActif.AllPlayers)
    if (e.IsOnPlayer(mouseX, mouseY)) {
      camera.SwitchFocus(e);
    }

  if (mouseButton == LEFT) {
    thread("ClickLeftMouse");
  }
}

void mouseReleased() {
  if (gameManager.isTitle()) {
    hud.title.MouseClick();
  }

  if (gameManager.isInventory()) hud.inventoryHUD.ClickG();
}

void ClickTestEverything() {
  for (Loot l : mapActif.AllLoot) {
    if (dist(MousePosScreenGr().x, MousePosScreenGr().y, 
      l.pos.x, l.pos.y) <= SnToGr(l.taille)) {
      println("Loot clicked : " + l.nom);
    }
  }
}

void ClickLeftMouse() {
  mapActif.AllPlayers.get(0).LeftClick();
}
