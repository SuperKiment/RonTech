interface Entity {
  PVector getPos();
}





class Player implements Entity {
  PVector pos;

  Player(int x, int y) {
    pos = new PVector(x, y);
  }
  Player() {
    pos = new PVector(int(random(0, 10)), int(random(0, 10)));
  }

  PVector getPos() {
    return pos;
  }
}






class Enemy implements Entity {
  PVector pos;

  Enemy(int x, int y) {
    pos = new PVector(x, y);
  }
  Enemy() {
    pos = new PVector(int(random(0, 10)), int(random(0, 10)));
  }

  PVector getPos() {
    return pos;
  }
}





void DetectCollisions(ArrayList<Entity> array1, ArrayList<Entity> array2) {
  int[] 
}





void setup() {
  ArrayList<Entity> AllPlayers = new ArrayList<Entity>();
  ArrayList<Entity> AllEnemies = new ArrayList<Entity>();

  AllPlayers.add(new Player());

  for (int i=0; i<10; i++) {
    AllPlayers.add(new Player());
  }

  for (int i=0; i<10; i++) {
    AllEnemies.add(new Enemy());
  }


  for (Entity e : AllPlayers) {
    println(e.getClass(), e.getPos());
  }
  
  for (Entity e : AllEnemies) {
    println(e.getClass(), e.getPos());
  }

  DetectCollisions(AllPlayers, AllEnemies);
}
