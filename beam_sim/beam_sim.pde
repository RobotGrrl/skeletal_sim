
JSONObject json;

void setup() {
  size(600, 600);
  smooth();
  readAntimonyFile();
}

void draw() {
  background(0);  
}

void readAntimonyFile() {

  json = loadJSONObject("beam_chain_single.sb");
  
  JSONArray nodes = json.getJSONArray("nodes");
  
  println("total num nodes " + nodes.size());
  
  for(int i=0; i<nodes.size(); i++) {
    JSONObject child = nodes.getJSONObject(i);
    
    //println("----------");
    //println(child);
    
    int uid = child.getInt("uid");
    JSONArray datums = child.getJSONArray("datums"); // all the parameters of this
    String name = child.getString("name");
    JSONArray inspector = child.getJSONArray("inspector"); // where it is located in the graph view
    JSONArray script = child.getJSONArray("script"); // the script is an array, line by line
    
    println("----------");
    println("node #" + i);
    println("name = " + name);
    println("uid = " + uid);
    println("num datums = " + datums.size());
    
    for(int j=0; j<datums.size(); j++) {
      JSONObject data = datums.getJSONObject(j);
      int data_uid = data.getInt("uid");
      String data_name = data.getString("name");
      String data_expr = data.getString("expr");
      String data_type = data.getString("type");
      println("    " + data_name + " (" + data_type + ") expr = " + data_expr + " uid = " + data_uid);
    }
    
    println("inspector node position = (" + inspector.getInt(0) + ", " + inspector.getInt(1) + ")");
    println("num lines in script = " + script.size());
  }
  
  
}

/*
todo:
-----

- create an object to store the node's name and parameters
- populate these objects
- figure out a way to parse the datum expressions into referring datums + their parameters

*/