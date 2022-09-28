HUD hud;

enum TitleMode {
  Title, Options, Credits;
}


class HUD {

  Title title;
  InventoryHUD inventoryHUD;

  HUD() {
    title = new Title();
    inventoryHUD = new InventoryHUD();
  }

  void Display() {
    if (gameManager.isPlay()) {
      //Interface de jeu
    }

    if (gameManager.isInventory()) {
      //Interface d'inventaire
      inventoryHUD.Display();
    }

    if (gameManager.isTitle()) {
      //Interface de titre
      title.Display();
    }

    push();
    textAlign(CORNER);
    text(time.getDeltaFrames()*1000, 20, 20);
    text(frameRate, 20, 30);
    pop();
  }

  

  class Title {

    ArrayList<Bouton> BoutonsTitle;
    TitleMode titleMode = TitleMode.Title;

    Title() {
      BoutonsTitle = new ArrayList<Bouton>();

      BoutonsTitle.add(new Bouton(width/2, height/2, width/4, height/10, "Play"));

      BoutonsTitle.add(new Bouton(width/2, height/2 + height/10, width/4, height/10, "Options"));

      BoutonsTitle.add(new Bouton(width/2, height/2 + 2*height/10, width/4, height/10, "Credits"));

      BoutonsTitle.add(new Bouton(width/2, height/2 + 3*height/10, width/4, height/10, "Quit"));
    }

    void Display() {

      background(0);

      push();
      fill(255);
      translate(width/2, 0);
      textSize(height/10);   //PlaTech
      text("PlaTech", 0, height/3);
      pop();

      for (Bouton b : BoutonsTitle) {  //Display Boutons
        b.Display();
      }
      
      textSize(10);
    }

    void MouseClick() {
      for (int i=0; i<BoutonsTitle.size(); i++) {
        Bouton b = BoutonsTitle.get(i);
        if (b.isMouseOn()) {
          switch(i) {
          case 0 :
            gameManager.setPlay();
            println("Title : Play");
            break;

          case 1 :
            titleMode = TitleMode.Options;
            println("Title : Options");
            break;

          case 2 :
            titleMode = TitleMode.Credits;
            println("Title : Credits");
            break;

          case 3 :
            println("Title : exit");
            exit();
            break;
          }
        }
      }
    }
  }



  class Bouton {

    PVector pos, taille;
    String text;

    Bouton(float x, float y, float tx, float ty, String s) {
      pos = new PVector(x, y);
      taille = new PVector(tx, ty);
      text = s;
    }

    Bouton(String s) {
      pos = new PVector(width/2, height/2);
      taille = new PVector(50, 50);      
      text = s;
    }

    void Display() {
      push();

      if (!isMouseOn()) {
        strokeWeight(3);
        stroke(255);
        fill(0);
      } else {
        strokeWeight(7);
        stroke(255);
        fill(50);
      }

      translate(pos.x, pos.y);

      rect(0, 0, taille.x, taille.y);
      textSize(height/20);
      fill(255);
      text(text, 0, 0);

      pop();
    }

    boolean isMouseOn() {
      if (mouseX <= pos.x+taille.x/2 &&
        mouseX   >= pos.x-taille.x/2 &&
        mouseY   <= pos.y+taille.y/2 &&
        mouseY   >= pos.y-taille.y/2) {
        return true;
      } else return false;
    }
  }
}
