class Entity {
  PVector pos, vel;
  float baseHP = 50, HP = 50, taille = 1;
  boolean isDisplay = false,
    isMort = false,
    isModule = false,
    isStatic = false;

  Entity() {
    pos = new PVector(5, 5);
    vel = new PVector();
  }

  void Update() {
  }

  void Display() {
    push();
    translate(GrToSn(pos.x), GrToSn(pos.y));
    ellipse(0, 0, GrToSn(taille), GrToSn(taille));
    pop();
  }

  PVector getPos() {
    return pos;
  }

  PVector getVel() {
    return vel;
  }

  float getTaille() {
    return taille;
  }

  float GetHP() {
    return HP;
  }

  boolean isMort() {
    return false;
  }

  boolean isDisplay() {
    return isDisplay;
  }

  void setIsDisplay(boolean b) {
    isDisplay = b;
  }

  JSONObject getJSON() {
    JSONObject json = new JSONObject();

    json.setString("Class", getObjectClassName(this));
    json.setFloat("pos.x", pos.x);
    json.setFloat("pos.y", pos.y);
    json.setFloat("taille", taille);
    json.setFloat("HP", HP);
    json.setFloat("baseHP", baseHP);

    return json;
  }
}



//========================INTERFACES

interface Damageable {
  void GetDamage(float damage);
  float GetHP();
  void DisplayHealthBar();
}

interface IModule {

  void Constructor(Entity p);
  void Update(Entity p);
  void Display();
  PVector PosOnScr();

  void Utiliser();
  void setOri(float o);
  void setOnModule(OnModule om);

  int getTaille();
  PVector getPos();
}

interface Attack {
  PVector getPos();
  float getTaille();
  void Display();
  void Update();
  boolean isMort();
}

interface OnModule {
  void Utiliser();
  void Display();
  void Update();
  void setModule(IModule m, Entity p);
}
