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

