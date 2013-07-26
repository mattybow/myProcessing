/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/173*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
import CellNoise.*;
import processing.opengl.*;
//import moviemaker.*;                               //for export video


float a = 100;                                       //important variable that control the distance between each "box"

double[] at = {0, 0, 0};                             //cell noise variables
CellDataStruct cd;
CellNoise cn;


//MovieMaker mm;                                     //for export video

boolean bg = false;                                  //black or white bg?

int DIMENSION = 5;                                   // there will be 11*11*11 of boxes in total (should be..)

Box[] boxes = new Box[(int)pow((DIMENSION*2)+1,3)];  //create array with that dimension

ArrayList connectors;                                //lines travel between boxes

void setup()
{
  size(800,500,OPENGL);
  noCursor();
  frameRate(20);
  background(0);
  // for export movie
  //mm = new MovieMaker(this,width,height,"p5test.mov", MovieMaker.JPEG, MovieMaker.HIGH,20);
  smooth();
  cn = new CellNoise(this);
  cd = new CellDataStruct(this, 3, at, cn.QUADRATIC);
  
  
  for(int i=-DIMENSION;i<DIMENSION;i++)
  {
    for(int j=-DIMENSION;j<DIMENSION;j++)
    {
      for(int k=-DIMENSION;k<DIMENSION;k++)
      {
        at[0] = i;
        at[1] = j;
        at[2] = k+frameCount*0.01;
        cd.at = at;
        cn.noise(cd);
        // initialize boxes position and color
        boxes[(i+DIMENSION)*(DIMENSION*2+1)*(DIMENSION*2+1) + (j+DIMENSION)*(DIMENSION*2+1) + (k+DIMENSION)] = new Box(i,j,k,color((float)(cd.F[0]/2*255)),3.5);
      }
    }
  }
 
 
 connectors = new ArrayList(); 
}

void draw()
{
  at[0] += 0.01;
  at[1] += 0.02;
  at[2] = frameCount*0.03;
  cd.at = at;
  cn.noise(cd);
  
  //trying to change the scale smoothly
  float damp =(float)cd.F[0]/4;
  a = a* (1-damp)+ (damp)*((float)cd.F[1]/2*800-160);
  
  //choice of background color
  if(bg)
    background(0);
  else background(255);
  if(random(1)>0.99)
  {
    bg = !bg;
  }
  
  //add new connectors
  for(int i=0;i<5;i++)
  connectors.add(new Connector());

  pushMatrix();
  
  //rotate camera by using center of screen as anchor point
  translate(width/2,height/2);
  rotateX(frameCount*noise(frameCount*0.005)*0.01);
  rotateY(frameCount*noise(frameCount*0.0015)*0.015);
  rotateZ(frameCount*noise(frameCount*0.0025)*0.025);
  
  
  for(int i=0;i<boxes.length;i++)
  {
    if(boxes[i] != null)
    boxes[i].update();
  }
  
  //my silly method to keep arraylist size to be small
  ArrayList templist = new ArrayList();
  for(int i=0;i<connectors.size();i++)
  {
    Connector temp = (Connector)connectors.get(i);
    if(!temp.complete)
    {
      temp.update();
      templist.add(temp);
    }
  }
  connectors = templist;
  
  
  popMatrix();
  
  //for export video
  //loadPixels();
  //mm.addFrame(pixels,width,height);
}

public void mousePressed() {
  //for export video
  //mm.finishMovie();
}
