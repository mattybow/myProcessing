public class Bar{
  int s,h,z,c,posX,posY,posZ;
  float alpha;
  //BAR CONSTRUCTOR
  Bar(int vert_height, int size, int xCoord, int yCoord){
    h = vert_height;
    posX = xCoord;
    posY = yCoord;
    posZ = (int)random(-200,-50);
    s = size;
    c = (int)random(180,200);
    alpha = 195;
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
  int getH(){return h;}
  void display(){
    fill(c,255,255,(int)alpha);
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
