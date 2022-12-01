class ModuleSocleTourelle implements IModule {

  PVector pos;
  Player player;
  float speed = 4, taille, distance = 50, ori;
  float speedRange = 1.5;
  color couleur;
  OnModule onModule;


  ModuleSocleTourelle(Player p) {
    Constructor(p);
  }

  ModuleSocleTourelle(Player p, OnModule m) {
    Constructor(p, m);
  }

  ModuleSocleTourelle(Player p, float t, float o, float s, float d, OnModule m) {
    Constructor(p, m);
    taille = t;
    ori = o;
    speed = random(s/speedRange, s*speedRange);
    distance = d;
    pos = p.pos.copy();
  }

  void Constructor(Player p, OnModule m) {
    pos = new PVector();
    player = p;    
    pos.x = player.pos.x;
    pos.y = player.pos.y;    
    ori = random(-PI*2, PI*2);
    taille = 50;
    speed = random(speed/speedRange, speed*speedRange);
    couleur = color(255, 255, 255);
    distance = 2;
    onModule = m;
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
  }

  void Update(Player p) {
    player = p;
    pos.lerp(p.pos, speed * mapActif.timeThreadUpdate/timeFactor);
    if (onModule != null) onModule.Update();
  }

  void Utiliser() {

    if (onModule != null) onModule.Utiliser();
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

    if (onModule != null) onModule.Display();
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

  void setOnModule(OnModule om) {
    onModule = om;
  }
}






//===================================================================================================
//===================================================================================================
//===================================================================================================
//===================================================================================================





class OnModuleC implements OnModule {

  IModule module;
  PVector pos, ori, oriC;
  float taille = 20, widthCanon = 10, speed = 1;
  Player player;

  OnModuleC(IModule m, Player p) {
    module = m;
    pos = m.PosOnScr().copy();
    ori = new PVector();
    player = p;
  }

  OnModuleC() {
    ori = new PVector();
  }

  void Update() {
    pos = module.PosOnScr().copy();

    oriC = new PVector(MousePosScreen().x-pos.x, MousePosScreen().y-pos.y);
    //ori = new PVector(MousePosScreen().x-pos.x, MousePosScreen().y-pos.y);
    oriC.setMag(taille);

    ori.lerp(oriC, speed*time.getDeltaFrames());

    ori.setMag(taille);
  }

  void Display() {
    push();
    translate(pos.x, pos.y);
    //line(0, 0, ori.x, ori.y);
    rotate(ori.heading());
    rect(ori.mag(), 0, ori.mag(), 10);
    pop();
  }

  void Utiliser() {
  }

  void setModule(IModule m, Player p) {
    module = m;
    pos = m.PosOnScr().copy();
    player = p;
  }
}








//-----------------------------------------------------------------------------------------









class Tourelle extends OnModuleC {

  float cooldown = 500, timer = 0, 
    cooldownRange = 5, imprecision, nbBalles = 1;

  Tourelle(IModule m, Player p) {
    imprecision = 1-(cooldown/10);
    module = m;
    pos = m.PosOnScr().copy();
    ori = new PVector();
    player = p;
  }

  Tourelle() {
    imprecision = 1-(cooldown/10);
    ori = new PVector();
  }


  void Utiliser() {
    boolean tir = false;

    if (millis() - timer >= random(cooldown/cooldownRange, cooldown*cooldownRange)) {
      tir = true;
      timer = millis();
    } 

    if (tir) {
      for (int i =0; i<nbBalles; i++) {
        PVector a = player.vel.copy();
        a = GrToSn(a);
        ori.lerp(PVector.random2D(), imprecision);
        Projectile p = new Projectile(player, SnToGr(pos), ori, a);
        mapActif.AllAttacks.add(p);
        println(player.vel);    
        println("Tir de "+player.name +" / Module : "+ this.getClass());
      }
    }
  }
}







//===================================================================================================







class Bouclier extends OnModuleC {

  float widthBouclier = 10, speed = 0.25;

  Bouclier(IModule m, Player p) {
    module = m;
    pos = m.PosOnScr().copy();
    ori = new PVector();
    player = p;
  }

  Bouclier() {
    ori = new PVector();
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
