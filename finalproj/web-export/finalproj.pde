//GLOBALS
import ddf.minim.*;
import ddf.minim.analysis.*;
//import peasy.*;
//PeasyCam cam;

Minim minim;
AudioPlayer player;
BeatDetect beat;
BeatListener b1;

Grid myGrid;
int settle = 1;
int SQ = 25;
float t = 0.0;
void setup(){
  size(600,500,P3D);
  colorMode(HSB);
  minim = new Minim(this);
  myGrid = new Grid();                                //sends bar array to Grid class
  player = minim.loadFile("YaHey.mp3", 2048);
  player.play();
  beat = new BeatDetect(player.bufferSize(),player.sampleRate());
  beat.setSensitivity(10);
  b1 = new BeatListener(beat,player);
  //cam = new PeasyCam(this,600);
}

void draw(){
  background(0);
  lights();
  myGrid.settle();
//  float cameraY = height/1;
//  float cameraX = width/1;
//  rotateZ(frameCount*PI/500);
//  float fov = cameraX/float(width) * PI/2;
//  float cameraZ = cameraY / tan(fov / 2.0);
//  float aspect = float(width)/float(height);
//  perspective(fov, aspect, cameraZ/2000.0, cameraZ*4000.0);
  float powL = 0;
  float powR = 0;
  if(t<=0.0){
    for(int i=200;i<player.bufferSize();i++){
      powL = player.left.get(i);
      powR = player.right.get(i);
      if (abs(powL)>.5){
        int p=(int)(powL*6);
        myGrid.addBar(p,0,(int)random(0,SQ-1));
        myGrid.addBar(p,0,(int)random(0,SQ-1));
        t=.10;
      }
      if (abs(powL)>.7){
        myGrid.addBar(7,2,(int)random(0,SQ-1));
        myGrid.addBar(7,3,(int)random(0,SQ-1));
      }
      if (abs(powL)>.75){
        myGrid.addBar(5,7,(int)random(0,SQ-1));
      }
      if (abs(powR)>.5){
        myGrid.addBar(5,4,(int)random(0,SQ-1));
        myGrid.addBar(5,4,(int)random(0,SQ-1));
      }
      if (abs(powR)>.7){
        myGrid.addBar(7,5,(int)random(0,SQ-1));
        myGrid.addBar(7,6,(int)random(0,SQ-1));
      }
      if (abs(powR)>.75){
        myGrid.addBar(5,8,(int)random(0,SQ-1));
      }
      if(beat.isHat()){
        myGrid.addBar(5,7,(int)random(0,SQ-1));
      }
      break;
    }
    t -= .01;
  }
  else t -= .01;
    //println(player.bufferSize());
//    for(int i=0;i<player.bufferSize();i++){
//      println(i + " = " + player.left.get(i));
//    }
//    println("---------");
//    println(player.left.get(
  if(beat.isSnare()) {
    myGrid.addBar(5,1,(int)random(0,SQ-1));
  }
  
  pushMatrix(); 
  translate(0, height/2, 0);                        //rotates ENTIRE grid and translates
  //translate(-width/2, 0, 200);                    //use with peasycam
  rotateX(PI/2.4);
//  rotateZ(-.8);
  myGrid.display();
  popMatrix();
}
void stop()
{
  player.close();
  minim.stop();
  super.stop();
}

void mousePressed(){
//  myGrid.addBar(5,(float)mouseX,(float)mouseY);
}

