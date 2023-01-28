ArrayList<Entity> AllEntities;


void setup() {

  size(1000, 1000);
  background(0);

  AllEntities = new ArrayList<Entity>();

  AllEntities.add(new Player(200, 200));
  AllEntities.add(new Enemy(400, 220));
  AllEntities.add(new Enemy(400, 320, 100));
}

void draw() {
  background(0);

  for (Entity e : AllEntities) {
    e.Update();
    e.Display();
  }
}
