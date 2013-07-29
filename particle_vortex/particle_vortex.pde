import peasy.*;
PeasyCam cam;
public class Particle{
  PVector pos, vel, acc;
  int c, s, alpha;
  float r;
  Particle(){
    pos = new PVector(random(20,50),0,0);
    vel = new PVector(0,-random(.01,.02)*pos.x,0);
    s = 2;
    c = 150;
    r = random(0,TWO_PI);
    alpha = 100;
  }
  void display(){
    pos.add(vel);
    r = r + .05;
    pushMatrix();
    rotateY(r);
    translate(pos.x,pos.y,pos.z);
    alpha=(int)map(frameCount%150,0,150,200,255);
    noStroke();
    fill(c,255,255,alpha);
    rect(0,0,s,s);
    popMatrix();
    //sphere(s);
  }
}

public class Cloud {
  int c, alpha;
  Particle[] pArr;
  Cloud(int num_particles){
    pArr = new Particle[num_particles];
    for(int i=0;i<num_particles;i++){
      pArr[i]=new Particle();
    }
  }
  void display(){
    translate(mouseX, height/2,0);
    for(int j=0;j<pArr.length;j++){
      pArr[j].display();
    }
  }
}
    
Cloud cloud_a;  
void setup(){
  size(500,500,P3D);
  cam = new PeasyCam(this,500);
  colorMode(HSB);
  cloud_a = new Cloud(1000);
}
void draw(){
  background(255);
  lights();
  cloud_a.display();
}
