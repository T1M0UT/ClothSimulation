import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.geom.*;

PImage image;
PImage bg;
int res = 1;
int cols = 40 / res;
int rows = 40 / res;

Particle[][] particles;
ArrayList<Spring> springs;

float w = 10 * res;
float zoff = 0;

VerletPhysics3D physics;

void setup(){
  size(1200, 800, P3D);
  image = loadImage("Flower2.jpeg");
  //bg = loadImage("dahab.jpg");
  //print(image.width, image.height);
  rows = image.height / 14 / res;
  particles = new Particle[cols][rows];
  springs = new ArrayList<Spring>();
  
  physics = new VerletPhysics3D();
  Vec3D gravity = new Vec3D(0, 0.7, 0);
  GravityBehavior3D gb = new GravityBehavior3D(gravity);
  physics.addBehavior(gb);
  
  float x = -width/2 + 100;
  for (int i = 0; i < cols; i++){
     float y = -rows*w/2 - 100;
     for (int j = 0; j < rows; j++){
         Particle p = new Particle(x, y, 0);
         particles[i][j] = p;
         physics.addParticle(p);
         y = y + w;
     }
     x = x + w;
  }
  
  for (int i = 0; i < cols; i++){
     for (int j = 0; j < rows; j++){
        Particle a = particles[i][j];
        if (i != cols-1){
           Particle b1 = particles[i+1][j]; 
           Spring s1 = new Spring(a, b1);
           springs.add(s1);
           physics.addSpring(s1);
        }
        
        if (j != rows-1){
           Particle b2 = particles[i][j+1]; 
           Spring s2 = new Spring(a, b2);
           springs.add(s2);
           physics.addSpring(s2);
        }
     }
  }
  
  for(int i = 0; i < rows; i+=1){
    particles[0][i].lock();
  }
  
}

float a = 0;

void draw(){
   background(240, 230, 220);
   
   translate(width/2, height/2);
   physics.update();
   
   float xoff = 0;
   for (int i = 0; i < cols; i++){
     float yoff = 0;
     for (int j = 0; j < rows; j++){
        //particles[i][j].display();
        float windx = map(noise(xoff, yoff, zoff), 0, 1, 1, 3);
        float windz = map(noise(xoff + 3023, yoff + 2322, zoff), 0, 1, -1, 1);
        
        Vec3D wind = new Vec3D(windx, 0, windz);
        particles[i][j].addForce(wind);
        yoff += 0.1;
        //particles[i][j].display();
     }
     xoff += 0.1;
   }
   zoff += 0.1;
   
   //for (Spring s : springs){
   //   s.display(); 
   //}
   
   noFill();
   //strokeWeight(1);
   noStroke();
   textureMode(NORMAL);
   for (int j = 0; j < rows-1; j++){
     beginShape(TRIANGLE_STRIP);
     texture(image);
     for (int i = 0; i < cols; i++){
       float x1 = particles[i][j].x;
       float y1 = particles[i][j].y;
       float z1 = particles[i][j].z;
       float u = map(i, 0, cols-1, 0, 1);
       float v1 = map(j, 0, rows-1, 0, 1);
       vertex(x1, y1, z1, u, v1);
       float x2 = particles[i][j+1].x;
       float y2 = particles[i][j+1].y;
       float z2 = particles[i][j+1].z;
       float v2 = map(j+1, 0, rows-1, 0, 1);
       vertex(x2, y2, z2, u, v2);
     }
     endShape();
   }
   
   stroke(40);
   strokeWeight(7);
   line(-width/2 + 100, -rows*w/2 - 120, -width/2 + 100, height); 
}
