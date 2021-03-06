/*
Experimenting with skeleton-physics simulation on 
a beam model made in Antimony 0.9

link_type can be 1 for just the perimeter, or 2
for internal crosses as well

nothing_fixed can be true for making all the points
floating near their anchors, or false for fixing
some of the points

this is all still experimental! it's fun to play
around with it!

---

Erin RobotGrrl
erin@robotgrrl.com
Saturday, Nov. 14, 2015
At the Hackaday Hardware Superconference!

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
Spring[] springs_left_cube_type1 = new Spring[NUM_CUBE_POINTS];
Spring[] springs_left_cube_type2 = new Spring[NUM_CUBE_POINTS+2];

Particle[] particles_right_cube = new Particle[NUM_CUBE_POINTS];
Particle[] anchors_right_cube = new Particle[NUM_CUBE_POINTS];
Spring[] springs_right_cube_type1 = new Spring[NUM_CUBE_POINTS];
Spring[] springs_right_cube_type2 = new Spring[NUM_CUBE_POINTS+2];

Particle[] particles_cyl = new Particle[NUM_CYL_POINTS];
Particle[] anchors_cyl = new Particle[NUM_CYL_POINTS];
Spring[] springs_cyl_type1 = new Spring[NUM_CYL_POINTS];
Spring[] springs_cyl_type2 = new Spring[NUM_CYL_POINTS+4];

Particle mouse;

float left_cube_points[][] = new float[NUM_CUBE_POINTS][3];
float cyl_points[][] = new float[NUM_CYL_POINTS][3];
float right_cube_points[][] = new float[NUM_CUBE_POINTS][3];

// just the outer perimeter
int left_cube_links_type1[][] = { 
  { 0, 1 },
  { 1, 2 },
  { 2, 3 },
  { 3, 0 }
}; 
                
// with the internal crosses
int left_cube_links_type2[][] = { 
  { 0, 1 },
  { 1, 2 },
  { 2, 3 },
  { 3, 0 },
  { 1, 3 },
  { 0, 2 }
}; 

// just the outer perimeter
int right_cube_links_type1[][] = { 
  { 0, 1 },
  { 1, 2 },
  { 2, 3 },
  { 3, 0 }
}; 
                
// with the internal crosses
int right_cube_links_type2[][] = { 
  { 0, 1 },
  { 1, 2 },
  { 2, 3 },
  { 3, 0 },
  { 1, 3 },
  { 0, 2 }
}; 

// just the outer perimeter
int cyl_links_type1[][] = {
  {0, 1},
  {1, 3},
  {3, 5},
  {5, 4},
  {4, 2},
  {2, 0}
};

// with internal crosses
int cyl_links_type2[][] = {
  {0, 1},
  {1, 3},
  {3, 5},
  {5, 4},
  {4, 2},
  {2, 0},
  {1, 2},
  {0, 3},
  {3, 4},
  {5, 2}
};


int link_type = 1;

boolean nothing_fixed = true;


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
    particles_cyl[i] = physics.makeParticle(1.0, cyl_points[i][0], cyl_points[i][2], 0.0);
    anchors_cyl[i] = physics.makeParticle(1.0, cyl_points[i][0], cyl_points[i][2], 0.0);
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
    particles_right_cube[i] = physics.makeParticle(1.0, right_cube_points[i][0], right_cube_points[i][2], 0.0);
    anchors_right_cube[i] = physics.makeParticle(1.0, right_cube_points[i][0], right_cube_points[i][2], 0.0);
  }
  
  
}


void setup() {
  size(800, 600);
  smooth();
  frameRate(30);
  
  // making the font
  printArray(PFont.list());
  f = createFont("SourceCodePro-Regular.ttf", 24);
  textFont(f);
  textAlign(CENTER, CENTER);
  
  physics = new ParticleSystem(0.0, 0.0);
  
  mouse = physics.makeParticle();
  mouse.makeFixed();
  
  readAntimonyFile();
  
  if(link_type == 1) {
    
    // linking particles together with springs - distance is 
    // between the two points
    float distance;
    for(int i=0; i<NUM_CUBE_POINTS; i++) {
      distance = sqrt( pow( abs( left_cube_points[ left_cube_links_type1[i][0] ][0] - left_cube_points[ left_cube_links_type1[i][1] ][0]),2 ) + pow( abs( left_cube_points[ left_cube_links_type1[i][0] ][2] - left_cube_points[ left_cube_links_type1[i][1] ][2] ),2 ) );
      springs_left_cube_type1[i] = physics.makeSpring(particles_left_cube[ left_cube_links_type1[i][0] ], particles_left_cube[ left_cube_links_type1[i][1] ], 0.8, 1, distance);
      distance = sqrt( pow( abs( right_cube_points[ right_cube_links_type1[i][0] ][0] - right_cube_points[ right_cube_links_type1[i][1] ][0]),2 ) + pow( abs( right_cube_points[ right_cube_links_type1[i][0] ][2] - right_cube_points[ right_cube_links_type1[i][1] ][2] ),2 ) );
      springs_right_cube_type1[i] = physics.makeSpring(particles_right_cube[ right_cube_links_type1[i][0] ], particles_right_cube[ right_cube_links_type1[i][1] ], 0.8, 1, distance);
    }
    
    for(int i=0; i<NUM_CYL_POINTS; i++) {
      distance = sqrt( pow( abs( cyl_points[ cyl_links_type1[i][0] ][0] - cyl_points[ cyl_links_type1[i][1] ][0]),2 ) + pow( abs( cyl_points[ cyl_links_type1[i][0] ][2] - cyl_points[ cyl_links_type1[i][1] ][2] ),2 ) );
      springs_cyl_type1[i] = physics.makeSpring(particles_cyl[ cyl_links_type1[i][0] ], particles_cyl[ cyl_links_type1[i][1] ], 0.8, 1, distance);
    }
  
  } else if(link_type == 2) {
  
    // link type 2
    float distance;
    for(int i=0; i<NUM_CUBE_POINTS+2; i++) {
      distance = sqrt( pow( abs( left_cube_points[ left_cube_links_type2[i][0] ][0] - left_cube_points[ left_cube_links_type2[i][1] ][0]),2 ) + pow( abs( left_cube_points[ left_cube_links_type2[i][0] ][2] - left_cube_points[ left_cube_links_type2[i][1] ][2] ),2 ) );
      springs_left_cube_type2[i] = physics.makeSpring(particles_left_cube[ left_cube_links_type2[i][0] ], particles_left_cube[ left_cube_links_type2[i][1] ], 0.8, 1, distance);
      distance = sqrt( pow( abs( right_cube_points[ right_cube_links_type2[i][0] ][0] - right_cube_points[ right_cube_links_type2[i][1] ][0]),2 ) + pow( abs( right_cube_points[ right_cube_links_type2[i][0] ][2] - right_cube_points[ right_cube_links_type2[i][1] ][2] ),2 ) );
      springs_right_cube_type2[i] = physics.makeSpring(particles_right_cube[ right_cube_links_type2[i][0] ], particles_right_cube[ right_cube_links_type2[i][1] ], 0.8, 1, distance);
    }
    
    for(int i=0; i<NUM_CYL_POINTS+4; i++) {
      distance = sqrt( pow( abs( cyl_points[ cyl_links_type2[i][0] ][0] - cyl_points[ cyl_links_type2[i][1] ][0]),2 ) + pow( abs( cyl_points[ cyl_links_type2[i][0] ][2] - cyl_points[ cyl_links_type2[i][1] ][2] ),2 ) );
      springs_cyl_type2[i] = physics.makeSpring(particles_cyl[ cyl_links_type2[i][0] ], particles_cyl[ cyl_links_type2[i][1] ], 0.8, 1, distance);
    }
  
  }
  
  // make all of the particles attracted to the mouse particle
  for(int i=1; i<NUM_CUBE_POINTS; i++) {
    physics.makeAttraction(mouse, particles_left_cube[i], 1000, 15);
    physics.makeAttraction(mouse, particles_right_cube[i], 1000, 15);
  }
  if(!nothing_fixed) {
    particles_left_cube[2].makeFixed();
    particles_right_cube[2].makeFixed();
  }
  
  for(int i=1; i<NUM_CYL_POINTS; i++) {
    physics.makeAttraction(mouse, particles_cyl[i], 1000, 15);
    //particles_cyl[i].makeFixed(); // TODO: remove this
  }
  if(!nothing_fixed) {
    particles_cyl[0].makeFixed();
    particles_cyl[1].makeFixed();
    particles_cyl[5].makeFixed();
    particles_cyl[4].makeFixed();
  }
  
  // make all particles repel each other a little bit
  for(int i=1; i<NUM_CUBE_POINTS; i++) {
    physics.makeAttraction(particles_left_cube[i-1], particles_left_cube[i], -10000, 10);
    physics.makeAttraction(particles_right_cube[i-1], particles_right_cube[i], -10000, 10);
  }
  
  for(int i=1; i<NUM_CYL_POINTS; i++) {
    physics.makeAttraction(particles_cyl[i-1], particles_cyl[i], -10000, 10);
  }
  
  // make the particles attracted to their anchors
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    physics.makeAttraction(particles_left_cube[i], anchors_left_cube[i], 10000, 100);
    anchors_left_cube[i].makeFixed();
    physics.makeAttraction(particles_right_cube[i], anchors_right_cube[i], 10000, 100);
    anchors_right_cube[i].makeFixed();
  }
  
  for(int i=0; i<NUM_CYL_POINTS; i++) {
    physics.makeAttraction(particles_cyl[i], anchors_cyl[i], 10000, 100);
    anchors_cyl[i].makeFixed();
  }
  
  
}

void draw() {
  
  physics.tick();
  
  background(0);
  
  if(link_type == 1) {
  
    // drawing the springs - link type 1
    stroke(255);
    for(int i=0; i<NUM_CUBE_POINTS; i++) {
      line( particles_left_cube[ left_cube_links_type1[i][0] ].position().x(), particles_left_cube[ left_cube_links_type1[i][0] ].position().y(), particles_left_cube[ left_cube_links_type1[i][1] ].position().x(), particles_left_cube[ left_cube_links_type1[i][1] ].position().y());
      line( particles_right_cube[ right_cube_links_type1[i][0] ].position().x(), particles_right_cube[ right_cube_links_type1[i][0] ].position().y(), particles_right_cube[ right_cube_links_type1[i][1] ].position().x(), particles_right_cube[ right_cube_links_type1[i][1] ].position().y());
    }
    
    for(int i=0; i<NUM_CYL_POINTS; i++) {
      line( particles_cyl[ cyl_links_type1[i][0] ].position().x(), particles_cyl[ cyl_links_type1[i][0] ].position().y(), particles_cyl[ cyl_links_type1[i][1] ].position().x(), particles_cyl[ cyl_links_type1[i][1] ].position().y());
    }
    noStroke();
  
  } else if(link_type == 2) {
  
    // drawing the springs - link type 2
    stroke(255);
    for(int i=0; i<NUM_CUBE_POINTS+2; i++) {
      line( particles_left_cube[ left_cube_links_type2[i][0] ].position().x(), particles_left_cube[ left_cube_links_type2[i][0] ].position().y(), particles_left_cube[ left_cube_links_type2[i][1] ].position().x(), particles_left_cube[ left_cube_links_type2[i][1] ].position().y());
      line( particles_right_cube[ right_cube_links_type2[i][0] ].position().x(), particles_right_cube[ right_cube_links_type2[i][0] ].position().y(), particles_right_cube[ right_cube_links_type2[i][1] ].position().x(), particles_right_cube[ right_cube_links_type2[i][1] ].position().y());
    }
    
    for(int i=0; i<NUM_CYL_POINTS+4; i++) {
      line( particles_cyl[ cyl_links_type2[i][0] ].position().x(), particles_cyl[ cyl_links_type2[i][0] ].position().y(), particles_cyl[ cyl_links_type2[i][1] ].position().x(), particles_cyl[ cyl_links_type2[i][1] ].position().y());
    }
    noStroke();
  
  }
  
  // drawing the cube points
  fill(255);
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    ellipse(left_cube_points[i][0], left_cube_points[i][2], 15, 15);
    ellipse(right_cube_points[i][0], right_cube_points[i][2], 15, 15);
  }
  
  // drawing the cyl points
  fill(255);
  for(int i=0; i<NUM_CYL_POINTS; i++) {
    ellipse(cyl_points[i][0], cyl_points[i][2], 15, 15);
  }
  
  // mouse particle
  fill(255);
  mouse.position().set(mouseX, mouseY, 0);
  ellipse(mouse.position().x(), mouse.position().y(), 15, 15);
  
  // cube particles
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    fill(255, 255, 255);
    String s = ("" + i);
    text(s, particles_left_cube[i].position().x()+25, particles_left_cube[i].position().y());
    text(s, particles_right_cube[i].position().x()+25, particles_right_cube[i].position().y());
    fill(0, 255, 0);
    ellipse( particles_left_cube[i].position().x(), particles_left_cube[i].position().y(), 15, 15 );
    ellipse( particles_right_cube[i].position().x(), particles_right_cube[i].position().y(), 15, 15 );
  }
  
  // cyl particles
  for(int i=0; i<NUM_CYL_POINTS; i++) {
    fill(255, 255, 255);
    String s = ("" + i);
    text(s, particles_cyl[i].position().x()+25, particles_cyl[i].position().y());
    fill(0, 255, 0);
    ellipse( particles_cyl[i].position().x(), particles_cyl[i].position().y(), 15, 15 );
  }
  
  // cube anchors
  fill(0, 0, 255);
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    ellipse( anchors_left_cube[i].position().x(), anchors_left_cube[i].position().y(), 15, 15 );
    ellipse( anchors_right_cube[i].position().x(), anchors_right_cube[i].position().y(), 15, 15 );
  }
  
  for(int i=0; i<NUM_CYL_POINTS; i++) {
    ellipse( anchors_cyl[i].position().x(), anchors_cyl[i].position().y(), 15, 15 );
  }
  
  // handle the boundaries
  for(int i=0; i<NUM_CUBE_POINTS; i++) {
    handleBoundaryCollisions(particles_left_cube[i]);
    handleBoundaryCollisions(particles_right_cube[i]);
  }
  
  for(int i=0; i<NUM_CYL_POINTS; i++) {
    handleBoundaryCollisions(particles_cyl[i]);
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