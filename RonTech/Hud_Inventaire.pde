class Inventaire {

  Loot[][] grille;

  Inventaire() {
    Constructor();
  }

  void Constructor() {
    grille = new Loot[5][5];
  }

  void add(Loot l) {
    boolean added = false;

    for (int x=0; x<grille.length; x++) {
      for (int y=0; y<grille[0].length; y++) {
        if (grille[x][y] == null) {
          grille[x][y] = l;
          added = true;
          println("ajout a l'inventaire en " +x, y+" de "+l.nom);
          break;
        }
        if (added) break;
      }
      if (added) break;
    }

    if (!added) {
      println("Pas de place dans l'inventaire");
      mapActif.AllLoot.add(l);
    }
  }
}

//====================================================================  HUD

class InventoryHUD {

  Player p;
  int nbCasesX, nbCasesY;
  float tailleCase;
  int posXM, posYM;
  ThreadInventaire threadInventaire;

  InventoryHUD() {
    threadInventaire = new ThreadInventaire();
    threadInventaire.start();
  }

  void Display() {
    p = camera.focus;

    push();

    rectMode(CORNER);
    fill(125, 125, 125, 100);
    noStroke();

    rect(0, 0, width/2, tailleCase*nbCasesY);   //Fond

    push();
    stroke(0);
    for (int x=0; x<nbCasesX; x++) {             //Cases
      for (int y=0; y<nbCasesY; y++) {
        rect(tailleCase*x, tailleCase*y, tailleCase * 9/10, tailleCase * 9/10, 10);
        if (p.inventaire.grille[x][y] != null) {

          Loot l = p.inventaire.grille[x][y];        //Dans l'inv
          l.DisplayOnScreen(x * tailleCase + tailleCase/2, y * tailleCase + tailleCase/2);
        }
      }
    }
    pop();
    pop();
  }

  void ClickG() {
    int x = int(mouseX/tailleCase);
    int y = int(mouseY/tailleCase);


    if (x<nbCasesX && y<nbCasesY) {

      Loot l = p.inventaire.grille[x][y];    

      println("coord sur inventory : "+x, y + " / Loot : "+l.nom);
    }
  }

  void Update() {
  }

  class ThreadInventaire extends Thread {
    
    
    
    void run() {
      if (p != null) {
        nbCasesX = p.inventaire.grille.length;
        nbCasesY = p.inventaire.grille[0].length;
        tailleCase = ((width/2) / nbCasesX);
        println("ah");
      }
    }
  }
}
