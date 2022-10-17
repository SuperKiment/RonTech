class ModuleSocleTourelle implements IModule {

  int taillePuissance;
  PVector pos;
  Player player;
  float speed = 4, taille, distance = 50, ori;
  float speedRange = 1.5;
  color couleur;
  Tourelle tourelle;

  ModuleSocleTourelle(Player p) {
    Constructor(p);
  }

  ModuleSocleTourelle(Player p, float t, float o, float s, float d) {
    Constructor(p);
    taille = t;
    ori = o;
    speed = random(s/speedRange, s*speedRange);
    distance = d;
    pos = p.pos.copy();
  }

  void Constructor(Player p) {
    pos = new PVector();
    player = p;    
    pos.x = player.pos.x;
    pos.y = player.pos.y;    
    ori = random(-PI*2, PI*2);
    taille = 50;
    speed = random(speed/speedRange, speed*speedRange);
    couleur = color(255, 255, 255);
    distance = 2;
    tourelle = new Tourelle(this, player);
  }

  void Update(Player p) {
    player = p;
    pos.lerp(p.pos, speed * mapActif.timeThreadUpdate/timeFactor);
    tourelle.Update();
  }

  void Utiliser() {

    tourelle.Utiliser();


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

    if (gameManager.debug) {
      push();
      fill(0);
      text(taille + " " + PosOnScr().x + " " + PosOnScr().y, PosOnScr().x, PosOnScr().y);
      pop();
    }

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

  void setOri(float o) {
    ori = o;
  }
}




//===================================================================================================







class ModuleBouclier implements IModule {

  int taillePuissance;
  PVector pos;
  Player player;
  float speed = 4, taille, distance = 50, ori;
  float speedRange = 1.5;
  color couleur;
  Bouclier bouclier;

  ModuleBouclier(Player p) {
    Constructor(p);
  }

  ModuleBouclier(Player p, float t, float o, float s, float d) {
    Constructor(p);
    taille = t;
    ori = o;
    speed = random(s/speedRange, s*speedRange);
    distance = d;
    pos = p.pos.copy();
  }

  void Constructor(Player p) {
    pos = new PVector();
    player = p;    
    pos.x = player.pos.x;
    pos.y = player.pos.y;    
    ori = random(-PI*2, PI*2);
    taille = 50;
    speed = random(speed/speedRange, speed*speedRange);
    couleur = color(255, 255, 255);
    distance = 2;
    bouclier = new Bouclier(this, player);
  }

  void Update(Player p) {
    player = p;
    pos.lerp(p.pos, speed * mapActif.timeThreadUpdate/timeFactor);
    bouclier.Update();
  }

  void Utiliser() {

    bouclier.Utiliser();


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

    if (gameManager.debug) {
      push();
      fill(0);
      text(taille + " " + PosOnScr().x + " " + PosOnScr().y, PosOnScr().x, PosOnScr().y);
      pop();
    }

    bouclier.Display();
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

  void setOri(float o) {
    ori = o;
  }
}










//===================================================================================================
//===================================================================================================
//===================================================================================================
//===================================================================================================











class Tourelle {

  IModule module;
  PVector pos, ori, oriC;
  float taille = 20, widthCanon = 10, speed = 1, cooldown = 1000, timer = 0, 
    cooldownRange = 5;
  Player player;

  Tourelle(IModule m, Player p) {
    module = m;
    pos = m.PosOnScr().copy();
    ori = new PVector();
    player = p;
  }

  void Update() {
    pos = module.PosOnScr().copy();
    oriC = new PVector(MousePosScreen().x-pos.x, MousePosScreen().y-pos.y);
    oriC.setMag(taille);

    ori.lerp(oriC, speed*time.getDeltaFrames());

    //ori = new PVector(MousePosScreen().x-pos.x, MousePosScreen().y-pos.y);

    ori.setMag(taille);
  }

  void Display() {
    push();
    translate(pos.x, pos.y);
    strokeWeight(widthCanon);
    line(0, 0, ori.x, ori.y);
    pop();
  }

  void Utiliser() {
    boolean tir = false;

    if (millis() - timer >= random(cooldown/cooldownRange, cooldown*cooldownRange)) {
      tir = true;
      timer = millis();
    } 

    if (tir) {
      Projectile p = new Projectile(player, pos, ori);
      mapActif.AllAttacks.add(p);
    }
  }
}







//===================================================================================================






class Bouclier {

  IModule module;
  PVector pos, ori, oriC;
  float taille = 20, widthBouclier = 10, speed = 1;
  Player player;

  Bouclier(IModule m, Player p) {
    module = m;
    pos = m.PosOnScr().copy();
    ori = new PVector();
    player = p;
  }

  void Update() {
    pos = module.PosOnScr().copy();
    oriC = new PVector(MousePosScreen().x-pos.x, MousePosScreen().y-pos.y);
    oriC.setMag(taille);

    ori.lerp(oriC, speed*time.getDeltaFrames());

    //ori = new PVector(MousePosScreen().x-pos.x, MousePosScreen().y-pos.y);

    ori.setMag(taille);
  }

  void Display() {
    push();
    translate(pos.x, pos.y);
    strokeWeight(widthBouclier);
    line(0, 0, ori.x, ori.y);
    strokeWeight(taille);
    line(ori.x, ori.y, ori.x, ori.y);
    pop();
  }

  void Utiliser() {
  }
}
