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
