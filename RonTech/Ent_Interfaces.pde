//Interface pour display les Entites à proximite

interface Entity {
  PVector getPos();
}

interface Damageable {
  void GetDamage(float damage);
  float GetHP();
  void DisplayHealthBar();
}

interface IModule {

  void Constructor(Player p);
  void Update(Player p);
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
  void setModule(IModule m, Player p);
}
