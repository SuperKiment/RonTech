class ModuleManager {

  ArrayList<ModuleSocle> AllModules = new ArrayList<ModuleSocle>();
  int maxModules = 8;
  Entity parent;

  ModuleManager(Entity p) {
    parent = p;
  }

  void Update() {
    for (int i = 0; i < AllModules.size(); i++) {
      ModuleSocle m = AllModules.get(i);
      m.Update();
    }
  }

  void Utiliser() {
    for (ModuleSocle m : AllModules) {
      m.Utiliser();
    }
  }

  // m.setOri((AllModules.size()-1) * (TWO_PI/maxModules));

  void suppModule(ModuleSocle m) {
    for (int i=0; i<AllModules.size(); i++) {
      if (m == AllModules.get(i)) AllModules.remove(i);
    }
  }

  boolean addModule(ModuleSocle m) {
    if (AllModules.size()+1 < maxModules) {
      AllModules.add(m);
      return true;
    }
    return false;
  }
}

//=========================================================================================

/*
Le ModuleSocle est le socle qui contient la tourelle et qui gère les liaisons
Il récup aussi l'utilisation pour pouvoir avoir n'importe quoi dessus genre un four ou une tourelle etc.
*/
class ModuleSocle extends Entity {
  PVector posCible;
  float  speed = 0.007, maxSpeed;
  Entity liaison;
  Entity[] liaisons;//A IMPLEMENTER : AVOIR PLUSIEURS LIAISONS
  float distance = 2, ori;
  float speedRange = 1.5;
  color couleur;
  InterfaceOnModule onModule;

  ModuleSocle() {
    Constructor();
  }
  ModuleSocle(float x, float y) {
    Constructor();
    pos = new PVector(x, y);
  }

  void Constructor() {
    super.Constructor();
    maxSpeed = speed;
    pos = new PVector(5, 5);
    vel = new PVector();
    posCible = new PVector(0, 0);
    isModule = true;
    couleur = color(255, 255, 255);

    onModule = new Tourelle(this, liaison);
  }

  void Update() {
    CollisionEntity(this, taille, pos);

    if (liaison != null) {
      PVector cible = liaison.getPos().copy();
      cible.add(posCible);
      PVector fpos = pos.copy();

      fpos.lerp(cible, speed);

      PVector depl = fpos.copy();
      depl.sub(pos);
      if (depl.mag() > maxSpeed) depl.setMag(maxSpeed);

      pos.add(depl);
    }
    if (onModule != null) onModule.Update();
  }

  void Display() {

    if (liaison != null) {
      push();
      stroke(0);
      strokeWeight(5);//Ligne

      line(GrToSn(pos.x), GrToSn(pos.y), GrToSn(liaison.getPos().x), GrToSn(liaison.getPos().y));

      pop();
    }


    push();
    translate(GrToSn(pos.x), GrToSn(pos.y));
    rotate( -ori);
    fill(couleur);  //Rond
    ellipse(0, 0, GrToSn(taille), GrToSn(taille));
    ellipse(0, 0, GrToSn(taille)/2, GrToSn(taille)/2);
    if (onModule != null) onModule.Display();
    pop();

    if (gameManager.debug) {
      push();
      fill(0);
      text(taille + " " + PosOnScr().x + " " + PosOnScr().y, PosOnScr().x, PosOnScr().y);
      pop();
    }
  }


  void Utiliser() {
    if (onModule != null) onModule.Utiliser();
  }

  PVector PosOnScr() {

    PVector posS = new PVector();
    PVector ajout = new PVector(1, 0);

    ajout = Rotate(ajout, -ori);
    ajout.setMag(GrToSn(distance));

    posS = GrToSn(pos.copy());

    posS.add(ajout);
    return posS;
  }

  void setOri(float o) {
    ori = o;
  }

  void setOnModule(InterfaceOnModule om) {
    onModule = om;
  }

  void setLiaison(Entity l) {

    PVector o = new PVector(pos.x - l.getPos().x, pos.y - l.getPos().y);
    o.setMag(distance + l.getTaille()/2);

    posCible = o.copy();

    liaison = l;
    if (onModule != null) onModule.setModule(this, l);
  }

  void SuppLiaison() {
    liaison = null;
    onModule.setModule(this, null);
  }
}





//======================================ON MODULE






class OnModule implements InterfaceOnModule {

  ModuleSocle module;
  PVector pos, ori, oriC;
  float taille = 0.5, widthCanon = 10, speed = 1;
  Entity parent;

  OnModule(ModuleSocle m, Entity p) {
    Constructor();
    module = m;
    pos = m.PosOnScr().copy();
    parent = p;
  }

  OnModule() {
    Constructor();
  }

  void Constructor() {
    ori = new PVector();
    oriC = new PVector(1, 0);
  }

  void Update() {
    pos = module.PosOnScr().copy();

    if (parent != null) {
      oriC = SnToGr(parent.vis.copy());
      oriC.sub(module.pos);
    } else if (oriC == new PVector(0, 0, 0)) oriC = new PVector(1, 0);
    //ori = new PVector(MousePosScreen().x-pos.x, MousePosScreen().y-pos.y);

    oriC.setMag(GrToSn(taille));

    ori.lerp(oriC, speed*time.getDeltaFrames());

    ori.setMag(GrToSn(taille));
  }

  void Display() {
    push();
    //line(0, 0, ori.x, ori.y);
    rotate(ori.heading());
    rect(ori.mag(), 0, ori.mag(), ori.mag()/2);
    pop();
  }

  void Utiliser() {
  }

  void setModule(ModuleSocle m, Entity p) {
    module = m;
    pos = m.PosOnScr().copy();
    parent = p;
  }
}








//-----------------------------------------------------------------------------------------









class Tourelle extends OnModule {

  float cooldown = 250, timer = 0,
    cooldownRange = 2, imprecision = 0, nbBalles = 1;

  Tourelle(ModuleSocle m, Entity p) {
    super(m, p);
  }

  void Constructor() {
    super.Constructor();
    if (imprecision == 0) imprecision = 1-(cooldown/100);
  }


  void Utiliser() {
    boolean tir = false;

    if (millis() - timer >= random(cooldown/cooldownRange, cooldown*cooldownRange)) {
      tir = true;
      timer = millis();
    }

    if (tir) {
      Tirer();
    }
  }

  void Tirer() {
    for (int i =0; i<nbBalles; i++) {
      
      PVector parentVel = parent.getVel().copy();
      PVector projPos = module.pos.copy();
      PVector dirProj = ori.copy();
      dirProj.setMag((module.getTaille()/2 + 0.5)*1.05);
      projPos.add(dirProj);
      
      ori.lerp(PVector.random2D(), imprecision);
      
      Projectile p = new Projectile(parent, projPos, ori, parentVel);
      //println("Tir :", pos, ori, playerVel);
      mapActif.entManager.addEntity(p);
    }
  }
}







//===================================================================================================







class Bouclier extends OnModule {

  float widthBouclier = 10, speed = 0.25;

  Bouclier(ModuleSocle m, Entity p) {
    super(m, p);
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

//===============================================================DEPRECIE
/*
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
 
 
 PVector posS = new PVector();
 PVector ajout = new PVector(1, 0);
 
 ajout = Rotate(ajout, -ori);
 ajout.setMag(GrToSn(distance));
 
 posS = GrToSn(pos.copy());
 
 posS.add(ajout);
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
 */





//===================================================================================================
//===================================================================================================
//===================================================================================================
//===================================================================================================
