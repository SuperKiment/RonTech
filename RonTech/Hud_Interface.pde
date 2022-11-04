HUD hud;
boolean debug = true;

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

    if (debug) {
      console.Display();
    }
  }



  class Title {

    ArrayList<Bouton> BoutonsTitle;
    TitleMode titleMode = TitleMode.Title;

    Title() {
      BoutonsTitle = new ArrayList<Bouton>();

      BoutonsTitle.add(new Bouton(width / 2, height / 2, width / 4, height / 10, "Play"));

      BoutonsTitle.add(new Bouton(width / 2, height / 2 + height / 10, width / 4, height / 10, "Options"));

      BoutonsTitle.add(new Bouton(width / 2, height / 2 + 2 * height / 10, width / 4, height / 10, "Credits"));

      BoutonsTitle.add(new Bouton(width / 2, height / 2 + 3 * height / 10, width / 4, height / 10, "Quit"));
    }

    void Display() {

      background(0);

      push();
      fill(255);
      translate(width / 2, 0);
      textSize(height / 10);   //PlaTech
      text("PlaTech", 0, height / 3);
      pop();

      for (Bouton b : BoutonsTitle) {  //Display Boutons
        b.Display();
      }

      textSize(10);
    }

    void MouseClick() {
      for (int i = 0; i < BoutonsTitle.size(); i++) {
        Bouton b = BoutonsTitle.get(i);
        if (b.isMouseOn()) {
          switch(i) {
          case 0 :
            gameManager.setPlay();
            println("Title :Play");
            break;

          case 1 :
            titleMode = TitleMode.Options;
            println("Title :Options");
            break;

          case 2 :
            titleMode = TitleMode.Credits;
            println("Title :Credits");
            break;

          case 3 :
            println("Title :exit");
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
      pos = new PVector(width / 2, height / 2);
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
      textSize(height / 20);
      fill(255);
      text(text, 0, 0);

      pop();
    }

    boolean isMouseOn() {
      if (mouseX <= pos.x + taille.x / 2 &&
        mouseX  >= pos.x - taille.x / 2 &&
        mouseY  <= pos.y + taille.y / 2 &&
        mouseY  >= pos.y - taille.y / 2) {
        return true;
      } else return false;
    }
  }
}




//=========================================================================





class InventoryHUD {

  Player p;
  int nbCasesX, nbCasesY;
  float tailleCase;
  int posXM, posYM;

  InventoryHUD() {
  }

  void Display() {
    Update();

    push();

    rectMode(CORNER);
    fill(125, 125, 125, 100);
    noStroke();
    rect(0, 0, width / 2, tailleCase * nbCasesY);   //Fond

    push();
    stroke(0);
    for (int x = 0; x < nbCasesX; x++) {             //Cases
      for (int y = 0; y < nbCasesY; y++) {
        rect(tailleCase * x, tailleCase * y, tailleCase * 9 / 10, tailleCase * 9 / 10, 10);
        if (p.inventaire.grille[x][y] != null) {

          Loot l = p.inventaire.grille[x][y];        //Dans l'inv
          l.DisplayOnScreen(x * tailleCase + tailleCase / 2, y * tailleCase + tailleCase / 2);
        }
      }
    }
    pop();
    pop();
  }

  void ClickG() {
    int x = int(mouseX / tailleCase);
    int y = int(mouseY / tailleCase);


    if (x < nbCasesX && y < nbCasesY) {

      Loot l = p.inventaire.grille[x][y];
      if (l != null) {
        println("coord sur inventory : " + x, y + " / Loot : " + l.nom + " : jeté");
        LootItem(l, x, y);
      } else {
        println("coord sur inventory : " + x, y + " / Pas de loot");
      }
    }
  }

  void LootItem(Loot l, int x, int y) {
    PVector posJete = new PVector(p.pos.x, p.pos.y);
    PVector taille = PVector.random2D();
    taille.setMag(SnToGr(p.taille.x));
    posJete.add(taille);

    println("coord jeté : " + posJete);
    l.setPos(posJete.x, posJete.y);
    mapActif.AllLoot.add(l);
    p.inventaire.grille[x][y] = null;
  }

  void Update() {
    p = camera.focus;

    nbCasesX = p.inventaire.grille.length;
    nbCasesY = p.inventaire.grille[0].length;
    tailleCase = ((width / 2) / nbCasesX);

    posXM = int(mouseX / tailleCase);
    posYM = int(mouseY / tailleCase);
  }
}









//=========================================================================









Console console;

class Console {

  PVector pos;
  ArrayList<String> tabl;
  float taillePol = 15, taille;

  Console() {
    tabl = new ArrayList<String>();
    pos = new PVector();
  }

  void Display() {
    if (taille > 0) {
      push();
      rectMode(CORNER);
      noStroke();
      fill(0, 0, 0, 70);
      rect(pos.x, pos.y, width, taille);

      textSize(taillePol);
      fill(255);

      for (int i=0; i<tabl.size(); i++) {
        text(tabl.get(i), 50, i*taillePol+taillePol);
      }

      pop();

      tabl.clear();
    }
  }

  void add(String ajout) {
    tabl.add(ajout);
    taille = tabl.size() * taillePol;
  }
  void add(float ajout) {
    tabl.add(String.valueOf(ajout));
    taille = tabl.size() * taillePol;
  }
}