public class Bar{
  int s,h,z,c,posX,posY,posZ,row,col,max_h;
  float alpha;
  //BAR CONSTRUCTOR
  Bar(int vert_height, int xCoord, int yCoord, int zCoord, int i_row, int i_col){
    h = vert_height;
    max_h = vert_height;
    posX = xCoord;
    posY = yCoord;
    posZ = zCoord;
    row = i_row;
    col = i_col;
    s = SQ;
    c = (int)map(posY,0,250,200,0);
    alpha = 0;
  }
  //BAR METHODS
  void setZ(int zValue){posZ=zValue;}
  void moveZ(int stepVal){
    if(posZ<0) posZ=posZ+stepVal;
  }
  void setColor(int incrementVal){
    c=(c+incrementVal)%255;
  }
  int getX(){return posX;}
  int getY(){return posY;}
  int getZ(){return posZ;}
  int getC(){return c;}
  int getH(){return h;}
  int getMH(){return max_h;}
  int get_row(){return row;}
  int get_col(){return col;}
  void display(){
    alpha = map(posZ,-60,0,0,210);
    fill(c,200,255,(int)alpha);
    noStroke();
    box(s,s,h);
  }
  boolean dissolve(){
    boolean done=false;
    if(h>0) h -= 1;
    else done=true;
    return done;
  }
}
class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;
 
  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
 
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
 
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}
public class Cloud {
  int c, alpha, age;
  PVector pos;
  Particle[] pArr;
  Cloud(int num_particles, int i_color, int x, int y, int z){
    c = i_color;
    age = 200;
    pos = new PVector(x,y,z);
    pArr = new Particle[num_particles];
    for(int i=0;i<num_particles;i++){
      pArr[i]=new Particle(c);
    }
  }
  void display(){
    pushMatrix();
    {
      translate(pos.x,pos.y,pos.z);
      for(int j=0;j<pArr.length;j++){
        pArr[j].display();
      }
    }
    popMatrix();
    age-=1;
  }
  int getAge(){
    return age;
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
public class Grid{
  ArrayList<Bar> grid1 = new ArrayList<Bar>();
  int[] x_range={0,width};
  int[] z_range={-100,0};
  int GRID_X = (int)(width/SQ);
  int GRID_Y = 10;
  Square[][] s_grid = new Square[GRID_X+1][GRID_Y+1];
  ArrayList<Cloud> c_grid = new ArrayList<Cloud>();

  Grid(){
  //FOR static grid
    for(int j=0;j<GRID_X;j++){
        for(int k=0;k<GRID_Y;k++){
          s_grid[j][k]=new Square(SQ*j+5*j,SQ*k+5*k);
        }
    }
  }

  void display(){
    for(int i=0;i<grid1.size();i++){
      int x_val=grid1.get(i).getX();
      int y_val=grid1.get(i).getY();
      int z_val=grid1.get(i).getZ();
      pushMatrix();
      translate(x_val,y_val,z_val);                         //draws bars from the array
      grid1.get(i).display();
      popMatrix();
    }
    for(int j=0;j<GRID_X;j++){
        for(int k=0;k<GRID_Y;k++){
          s_grid[j][k].display();
        }
    }
    for(int k=0;k<c_grid.size();k++){
      Cloud i_cloud = c_grid.get(k);
      i_cloud.display();
      if (i_cloud.getAge()<=0){
        c_grid.remove(i_cloud);
      }
    }
  }
  int settle(){    //puts all bars back to zero plane
    int complete = 0;
    for(int i=0;i<grid1.size();i++){
      Bar iBar=grid1.get(i);
      int xVal=iBar.getX();
      int yVal=iBar.getY();
      int zVal=iBar.getZ();
      complete += zVal;
      if(zVal==0){
       s_grid[iBar.get_col()][iBar.get_row()].setMode();
       if (iBar.getH()==iBar.getMH()){
         c_grid.add(new Cloud(20,iBar.getC(),xVal,yVal,zVal));
       }
       if(iBar.dissolve()){
         grid1.remove(iBar);
       }
      } 
      else iBar.moveZ(2);
    }
    return complete;
  }
  void mixUp(){
    for(int i=0;i<grid1.size();i++){
      grid1.get(i).setZ((int)random(-500,-200));
    }
  }
  
  void addBar(int power, int row, int col){
    //power=>height
//    int col=(int)((i_x /width)*GRID_X); 
//    int row=(int)((i_y-height/2) / (height/2) * GRID_Y);
    int x_conv = SQ*col+5*col;
    int y_conv = SQ*row+5*row;
    grid1.add(new Bar(power,x_conv,y_conv,-60,row,col));
  }
}
public class Particle{
  PVector pos, vel, acc;
  int c, s, alpha, age, ageMax;
  float r;
  Particle(int i_color){
    pos = new PVector(random(10,50),0,0);
    vel = new PVector(0,0,random(.03,.04)*pos.x);
    s = 2;
    c = (int)random(i_color-10,i_color+10);
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
public class Square{
  int c=0;
  int timer = 100;
  boolean mode = false;
  PVector pos; 
  Square(int x, int y){
    pos = new PVector(x,y);
    c = (int)map(pos.y,0,250,200,0);
  }
  void setMode(){
    mode = true;
  }
  void display(){
    if(!mode) stroke(255,30);
    else {
      if(timer>0){
        int alpha=(int)map(timer,0,100,0,255);
        stroke(c,255,255,alpha);
        timer -= 1;
        if(timer==0) mode=false;
      }
      else timer=100;
    }
    pushMatrix();
    {
    translate(pos.x,pos.y,0);
    strokeWeight(1);
    noFill();
    rectMode(CENTER);
    rect(0,0,SQ,SQ);
    }
    popMatrix();
  }
  void row(){
  }
  void col(){
  }
}

