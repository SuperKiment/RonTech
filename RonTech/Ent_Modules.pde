class ModuleSocleTourelle implements IModule {

  int taillePuissance;
  PVector pos;
  Player player;
  float speed, taille, distance = 50, ori;
  color couleur;
  Tourelle tourelle;

  ModuleSocleTourelle(Player p) {
    Constructor(p);
  }

  ModuleSocleTourelle(Player p, float t, float o, float s, float d) {
    Constructor();
    player = p;
    taille = t;
    ori = o;
    speed = s;
    distance = d;
    pos.x = p.pos.x;
    pos.y = p.pos.y;
  }

  void Constructor(Player p) {
    pos = new PVector();
    player = p;    
    pos.x = player.pos.x;
    pos.y = player.pos.y;    
    ori = random(-PI*2, PI*2);
    taille = 50;
    speed = 5;
    couleur = color(255, 255, 255);
    distance = 2;
    tourelle = new Tourelle(this);
  }

  void Constructor() {
    pos.x = player.pos.x;
    pos.y = player.pos.y;    
    ori = random(-PI*2, PI*2);
    taille = 50;
    speed = 5;
    couleur = color(255, 255, 255);
    distance = 2;
    tourelle = new Tourelle(this);
  }

  void Update(Player p) {
    player = p;
    pos.lerp(p.pos, speed * mapActif.timeThreadUpdate/timeFactor);
    tourelle.Update();
  }

  void Utiliser() {
    Projectile p = new Projectile(player, tourelle.pos, tourelle.ori);
    
    mapActif.AllAttacks.add(p);
    
    
    println("Tir de "+player.name +" / Module : "+ this.getClass());
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
    ellipse(GrToSn(distance), 0, taille/2, taille/2);
    pop();

    push();
    fill(0);
    text(taille + " " + PosOnScr().x + " " + PosOnScr().y, PosOnScr().x, PosOnScr().y);
    pop();
    
    tourelle.Display();
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

  int getTaille() {
    return 0;
  }

  PVector getPos() {
    PVector rPos = pos.copy();
    return rPos;
  }
}


/*
class ModuleBase implements IModule {
 
 int taillePuissance;
 PVector pos;
 Player player;
 float speed, taille, distance = 50, ori;
 color couleur;
 
 ModuleBase(Player p) {
 Constructor(p);
 }
 
 ModuleBase(Player p, float t, float o, float s, float d) {
 Constructor();
 player = p;
 taille = t;
 ori = o;
 speed = s;
 distance = d;
 pos.x = p.pos.x;
 pos.y = p.pos.y;
 }
 
 void Constructor(Player p) {
 pos = new PVector();
 player = p;    
 pos.x = player.pos.x;
 pos.y = player.pos.y;    
 ori = random(-PI*2, PI*2);
 taille = 50;
 speed = 5;
 couleur = color(255, 255, 255);
 distance = 2;
 }
 
 void Constructor() {
 pos.x = player.pos.x;
 pos.y = player.pos.y;    
 ori = random(-PI*2, PI*2);
 taille = 50;
 speed = 5;
 couleur = color(255, 255, 255);
 distance = 2;
 }
 
 void Update(Player p) {
 player = p;
 pos.lerp(p.pos, speed * mapActif.timeThreadUpdate/timeFactor);
 }
 
 void Utiliser() {
 couleur = 0;
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
 ellipse(GrToSn(distance), 0, taille/2, taille/2);
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
 
 int getTaille() {
 return 0;
 }
 
 PVector getPos() {
 PVector rPos = pos.copy();
 return rPos;
 }
 }
 */

class Tourelle {

  IModule module;
  PVector pos, ori;
  float taille = 20, widthCanon = 10;

  Tourelle(IModule m) {
    module = m;
    pos = m.PosOnScr().copy();
    ori = new PVector();
  }

  void Update() {
    pos = module.PosOnScr().copy();
    ori = new PVector(MousePosScreen().x-pos.x, MousePosScreen().y-pos.y);
    ori.setMag(taille);
  }

  void Display() {
    push();
    translate(pos.x, pos.y);
    strokeWeight(widthCanon);
    line(0, 0, ori.x, ori.y);
    pop();
  }
}
