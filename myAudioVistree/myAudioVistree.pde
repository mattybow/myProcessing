Maxim maxim;
AudioPlayer player;
//
//float magnify = 200; // This is how big we want the rose to be.
//float phase = 0; // Phase Coefficient : this is basically how far round the circle we are going to go
//float amp = 0; // Amp Coefficient : this is basically how far from the origin we are.
//int elements = 128;// This is the number of points and lines we will calculate at once. 1000 is alot actually. 
float threshold = 0.15;// try increasing this if it jumps around too much
int wait=0;
boolean playit;
ArrayList<Planet> planetList = new ArrayList<Planet>();
ArrayList<Integer> planetRemoveList = new ArrayList<Integer>();

void setup() {
  //The size is iPad Portrait.
  //If you want landscape, you should swap the values.
  // comment out if you are on Android!
  size(768, 1024, OPENGL);
  noStroke();
  maxim = new Maxim(this);
  player = maxim.loadFile("run.wav");
  player.setLooping(true);
  player.volume(1.0);
  player.setAnalysing(true);
  rectMode(CENTER);
  background(0);
  colorMode(HSB);
}

void draw() {
  float bass, mid, treb;
  int avgPower;
  float power = 0;
  float[] spec;
  planetRemoveList.clear();
  if (playit) {
    lights();
    player.play();
    power = player.getAveragePower();
    spec = player.getPowerSpectrum();
    bass = (spec[3]*100);
    mid = (spec[250]*100);
    treb = (spec[500]*100);
//    println("power="+power);
//    println("treb=" + treb);
//    println("amp=" + amp);
    //println(power);
    //detect a beat
    if (power > threshold && wait<0) {
      //println("boom");
      //a beat was detected. Now we can do something about it
      avgPower=(int)(power*100);
      //println("avgPower=" + avgPower);
      if (bass >15.0) planetGen((int)avgPower, bass, 3);
      if (mid >15.0) planetGen((int)avgPower, mid, 250);
      if (treb >15.0) planetGen((int)avgPower, treb, 500);
//      println("power=" + power);
//      println("amp=" + amp); 
      wait+=10; //let's wait a bit before we look for another beat
    }
    wait--;// counting down...
  }
//  spec = player.getPowerSpectrum();
//  translate(spec[10]*2,spec[511]*3);
    background(255);
    lights();
    for (int k=0;k<planetList.size();k++){
      if(planetList.get(k).getDepth() >800){
        planetRemoveList.add(k);
      }
      planetList.get(k).display();
    }
    for (int h=0; h<planetRemoveList.size();h++){
      planetList.remove((int)planetRemoveList.get(h));
    }
    //println(planetList.size());
}
void planetGen(int _avgPower, float _amp, int _spectrum){
  int planets = (int)map(_avgPower, 20,30,1,4);
  int orbs = (int)map(_avgPower, 20,30,1,5);
  int speed = (int)map(_amp,15,60,5,15);
  //println("speed=" + speed);
  Planet tempPlanet = new Planet(planets, 20, speed, orbs, _spectrum);  //elements,size,speed,orbs
  planetList.add(tempPlanet);
}
void mousePressed() {
    playit = !playit; 
    if (playit) {
         player.play(); 
    } else {
     player.stop(); 
    }
}
class Planet{
  int elements, size, depth, colorVal, speed, orbs, amp, spectrum;
  int[] initVals = {(int)random(3),(int)random(4),1};  //xyz rotation
  ArrayList<int[]> planetPos = new ArrayList<int[]>();
  Orbiter orb1;   
  Planet(int _elements, int _size, int _speed, int _orbs, int _spectrum){
    elements = _elements;
    size = _size;
    speed = _speed;
    spectrum = _spectrum;
    colorVal = (int)map(spectrum, 0, 511, 50, 240);
    orbs = _orbs;
    orb1 = new Orbiter(orbs, 5, initVals);
    for(int m=0;m<elements;m++){
      int[] tempPos = {(int)random(width),(int)random(height)}; //establishes random location of planet
      planetPos.add(tempPos);
    }
  }
  void display(){
    depth += speed;
    for (int i=0;i<elements;i++){
      fill(colorVal, 225, 255);
      pushMatrix();
      //float period = sin(radians(frameCount));
      int tx = (int)(planetPos.get(i)[0]);
      int ty = (int)(planetPos.get(i)[1]);
      //int tz = (int)sin(radians(frameCount));
      translate(tx, ty, depth);  //makes planet and orbiters smaller
      rotateZ(radians(frameCount*(i+1)));
      rotateY(radians(frameCount*(i+1)));
      rotateX(PI/(i+20));
      box(size);
      popMatrix();
      pushMatrix();
      translate(tx+10,ty+10, 1);  //puts orbiters around planet
      orb1.display(depth);
      popMatrix();
    }
  }
  Integer getDepth(){
    return depth;
  }
}

class Orbiter{
  int elements, size, dir, depth, offset;
  int vector[]=new int[3];
  float r = 0;
  Orbiter(int _elements, int _size,int[] _vector){
    elements = _elements;
    size = _size;
    vector[0] = _vector[0];
    vector[1] = _vector[1];
    vector[2] = _vector[2];
    offset = (int)random(frameCount);
  }
  void display(int depth){
    if (abs(depth)>=2000){
      elements = 0;
    }
    for(int j=0;j<elements;j++){
      dir = 1;
      fill(100+j*10, 225, 255);
      r=((offset+frameCount)*(j+1))/100.00;
      pushMatrix();
      rotate(r,vector[1],vector[2],r);
      if(j%2==0) dir=-1;
      translate(0,(j+2)*size*dir+dir*2,depth);
      rotateY(radians(frameCount*(j+1)));      
      rotateX(PI/(j+10));
      box(size);
      popMatrix();
    }
  }
}  
  
  
