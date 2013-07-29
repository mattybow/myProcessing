//import peasy.*;
//PeasyCam cam;
public class Particle{
  PVector pos, vel, acc;
  int c, s, alpha, age, ageMax;
  float r;
  Particle(){
    pos = new PVector(random(10,50),0,0);
    vel = new PVector(0,0,random(.03,.04)*pos.x);
    s = 20;
    c = (int)random(120,180);
    r = random(0,TWO_PI);
    alpha = 100;
    age = 0;
    ageMax = 1000;
  }
  void update(){
    float rand=random(-1,1);
    int randDir = (int)(rand/abs(rand));
    float drg = (noise(pos.x/20+492,pos.y/20+490,frameCount/50.2)-0.5)/300 + 1.05;
    vel.x/=drg;
    r += .01;
    vel.x+=noise(pos.x,pos.y,pos.z)-.45;
  }
  void display(){
    update();
    age += 1;
    pos.add(vel);
    pushMatrix();
    {
      rotateZ(r);
      translate(pos.x,pos.y,pos.z);
      pushMatrix();
      {
        alpha=(int)map(age,0,ageMax,255,0);
        noStroke();
        fill(c,255,255,alpha);
        rotateX(PI/2.4);
        rect(0,0,s,s);
      }
      popMatrix();
    }
    popMatrix();
    //sphere(s);
  }
  int getAlpha(){
    return alpha;
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
    for(int j=0;j<pArr.length;j++){
      pArr[j].display();
    }
  }
  boolean pop(){
    boolean remove=false;
    int count=0;
    for(int j=0;j<pArr.length;j++){
      if(pArr[j].getAlpha()==0) count+=1;
    }
    if(count==pArr.length){
     remove=true;
    }
    return remove;
  } 
}
    
Cloud cloud_a;  
void setup(){
  size(500,500,P3D);
//  cam = new PeasyCam(this,500);
  colorMode(HSB);
  cloud_a = new Cloud(100);
}
void draw(){
  background(0);
  lights();
  translate(width/2, height/2,0);
  rotateX(PI/2.4);
  stroke(255);
  strokeWeight(3);
  line(0,0,width,0);
  if(!cloud_a.pop()) cloud_a.display();
}
