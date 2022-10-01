class Mur {
    
    PVector pos;
    float taille;
    color couleur;
    
    Mur() {
        Constructor(10, 5);
}
    Mur(float x, float y) {
        Constructor(x, y);
}
    
    void Constructor(float x, float y) {
        pos = new PVector(x, y);
        taille = 200;
        couleur = color(#98A3AD);
}
    
    void Update() {
}
    
    void Display() {
        push();
        fill(couleur);
        translate(GrToSn(pos.x), GrToSn(pos.y));
        ellipse(0, 0, taille, taille);
        pop();
}
}
