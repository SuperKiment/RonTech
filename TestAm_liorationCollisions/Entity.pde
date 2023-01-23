interface Entity {
  PVector getPos();
  float getTaille();
  void Update();
  void Display();
}


class Enemy implements Entity {
  PVector pos;
  float taille = 20;

  Enemy(int x, int y) {
    pos = new PVector(x, y);
  }
  Enemy(int x, int y, int t) {
    pos = new PVector(x, y);
    taille = t;
  }
  Enemy() {
    pos = new PVector(int(random(0, 10)), int(random(0, 10)));
  }

  void Update() {
  }

  void Display() {
    push();
    translate(pos.x, pos.y);
    fill(255);
    ellipse(0, 0, taille, taille);
    pop();
  }

  float getTaille() {
    return taille;
  }

  PVector getPos() {
    return pos;
  }
}



class Player implements Entity {
  PVector pos;
  float taille = 50, speed = 2;

  Player(int x, int y) {
    pos = new PVector(x, y);
  }
  Player() {
    pos = new PVector(int(random(0, 10)), int(random(0, 10)));
  }

  void Update() {
    if (keyPressed) {
      if (key == 'z') pos.y -= speed;
      if (key == 'q') pos.x -= speed;
      if (key == 's') pos.y += speed;
      if (key == 'd') pos.x += speed;
    }
    for (Entity e : AllEntities) {
      if (e != this) {
        float d = dist(pos.x, pos.y, e.getPos().x, e.getPos().y);
        if (d < (taille+e.getTaille())/2) {
          PVector add = new PVector(pos.x - e.getPos().x, pos.y - e.getPos().y);
          float mag = -(d - (taille + e.getTaille())/2);
          add.setMag(mag);
          pos.add(add);
        }
      }
    }
  }

  void Display() {
    push();
    translate(pos.x, pos.y);
    fill(255);
    ellipse(0, 0, taille, taille);
    pop();
  }

  float getTaille() {
    return taille;
  }

  PVector getPos() {
    return pos;
  }

  void Collision() {
  }
}
