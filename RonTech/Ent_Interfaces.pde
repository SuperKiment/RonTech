//Interface pour display les Entites à proximite

interface Entity {
  PVector getPos();
  PVector getVel();
  void Update();
  void Display();
  boolean isDisplay();
  boolean isMort();
  void setIsDisplay(boolean b);
  JSONObject getJSON();
  float getTaille();
}

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
