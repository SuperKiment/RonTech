class ModuleTest implements IModule {

  int taillePuissance;
  PVector pos;
  Player player;
  float speed, taille, distance = 50, ori;
  color couleur;

  ModuleTest() {
    Constructor();
  }

  ModuleTest(Player p, float t, float o, float s, float d) {
    Constructor();
    player = p;
    taille = t;
    ori = o;
    speed = s;
    distance = d;
    pos.x = p.pos.x;
    pos.y = p.pos.y;
  }

  void Constructor() {
    player = new Player();    
    pos = player.pos;
    taille = 50;
    speed = 0.02;
    couleur = color(255, 255, 255);
    distance = 2;
  }

  void Update(PVector p) {
    pos.lerp(p, speed * time.getDeltaFrames());
  }

  void Display() {

    if (player != null) {
      push();
      stroke(0);
      strokeWeight(5);//Ligne

      line(PosOnScr().x, PosOnScr().y, GrToSn(player.pos.x), GrToSn(player.pos.y));

      pop();
    }


    push();
    translate(GrToSn(pos.x), GrToSn(pos.y));
    rotate( -ori);
    fill(couleur);  //Rond
    ellipse(GrToSn(distance), 0, taille, taille);
    pop();

    push();
    fill(0);
    text(taille + " " + PosOnScr().x + " " + PosOnScr().y, PosOnScr().x, PosOnScr().y);
    pop();
  }

  PVector PosOnScr() {
    PVector posS = new PVector();
    PVector ajout = new PVector(1, 0);

    ajout = Rotate(ajout, -ori);
    ajout.setMag(distance);

    posS = pos.copy();

    posS.add(ajout);
    posS.mult(mapActif.tailleCase);
    return posS;
  }
  
  int getTaille(){return 0;}
}

interface IModule {

  void Constructor();
  void Update(PVector p);
  void Display();
  PVector PosOnScr();

  int getTaille();
}
