GameManager gameManager;
Time time;

enum GameState {
  Pause, Play, Title, Inventory;
}

enum Outil {
  SwitchCam, LiaisonModule, Play
}

public class GameManager {

  GameState state;
  Outil outil;
  OptionsManager optionsManager;
  boolean debug = false;

  GameManager() {
    state = GameState.Play;
    outil = Outil.LiaisonModule;
    optionsManager = new OptionsManager();
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

  class OptionsManager {

    int ground_rd;
    int entities_rd;

    OptionsManager() {
    }

    void Setup(String path) {
      JSONObject json = loadJSONObject(path);

      ground_rd = json.getInt("ground_rd", 5);
      entities_rd = json.getInt("entities_rd", 5);

      println("Opt Setup :");
      println("Opt ground_rd : "+ground_rd);
      println("Opt entities_rd : "+entities_rd);
    }
  }
}

//=================================================================

class Time {

  float deltaFrames;

  float getDeltaFrames() {
    deltaFrames = 1 / frameRate;
    return(float)deltaFrames;
  }
}
