class Particles {
  ArrayList<Particle> AllParticles;
  PVector pos;

  Particles(int puissance, PVector p) {
    pos = p.copy();
    AllParticles = new ArrayList<Particle>();

    for (int i=0; i<puissance; i++) {
      AllParticles.add(new Particle(ParticleType.Circle, 10, pos.copy(), puissance/5));
    }
  }

  void Display() {
    for (int i=0; i<AllParticles.size(); i++) {
      Particle p = AllParticles.get(i);
      p.Update();
      p.Display();
      
      if (p.isMort) AllParticles.remove(i);
    }
  }
}

class Particle {

  ParticleType type;
  PVector pos, basePos, ori;
  float taille, baseVel, vel, damp;
  boolean isMort = false;

  Particle(ParticleType t, float ta, PVector p, float bV) {
    type = t;
    taille = ta;
    pos = GrToSn(p.copy());

    baseVel = bV;
    vel = random(baseVel/2, baseVel*2);

    ori = PVector.random2D();
    ori.setMag(1);

    damp = random(0.01, 0.1);
  }

  void Update() {
    vel = lerp(vel, 0, damp);
    ori.setMag(vel);

    pos.add(ori);
    
    if (vel < 0.1)isMort = true;
  }

  void Display() {
    push();

    translate(pos.x, pos.y);

    rectMode(CENTER);

    fill(255);
    strokeWeight(2);
    stroke(0);

    switch(type) {

    case Square :
      rect(0, 0, taille, taille);
      break;

    case Circle :
      ellipse(0, 0, taille, taille);
      break;
    }

    pop();
  }
}

enum ParticleType {
  Square, Circle
}
