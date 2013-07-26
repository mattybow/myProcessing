/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/1081*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
import processing.opengl.*;
import javax.media.opengl.*;

int totalChildren =0;

PGraphicsOpenGL pgl;
GL gl;

boolean blackBg = false;

int pos = 0;
int posSpeed = 1;

ArrayList branches;

void setup()
{
  size(900,450,OPENGL);  
  hint(ENABLE_OPENGL_4X_SMOOTH);
  noCursor();
  smooth();
  background(255);
  colorMode(HSB);
  branches = new ArrayList();
  Branch root = new Branch(0,height/2,0,random(TWO_PI),PI,color(random(255),255,random(100)),50,30,random(-5,5));
}

void draw()
{
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.gl;
  pgl.beginGL();
  gl.glEnable(GL.GL_BLEND);
  if(blackBg)
    gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  scale(2);
  translate(width/2,height/2);
  for(int i=pos;i<min(branches.size(),pos+100);i++)
  {
    Branch temp = (Branch)branches.get(i);
    temp.draw();
  }
  pos += posSpeed;
  if(posSpeed<100)
    posSpeed++;
  pgl.endGL();
}

void mousePressed()
{
  reset();
}

void reset()
{
  if(blackBg)
    background(0);
  else background(255);
  pos = 0;
  posSpeed = 1;
  branches = new ArrayList();
  Branch root = new Branch(0,height/2,0,random(TWO_PI),PI,color(random(255),255,random(200)),50,60,random(-5,5));

}

void keyPressed()
{
  blackBg = !blackBg;
  reset();
}
