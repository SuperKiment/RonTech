FichiersLoader fichiersLoader;

class FichiersLoader {

  HashMap<String, Solide> SolidesTypes;
  HashMap<String, Module> ModulesTypes;
  String basePath;
  String fileLoader;

  FichiersLoader(String b, String f) {
    //Loaders/
    basePath = b;

    //loader.loader
    fileLoader = f;

    //lignes de loader.loader
    String[] baseLoader = loadStrings(basePath+f);

    //module.loader
    for (String loader : baseLoader) {
      println();
      println("Loa "+loader+" :");

      //lignes de module.loader
      String[] sousLoader = loadStrings(basePath+loader);

      //Module/
      String path = sousLoader[0];
      int i=0;

      //basic (.json)
      for (String filePath : sousLoader) {
        if (i!=0) {
          JSONObject json = loadJSONObject(basePath+path+filePath+".json");
          println(filePath+" :");
          println(json);
          println();
        }
        i++;
      }
    }
  }

  void TransferInHashMap(String file, JSONObject json) {
    if (file.equals("Module/")) {
      
    }
  }
}
