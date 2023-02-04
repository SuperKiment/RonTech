static public class Entity {
  public PVector pos, vel, vis;
  public float baseHP = 50, HP = 50, taille = 1;
  public int nbModules = 8;
  public boolean isDisplay = false,
    isMort = false,
    isModule = false,
    isStatic = false,
    isAttack = false;
  public ModuleManager moduleManager;




  public Entity() {
    Constructor();
  }

  public Entity(float x, float y) {
    Constructor();
    pos = new PVector(x, y);
  }

  public void Constructor() {
    vis = new PVector();
    pos = new PVector();
    vel = new PVector();
    

  }


  public void Update() {
  }

  public void Display() {
  }

  void Viser(float x, float y) {
    vis = new PVector(x, y);
  }
  void Viser(PVector p) {
    vis = p.copy();
  }

  //GET

  public PVector getPos() {
    return pos;
  }

  public PVector getVel() {
    return vel;
  }

  public float getTaille() {
    return taille;
  }

  public float GetHP() {
    return HP;
  }

  public float GetBaseHP() {
    return baseHP;
  }

  public boolean isMort() {
    return isMort;
  }

  public boolean isDisplay() {
    return isDisplay;
  }

  public int getNbModules() {
    return nbModules;
  }

  public void getInterfaces() {
  }

  public String toString(Entity me) {
    return "Entity : " + getObjectClassName(me) + " / pos : " + pos;
  }

  public JSONObject getJSON(Entity me) {
    JSONObject json = new JSONObject();

    json.setString("Class", getObjectClassName(me));
    json.setFloat("pos.x", pos.x);
    json.setFloat("pos.y", pos.y);
    json.setFloat("taille", taille);
    json.setFloat("HP", HP);
    json.setFloat("baseHP", baseHP);
    json.setInt("nbModules", nbModules);
    json.setBoolean("isMort", isMort);
    json.setBoolean("isStatic", isStatic);

    return json;
  }

  //SET

  public void setIsDisplay(boolean b) {
    isDisplay = b;
  }

  public void setPos(PVector p) {
    pos = p.copy();
  }

  public void setVel(PVector p) {
    vel = p.copy();
  }

  public void setTaille(float t) {
    taille = t;
  }

  public void setHP(float h) {
    HP = h;
  }

  public void setBaseHP(float h) {
    baseHP = h;
  }

  public void setMort(boolean b) {
    isMort = b;
  }

  public void setNbModules(int n) {
    nbModules = n;
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
  void setModule(ModuleSocle m, Entity p);
}
