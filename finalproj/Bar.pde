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
