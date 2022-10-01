InputControl inputControl = new InputControl();

class InputControl {
    
    PVector keyDir;
    boolean z = false, q = false, s = false, d = false, space = false, b = false;
    
    InputControl() {
        keyDir = new PVector();
}
    
    void setInput(char ke, boolean set) {
        
        switch(ke) {
           case 'z': 
                z = set;
                break;
            
           case 'q': 
                q = set;  
                break;
            
           case 's': 
                s = set;  
                break;
            
           case 'd': 
                d = set;
                break;
            
           case ' ':
                space = set;
                break;
            
           case 'b': 
                b = set;  
                break;
        }
        
        UpdateKeyDir();
    }
    
    void UpdateKeyDir() {
        keyDir = new PVector();
        
        if (z) keyDir.y--;
        if (s) keyDir.y++;
        if (q) keyDir.x--;
        if (d) keyDir.x++;
        
        keyDir.normalize();
    }
}


void keyPressed() {
    inputControl.setInput(key, true);
    
    if(key == 'b') {
        
        if (gameManager.isPlay()) {
            gameManager.setInventory();
        } else if (gameManager.isInventory()) {
            gameManager.setPlay();
        }
    }
}
void keyReleased() {
    inputControl.setInput(key, false);
}

void mousePressed() {
    for (Player e : mapActif.AllPlayers)
        if (e.IsOnPlayer(mouseX, mouseY)) {
            camera.SwitchFocus(e);
        }
}

void mouseReleased() {
    if(gameManager.isTitle()) {
        hud.title.MouseClick();
    }
    
    if(gameManager.isInventory()) hud.inventoryHUD.ClickG();
}
