GameManager gameManager;
Time time;

enum GameState {
  Pause, Play, Title, Inventory;
}

public class GameManager {

  GameState state;

  GameManager() {
    state = GameState.Play;
  }

  void setState(GameState s) {
    state = s;
  }
  void setPlay() {
    state = GameState.Play;
  }
  void setPause() {
    state = GameState.Pause;      //Sets
  }
  void setTitle() {
    state = GameState.Title;
  }
  void setInventory() {
    state = GameState.Inventory;
  }

  boolean isPlay() {
    if (state == GameState.Play) return true;
    else return false;
  }
  boolean isPause() {
    if (state == GameState.Pause) return true;
    else return false;
  }
  boolean isTitle() {
    if (state == GameState.Title) return true;
    else return false;
  }
  boolean isInventory() {
    if (state == GameState.Inventory) return true;
    else return false;
  }


  GameState State() {
    return state;                   //Get state
  }

  void PreUpdate() {
  }

  void PostUpdate() {
  }
}

class Time {

  double deltaFrames;

  Time() {
  }

  void Update() {
  }

  float getDeltaFrames() {
    deltaFrames = 1 / frameRate;
    return(float)deltaFrames;
  }
}
