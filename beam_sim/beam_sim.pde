/*


*/

import traer.physics.*;

ParticleSystem physics;
PFont f;
JSONObject json;

// inputs on dim node
float xpos = 0.0;
float ypos = 0.0;
float zpos = 0.0;
float sq = 0.0;
float len = 0.0;
float rad = 0.0;
float theta = 0.0;


static float SCALE = 150.0;
static float OFF_X = 80.0;
static float OFF_Y = 70.0;
static int NUM_CUBE_POINTS = 4;
static int NUM_CYL_POINTS = 6;

Particle[] particles_left_cube = new Particle[NUM_CUBE_POINTS];
Particle[] anchors_left_cube = new Particle[NUM_CUBE_POINTS];
Particle[] particles_right_cube = new Particle[NUM_CUBE_POINTS];
Particle[] anchors_right_cube = new Particle[NUM_CUBE_POINTS];
Particle[] particles_cyl = new Particle[NUM_CYL_POINTS];
Particle[] anchors_cyl = new Particle[NUM_CYL_POINTS];
Particle mouse;

float left_cube_points[][] = new float[NUM_CUBE_POINTS][3];
float cyl_points[][] = new float[NUM_CYL_POINTS][3];
float right_cube_points[][] = new float[NUM_CUBE_POINTS][3];


void makePoints() {
  
  left_cube_points[0][0] = xpos + (sq/2);
  left_cube_points[0][1] = ypos - (sq/2);
  left_cube_points[0][2] = zpos + (sq/2);
  
  left_cube_points[1][0] = xpos + (sq/2);
  left_cube_points[1][1] = ypos - (sq/2);
  left_cube_points[1][2] = zpos - (sq/2);
  
  left_cube_points[2][0] = xpos - (sq/2);
  left_cube_points[2][1] = ypos - (sq/2);
  left_cube_points[2][2] = zpos - (sq/2);
  
  left_cube_points[3][0] = xpos - (sq/2);
  left_cube_points[3][1] = ypos - (sq/2);
  left_cube_points[3][2] = zpos + (sq/2);
  
  // with this model, actually using x & z expressions
  // for the x & y coords
  
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    for(int j=0; j<3; j++) {
      if(j == 0 || j == 2) {
        left_cube_points[i][j] *= SCALE;
      }
      if(j == 0) left_cube_points[i][j] += OFF_X;
      if(j == 2) left_cube_points[i][j] += OFF_Y;
    }
    particles_left_cube[i] = physics.makeParticle(1.0, left_cube_points[i][0], left_cube_points[i][2], 0.0);
    anchors_left_cube[i] = physics.makeParticle(1.0, left_cube_points[i][0], left_cube_points[i][2], 0.0);
  }
  
  
  
  cyl_points[0][0] = xpos + (sq/2);
  cyl_points[0][1] = ypos;
  cyl_points[0][2] = zpos + (sq/2);
  
  cyl_points[1][0] = xpos + (sq/2);
  cyl_points[1][1] = ypos;
  cyl_points[1][2] = zpos + (sq/2) - rad;
  
  cyl_points[2][0] = xpos + (len/2);
  cyl_points[2][1] = ypos;
  cyl_points[2][2] = zpos + (sq/2);
  
  cyl_points[3][0] = xpos + (len/2);
  cyl_points[3][1] = ypos;
  cyl_points[3][2] = zpos + (sq/2) - rad;
  
  cyl_points[4][0] = xpos + len - (sq/2);
  cyl_points[4][1] = ypos;
  cyl_points[4][2] = zpos + (sq/2);
  
  cyl_points[5][0] = xpos + len - (sq/2);
  cyl_points[5][1] = ypos;
  cyl_points[5][2] = zpos + (sq/2) - rad;
  
  for(int i=0; i<NUM_CYL_POINTS; i++) {
    for(int j=0; j<3; j++) {
      if(j == 0 || j == 2) {
        cyl_points[i][j] *= SCALE;
      }
      if(j == 0) cyl_points[i][j] += OFF_X;
      if(j == 2) cyl_points[i][j] += OFF_Y;
    }
  }
  
  
  
  right_cube_points[0][0] = xpos + len - (sq/2);
  right_cube_points[0][1] = ypos - (sq/2);
  right_cube_points[0][2] = zpos + (sq/2);
  
  right_cube_points[1][0] = xpos + len + (sq/2);
  right_cube_points[1][1] = ypos - (sq/2);
  right_cube_points[1][2] = zpos + (sq/2);
  
  right_cube_points[2][0] = xpos + len + (sq/2);
  right_cube_points[2][1] = ypos - (sq/2);
  right_cube_points[2][2] = zpos - (sq/2);
  
  right_cube_points[3][0] = xpos + len - (sq/2);
  right_cube_points[3][1] = ypos - (sq/2);
  right_cube_points[3][2] = zpos - (sq/2);
  
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    for(int j=0; j<3; j++) {
      if(j == 0 || j == 2) {
        right_cube_points[i][j] *= SCALE;
      }
      if(j == 0) right_cube_points[i][j] += OFF_X;
      if(j == 2) right_cube_points[i][j] += OFF_Y;
    }
  }
  
  
}


