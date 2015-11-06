/*


*/

JSONObject json;

// inputs on dim node
float xpos = 0.0;
float ypos = 0.0;
float zpos = 0.0;
float sq = 0.91;
float len = 2.29;
float theta = 0;

void setup() {
  size(600, 600);
  smooth();
  readAntimonyFile();
}

void draw() {
  background(0);  
}

void readAntimonyFile() {

  json = loadJSONObject("beam_chain_single_dims.sb");
  
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
    
    // loading in the dim inputs
    if(name.equals("dim")) {
      loadDimNode(datums); 
    }
    
  }
  
}


void loadDimNode(JSONArray datums) {
 
  for(int j=0; j<datums.size(); j++) {
    JSONObject data = datums.getJSONObject(j);
    int data_uid = data.getInt("uid");
    String data_name = data.getString("name");
    String data_expr = data.getString("expr");
    String data_type = data.getString("type");
    //println("    " + data_name + " (" + data_type + ") expr = " + data_expr + " uid = " + data_uid);
    
    if(data_name.equals("xpos")) xpos = Float.parseFloat(data_expr);
    if(data_name.equals("ypos")) ypos = Float.parseFloat(data_expr);
    if(data_name.equals("zpos")) zpos = Float.parseFloat(data_expr);
    if(data_name.equals("sq")) sq = Float.parseFloat(data_expr);
    if(data_name.equals("len")) len = Float.parseFloat(data_expr);
    if(data_name.equals("theta")) theta = Float.parseFloat(data_expr);
    
  }
  
}


/*
todo:
-----

- create an object to store the node's name and parameters
- populate these objects
- figure out a way to parse the datum expressions into referring datums + their parameters

*/