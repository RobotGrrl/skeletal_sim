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


static float SCALE = 150.0;
static float OFF_X = 50.0;
static float OFF_Y = -20.0;
static int NUM_POINTS = 4;

float points[][] = new float[NUM_POINTS][3];

void makePoints() {
  
  points[0][0] = xpos + (sq/2);
  points[0][1] = ypos - (sq/2);
  points[0][2] = zpos + (sq/2);
  
  points[1][0] = xpos + (sq/2);
  points[1][1] = ypos - (sq/2);
  points[1][2] = zpos - (sq/2);
  
  points[2][0] = xpos - (sq/2);
  points[2][1] = ypos - (sq/2);
  points[2][2] = zpos - (sq/2);
  
  points[3][0] = xpos - (sq/2);
  points[3][1] = ypos - (sq/2);
  points[3][2] = zpos + (sq/2);
  
  // with this model, actually using x & z expressions
  // for the x & y coords
  
  for(int i=0; i<NUM_POINTS; i++) {
    for(int j=0; j<3; j++) {
      if(j == 0 || j == 2) {
        points[i][j] *= SCALE;
      }
      if(j == 0) points[i][j] += OFF_X;
      if(j == 2) points[i][j] += OFF_Y;
    }
  }
  
}



void setup() {
  size(600, 600);
  smooth();
  readAntimonyFile();
}

void draw() {
  background(0);
  
  fill(255);
  
  for(int i=0; i<NUM_POINTS; i++) {
    ellipse(points[i][0], points[i][2], 15, 15);
  }
  
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
      makePoints();
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