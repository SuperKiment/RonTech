class ModuleManager {

  ArrayList<IModule> AllModules = new ArrayList<IModule>();
  int maxModules = 8;
  Entity parent;

  ModuleManager(Entity p) {
    parent = p;
  }

  void Update() {
    for (int i = 0; i < AllModules.size(); i++) {
      IModule m = AllModules.get(i);
      m.Update(parent);
    }
  }

  void Display() {
    for (IModule m : AllModules) {
      m.Display();
    }
  }

  void Utiliser() {
    for (IModule m : AllModules) {
      m.Utiliser();
    }
  }

  void addModule(IModule m, OnModule om) {
    if (AllModules.size() < maxModules) {
      m.setOri((AllModules.size()-1) * (TWO_PI/maxModules));
      om.setModule(m, parent);
      m.setOnModule(om);
      AllModules.add(m);
    } else {
      println("Pla Impossible d'ajouter le module");
    }
  }
}

//=========================================================================================

class ModuleSocleTourelle implements IModule {

  PVector pos;
  Entity parent;
  float speed = 4, taille = 1, distance = 1, ori;
  float speedRange = 1.5;
  color couleur;
  OnModule onModule;


  ModuleSocleTourelle(Entity p) {
    Constructor(p);
  }

  ModuleSocleTourelle(Entity p, OnModule m) {
    Constructor(p, m);
  }

  ModuleSocleTourelle(Entity p, float t, float o, float s, float d, OnModule m) {
    Constructor(p, m);
    taille = t;
    ori = o;
    speed = random(s/speedRange, s*speedRange);
    distance = d;
    pos = p.getPos().copy();
  }

  void Constructor(Entity p, OnModule m) {
    pos = new PVector();
    parent = p;
    pos.x = parent.getPos().x;
    pos.y = parent.getPos().y;
    ori = random(-PI*2, PI*2);
    speed = random(speed/speedRange, speed*speedRange);
    couleur = color(255, 255, 255);
    distance = 2;
    onModule = m;
  }

  void Constructor(Entity p) {
    pos = new PVector();
    parent = p;
    pos.x = parent.getPos().x;
    pos.y = parent.getPos().y;
    ori = random(-PI*2, PI*2);
    speed = random(speed/speedRange, speed*speedRange);
    couleur = color(255, 255, 255);
    distance = 2;
  }

  void Update(Entity p) {
    parent = p;
    pos.lerp(p.getPos(), speed * mapActif.timeThreadUpdate/timeFactor);
    if (onModule != null) onModule.Update();
  }

  void Utiliser() {

    if (onModule != null) onModule.Utiliser();
  }

  void Display() {

    if (parent != null) {
      push();
      stroke(0);
      strokeWeight(5);//Ligne

      line(PosOnScr().x, PosOnScr().y, GrToSn(parent.getPos().x), GrToSn(parent.getPos().y));
      
      pop();
    }


    push();
    translate(GrToSn(pos.x), GrToSn(pos.y));
    rotate( -ori);
    fill(couleur);  //Rond
    ellipse(GrToSn(distance), 0, GrToSn(taille), GrToSn(taille));
    ellipse(GrToSn(distance), 0, GrToSn(taille)/2, GrToSn(taille)/2);
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
    
    println(frameCount);
    
    PVector posS = new PVector();
    PVector ajout = new PVector(1, 0);

    ajout = Rotate(ajout, -ori);
    ajout.setMag(distance);

    posS = GrToSn(pos.copy());

    posS.add(ajout);
    posS.mult(50);
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
  float taille = 0.5, widthCanon = 10, speed = 1;
  Entity parent;

  OnModuleC(IModule m, Player p) {
    module = m;
    pos = m.PosOnScr().copy();
    ori = new PVector();
    parent = p;
  }

  OnModuleC() {
    ori = new PVector();
  }

  void Update() {
    pos = module.PosOnScr().copy();

    oriC = new PVector(MousePosScreen().x-pos.x, MousePosScreen().y-pos.y);
    //ori = new PVector(MousePosScreen().x-pos.x, MousePosScreen().y-pos.y);
    oriC.setMag(GrToSn(taille));

    ori.lerp(oriC, speed*time.getDeltaFrames());

    ori.setMag(GrToSn(taille));
  }

  void Display() {
    push();
    translate(pos.x, pos.y);
    //line(0, 0, ori.x, ori.y);
    rotate(ori.heading());
    rect(ori.mag(), 0, ori.mag(), ori.mag()/2);
    pop();
  }

  void Utiliser() {
  }

  void setModule(IModule m, Entity p) {
    module = m;
    pos = m.PosOnScr().copy();
    parent = p;
  }
}








//-----------------------------------------------------------------------------------------









class Tourelle extends OnModuleC {

  float cooldown = 250, timer = 0,
    cooldownRange = 2, imprecision = 0, nbBalles = 1;

  Tourelle(IModule m, Player p) {
    Constructor();
    module = m;
    pos = m.PosOnScr().copy();
    parent = p;
  }

  Tourelle() {
    Constructor();
  }

  void Constructor() {
    if (imprecision == 0) imprecision = 1-(cooldown/100);
    ori = new PVector();
  }


  void Utiliser() {
    boolean tir = false;

    if (millis() - timer >= random(cooldown/cooldownRange, cooldown*cooldownRange)) {
      tir = true;
      timer = millis();
    }

    if (tir) {
      //for (int i =0; i<nbBalles; i++) {
      PVector parentVel = parent.getVel().copy();
      ori.lerp(PVector.random2D(), imprecision);
      Projectile p = new Projectile(parent, SnToGr(pos), ori, parentVel);
      //println("Tir :", pos, ori, playerVel);
      mapActif.entManager.addEntity(p);
      //}
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
    parent = p;
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
