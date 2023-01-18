HUD hud;

void setup() {
  size(1000, 1000);
  surface.setResizable(true);
  surface.setTitle("Azy crée des choses");
  
  hud = new HUD();
  
  background(0);
  fill(100);
  stroke(255);
  rectMode(CENTER);
}

void draw() {
  background(0);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
  hud.Update();
  hud.Display();
}


void mouseClicked() {
  hud.click();
}
