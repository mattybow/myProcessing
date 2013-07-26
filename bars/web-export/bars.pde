ArrayList<Bar> barAr = new ArrayList<Bar>();
ArrayList<Integer> intAr = new ArrayList<Integer>();
int GRID = 20;
public class Bar{
  int s,h,z,c,posX,posY,posZ;
  float alpha;
  Bar(int vert_height, int size, int xCoord, int yCoord){
    h = vert_height;
    posX = xCoord;
    posY = yCoord;
    posZ = 100;
    s = size;
    c = (int)random(0,255);
    alpha = 255;
  }
//  int getPosX(){
//    return posX;
//  }
//  int getPosY(){
//    return posY;
//  }
  void setZ(int zValue){
    z= zValue;
  }
  void setColor(int incrementVal){
    c=(c+incrementVal)%255;
  }
  int getH(){
    return h;
  }
  void display(){
//    if (alpha > 0) {
//      alpha = alpha -2;
//&& alpha%10==0
      if(s>0) s=s-1;
//    }
    else barAr.remove(this);
    fill(c,255,255,(int)alpha);
    noStroke();
    pushMatrix();
    {
      translate(posX,posY,posZ);
      //translate(width/2,height/2);
      //rotateY(PI/4);
      rotateX(-PI/1.5);
      rotateZ(PI/5);
      for(int j=0;j<GRID;j++){
        pushMatrix();
        translate(h*j+5*j,0,0);
        box(h,h,s);
        popMatrix();
        for(int k=0;k<GRID;k++){
          pushMatrix();
          translate(h*j+5*j,h*k+5*k,0);
          box(h,h,s);
          popMatrix();
        }
      }
    }
    popMatrix();
//    println("displaying box");
  }
}

void setup(){
  size(600,500,OPENGL);
  colorMode(HSB);
//  nBar = new Bar(100,10);
}
void draw(){
  background(0);
  lights();
//  println(nBar.getH());
  //println("drawing");
  for(int i=0;i<barAr.size();i++){
    barAr.get(i).display();
    //println(barAr.size());
  }
}
void mousePressed(){
  int mX = mouseX;
  int mY = mouseY;
  Bar tempBar = new Bar(50,200,mX,mY);
  barAr.add(tempBar);
  println("barAr " + barAr);
}
/*******UNIFORM GRID DRAWN AS 1 OBJECT***********************
ArrayList<Bar> barAr = new ArrayList<Bar>();
ArrayList<Integer> intAr = new ArrayList<Integer>();
int GRID = 20;
public class Bar{
  int s,h,z,c,posX,posY,posZ;
  float alpha;
  Bar(int vert_height, int size, int xCoord, int yCoord){
    h = vert_height;
    posX = xCoord;
    posY = yCoord;
    posZ = 100;
    s = size;
    c = (int)random(0,255);
    alpha = 255;
  }
//  int getPosX(){
//    return posX;
//  }
//  int getPosY(){
//    return posY;
//  }
  void setZ(int zValue){
    z= zValue;
  }
  void setColor(int incrementVal){
    c=(c+incrementVal)%255;
  }
  int getH(){
    return h;
  }
  void display(){
//    if (alpha > 0) {
//      alpha = alpha -2;
//&& alpha%10==0
      if(s>0) s=s-1;
//    }
    else barAr.remove(this);
    fill(c,255,255,(int)alpha);
    noStroke();
    pushMatrix();
    {
      translate(posX,posY,posZ);
      //translate(width/2,height/2);
      //rotateY(PI/4);
      rotateX(-PI/1.5);
      rotateZ(PI/5);
      for(int j=0;j<GRID;j++){
        pushMatrix();
        translate(h*j+5*j,0,0);
        box(h,h,s);
        popMatrix();
        for(int k=0;k<GRID;k++){
          pushMatrix();
          translate(h*j+5*j,h*k+5*k,0);
          box(h,h,s);
          popMatrix();
        }
      }
    }
    popMatrix();
//    println("displaying box");
  }
}

void setup(){
  size(600,500,OPENGL);
  colorMode(HSB);
//  nBar = new Bar(100,10);
}
void draw(){
  background(0);
  lights();
//  println(nBar.getH());
  //println("drawing");
  for(int i=0;i<barAr.size();i++){
    barAr.get(i).display();
    //println(barAr.size());
  }
}
void mousePressed(){
  int mX = mouseX;
  int mY = mouseY;
  Bar tempBar = new Bar(50,200,mX,mY);
  barAr.add(tempBar);
  println("barAr " + barAr);
}
*/
  

