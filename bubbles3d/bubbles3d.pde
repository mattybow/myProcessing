ArrayList<Integer> aArray = new ArrayList<Integer>();
ArrayList<Bubble> bubs = new ArrayList<Bubble>();
float noiseScale = 0.02;
//import peasy.*;
//PeasyCam cam;

public class Bubble{
  PVector pos, vel, acc;
  int s,c;
  float alpha, r;
  //BUBBLE CONSTRUCTOR
  Bubble(int size, int xCoord, int yCoord, int zCoord){
    pos = new PVector(xCoord,yCoord,zCoord);
    vel = new PVector(0,-.05*size,0);
    s = size;
    c = (int)random(150,220);
    r = random(1,50);
    alpha = 100;
  }
  //BUBBLE DRAWER
  void display(){
    float noiseVal = noise(frameCount*noiseScale+r*4);
    int pos_neg = 1;
    if(pos.y<-height) {
      bubs.remove(this);
      println("bubble popped");
    }
    if(frameCount%2==0) pos_neg = -1;
    vel.x=noiseVal*pos_neg;
    pos.add(vel);
    pushMatrix();
    translate((int)pos.x,(int)pos.y,(int)pos.z);
    noStroke();
    fill(c,255,255,80);
    sphere(s);
    popMatrix();
  }
  //BUBBLE POPPER
  void popped(int mx, int my){
    float distX=abs(mx-width/2-pos.x);
    if(distX<s){
      println("mx " + mx + " pos.x " + pos.x + " s " + s);
      println((mx-width/2-pos.x));
      println("my " + my + " pos.y " + pos.y + " s " + s);
      println((-my-pos.y));
      float distY=abs(-my-pos.y);
      if(distY<s){
        bubs.remove(this);
        println("bubble popped by user");
      }
    }
  }
}


void setup(){
  size(500,500,P3D);
//  cam = new PeasyCam(this,500);
  colorMode(HSB);
  for(int i=0;i<5;i++){
    int rSize = (int)random(5,10);
    int rX = (int)random(0,width);
    int rZ = (int)random(0,width);
    bubs.add(new Bubble(rSize,rX,0,rZ));
  }
}

void draw(){
  background(0);
  lights();
  smooth();
  translate(0,height,0);
  for(int i=0;i<bubs.size();i++){
    bubs.get(i).display();
  }
}

void checkPop(int mx, int my){
  for(int i=0;i<bubs.size();i++){
    bubs.get(i).popped(mx,my);
  }
}

void mousePressed(){
  checkPop(mouseX,mouseY);
}