void setup() {
  size(800, 600);
  smooth();
  
  // making the font
  printArray(PFont.list());
  f = createFont("SourceCodePro-Regular.ttf", 24);
  textFont(f);
  textAlign(CENTER, CENTER);
  
  physics = new ParticleSystem(0.0, 0.0);
  
  mouse = physics.makeParticle();
  mouse.makeFixed();
  
  readAntimonyFile();
  
  // make all of the particles attracted to the mouse particle
  // and anchor the first point (corner)
  for(int i=1; i<NUM_CUBE_POINTS; i++) {
    physics.makeAttraction(mouse, particles_left_cube[i], 1000, 15);
  }
  
  // make all particles repel each other a little bit
  for(int i=1; i<NUM_CUBE_POINTS; i++) {
    physics.makeAttraction(particles_left_cube[i-1], particles_left_cube[i], -10000, 10);
  }
  
  // make the particles attracted to their anchors
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    physics.makeAttraction(particles_left_cube[i], anchors_left_cube[i], 10000, 100);
    anchors_left_cube[i].makeFixed();
  }
  
}

void draw() {
  
  physics.tick();
  
  background(0);
  
  fill(255);
  
  // drawing the cube points
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    ellipse(left_cube_points[i][0], left_cube_points[i][2], 15, 15);
    ellipse(right_cube_points[i][0], right_cube_points[i][2], 15, 15);
  }
  
  // drawing the cyl points
  for(int i=0; i<NUM_CYL_POINTS; i++) {
    ellipse(cyl_points[i][0], cyl_points[i][2], 15, 15);
  }
  
  // mouse particle
  fill(255);
  mouse.position().set(mouseX, mouseY, 0);
  ellipse(mouse.position().x(), mouse.position().y(), 15, 15);
  
  // particles
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    fill(255, 255, 255);
    String s = ("" + i);
    text(s, particles_left_cube[i].position().x()+25, particles_left_cube[i].position().y());
    fill(0, 255, 0);
    ellipse( particles_left_cube[i].position().x(), particles_left_cube[i].position().y(), 15, 15 );
  }
  
  // anchors
  fill(0, 0, 255);
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    ellipse( anchors_left_cube[i].position().x(), anchors_left_cube[i].position().y(), 15, 15 );
  }
  
  // handle the boundaries
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    handleBoundaryCollisions(particles_left_cube[i]);
  }
  handleBoundaryCollisions(mouse);
  
  
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
    if(data_name.equals("rad")) rad = Float.parseFloat(data_expr);
    if(data_name.equals("theta")) theta = Float.parseFloat(data_expr);
    
  }
  
}


void keyPressed() {
 if(key == 'r'  ) {
   println("reloading the antimony file");
   readAntimonyFile();
 } 
}

void handleBoundaryCollisions( Particle p ) {
  if ( p.position().x() < 0 || p.position().x() > width ) {
    p.velocity().set(-0.9*p.velocity().x(), p.velocity().y(), 0);
    //p.setVelocity( -0.9*p.velocity().x(), p.velocity().y(), 0 );
  }
  if ( p.position().y() < 0 || p.position().y() > height ) {
    p.velocity().set(p.velocity().x(), -0.9*p.velocity().y(), 0);
    //p.setVelocity( p.velocity().x(), -0.9*p.velocity().y(), 0 );
  }
  //p.moveTo( constrain( p.position().x(), 0, width ), constrain( p.position().y(), 0, height ), 0 ); 
  p.position().set( constrain( p.position().x(), 0, width ), constrain( p.position().y(), 0, height ), 0 ); 
}


/*
todo:
-----

- create an object to store the node's name and parameters
- populate these objects
- figure out a way to parse the datum expressions into referring datums + their parameters

*/