HUD hud;
HUDAlerteManager hudAlerteManager;
boolean consoleDisplay = false;
boolean infosDisplay = false;

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

    outilsManager.Display();

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

    if (consoleDisplay) {
      console.DisplayConsole();
    }

    if (console.isWriting) console.DisplayUpdateWriting();


    //=======================================================INFOS

    if (infosDisplay && gameManager.isPlay()) {
      try {
        for (Entity e : mapActif.entManager.getEntity()) {

          String[] keys = loadStrings("key-binding.options");
          push();
          textAlign(CORNER);
          for (int i=0; i<keys.length; i++) {
            String line = keys[i];
            text(line, 0, 200+i*15);
          }

          text("Outil : " + gameManager.outil.toString(), 0, 200+keys.length*15+30);
          pop();

          if (e.isDisplay()) {
            push();
            stroke(255);
            strokeWeight(1);
            float xPos = GrToSn(e.getPos().x)+camera.translate.x;
            float yPos = GrToSn(e.getPos().y)+camera.translate.y;

            fill(0, 0, 0, 0);
            rect(xPos, yPos, 100, 100);

            translate(xPos, yPos);
            textAlign(CORNER);
            rectMode(CORNER);
            noStroke();
            textSize(10);
            fill(0, 0, 0, 100);

            String info = getObjectClassName(e)+" / pos : "+e.getPos();
            rect(-50, -60, info.length()*5, 10);
            fill(255);
            text(info, -50, -52);

            pop();
          }
        }
      }
      catch (Exception e) {
      }
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

  Player player;
  int nbCasesX, nbCasesY;
  float tailleCase;
  int posXM, posYM;

  InventoryHUD() {
  }

  void Display() {
    Update();

    push();

    rectMode(CENTER);
    fill(125, 125, 125, 100);
    noStroke();
    rect(0, 0, width / 2, tailleCase * nbCasesY);   //Fond

    push();
    stroke(0);
    for (int x = 0; x < nbCasesX; x++) {             //Cases
      for (int y = 0; y < nbCasesY; y++) {
        push();
        translate(tailleCase * x + tailleCase/2, tailleCase * y + tailleCase/2);
        rect(0, 0, tailleCase * 9 / 10, tailleCase * 9 / 10, 10);

        if (player.inventaire.grille[x][y] != null) {

          Loot loot = (Loot)player.inventaire.grille[x][y];        //Dans l'inv
          loot.DisplayOnScreen(0, 0);
        }
        pop();
      }
    }
    pop();
    pop();
  }

  void ClickG() {
    int x = int(mouseX / tailleCase);
    int y = int(mouseY / tailleCase);


    if (x < nbCasesX && y < nbCasesY) {

      Loot l = (Loot)player.inventaire.grille[x][y];
      if (l != null) {
        println("coord sur inventory : " + x, y + " / Loot : " + l.nom + " : jeté");
        LootItem(l, x, y);
      } else {
        println("coord sur inventory : " + x, y + " / Pas de loot");
      }
    }
  }

  void LootItem(Loot l, int x, int y) {
    PVector posJete = player.pos.copy();
    PVector taille = PVector.random2D();

    taille.setMag(player.taille);
    posJete.add(taille);

    println("coord jeté : " + posJete);
    l.setPos(posJete.x, posJete.y);
    mapActif.entManager.addEntity(l);
    player.inventaire.grille[x][y] = null;
  }

  void Update() {
    player = (Player)camera.focus;

    nbCasesX = player.inventaire.grille.length;
    nbCasesY = player.inventaire.grille[0].length;
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
  ArrayList<Commande> AllCommandes;
  ArrayList<String> HistoriqueCommandes;
  float taillePol = 15, taille;
  boolean isWriting = false;
  String writeString = "";

  Console() {
    tabl = new ArrayList<String>();
    pos = new PVector();
    AllCommandes = new ArrayList<Commande>();
    HistoriqueCommandes = new ArrayList<String>();

    //COMMANDES

    AllCommandes.add(new Commande("ping") {
      boolean Action(String comm) {
        println("Console ping");
        tabl.add("ping");
        return true;
      }
    }
    );

    AllCommandes.add(new Commande("coucou") {
      boolean Action(String comm) {
        println("Console coucou");
        tabl.add("ping");
        return true;
      }
    }
    );

    AllCommandes.add(new Commande("summon") {
      boolean Action(String comm) {

        String[] instructions = split(comm, ' ');

        switch(instructions[1]) {
        case "module":
          if (instructions.length == 4) {

            ModuleSocle m = new ModuleSocle(int(instructions[2]), int(instructions[3]));
            mapActif.entManager.addEntity(m);
            return true;
          }
          return false;

        case "enemy":
          break;
        }

        Entity e = new Entity();

        mapActif.entManager.addEntity(e);

        return true;
      }
    }
    );
  }

  void DisplayConsole() {
    if (taille > 0) {
      push();
      rectMode(CORNER);
      noStroke();
      fill(0, 0, 0, 70);
      rect(pos.x, pos.y, width, taille);

      textSize(taillePol);
      textAlign(LEFT);
      fill(255);

      for (int i=0; i<tabl.size(); i++) {
        text(tabl.get(i), 50, i*taillePol+taillePol);
      }

      pop();

      tabl.clear();
    }
  }

  void DisplayUpdateWriting() {

    if (keyPressed && key == '\n' && writeString != "") {
      ProcessCommande(writeString);
    }

    push();
    translate(0, -10);
    rectMode(CORNER);
    noStroke();
    fill(0, 0, 0, 70);
    rect(pos.x, height, width, -(HistoriqueCommandes.size()+1)*taillePol);

    textSize(taillePol);
    textAlign(LEFT);
    fill(255);

    for (int i=0; i<HistoriqueCommandes.size(); i++) {
      text(HistoriqueCommandes.get(i), 50, height-(HistoriqueCommandes.size()-i-1)*taillePol-taillePol);
    }

    text(writeString, 50, height);

    pop();
  }

  void Write(char c) {
    writeString += c;
  }

  void ProcessCommande(String str) {

    HistoriqueCommandes.add(str);

    String comm = split(str, ' ')[0];

    for (Commande commande : AllCommandes) {

      if (commande.commande.equals(comm)) {
        if (commande.Action(str)) {
          println("Executed", str);
        }
      }
    }

    writeString = "";
  }

  void add(String ajout) {
    tabl.add(ajout);
    taille = tabl.size() * taillePol;
  }
  void add(float ajout) {
    tabl.add(String.valueOf(ajout));
    taille = tabl.size() * taillePol;
  }


  class Commande {
    String commande;

    Commande(String c) {
      commande = c;
    }

    boolean Action(String comm) {
      return true;
    }
  }
}









//======================================================================





class HUDAlerteManager {

  ArrayList<HUDAlerte> AllHUDAlerte;
  float hauteur = 50;

  HUDAlerteManager() {
    AllHUDAlerte = new ArrayList<HUDAlerte>();
  }

  void DisplayUpdate() {

    push();

    translate(
      camera.focus.pos.x * mapActif.tailleCase
      ,
      camera.focus.pos.y * mapActif.tailleCase
      - camera.focus.taille * mapActif.tailleCase/2
      );

    for (int i=0; i<AllHUDAlerte.size(); i++) {
      HUDAlerte h = AllHUDAlerte.get(i);
      push();
      translate(0, -hauteur*((millis() - h.timer)/h.timeTillDeath));
      h.Display();
      pop();
      if (h.mort) AllHUDAlerte.remove(i);
    }

    pop();
  }

  void add(String str) {
    AllHUDAlerte.add(new HUDAlerte(str));
  }

  class HUDAlerte {
    String text;
    float timer, timeTillDeath = 2000;
    boolean mort;
    color couleur = color(255);

    HUDAlerte(String str) {
      timer = millis();
      text = str;
    }

    void Display() {
      if (millis() - timer > timeTillDeath) mort = true;

      push();
      textAlign(CENTER);
      textSize(15);
      fill(couleur, 255*(1-(millis() - timer)/timeTillDeath));
      text(text, 0, 0);
      pop();
    }
  }
}
