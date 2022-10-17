//Interface pour display les Entites à proximite

interface Entity {
  PVector getPos();
}

interface IModule {

  void Constructor(Player p);
  void Update(Player p);
  void Display();
  PVector PosOnScr();

  void Utiliser();
  void setOri(float o);

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
