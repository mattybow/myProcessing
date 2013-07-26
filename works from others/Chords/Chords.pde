/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/73697*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
import controlP5.*;
import traer.physics.*;
import toxi.geom.*;
import java.util.Vector;

ParticleSystem physics;

Automaton auto1;
ChainManager mChain;

int waveType = 3;
boolean auto = false;
boolean drawColorChords = false;

float chordAmp = 0.62;
float step     = 0.57;

int radioChords = 260;

float alphaBack = 10;
float cBackground = 0;

PGraphics offScreen;
void setup() {
  size(1024, 768);

  menuSetup(); 

  offScreen = createGraphics(width, height, P2D);

  physics = new ParticleSystem( 0.0f, 0.05f );

  mChain = new ChainManager();
  auto1  = new Automaton(width/2, height/2, 255, 255, 4);
  mChain.pushCircle(physics, 200);
  mChain.setColors(color(0, 0, 0));

  offScreen.beginDraw();
  offScreen.smooth();
  offScreen.endDraw();

  waveType = 3;
  auto = true;
  drawColorChords = true;

  chordAmp = 0.62;
  step     = 0.57;
  alphaBack = 60;
}

void draw() {
  offScreen.beginDraw();
  offScreen.noStroke();
  offScreen.fill(cBackground, alphaBack);
  offScreen.rect(0, 0, width, height);
  offScreen.endDraw();

  physics.tick();

  offScreen.beginDraw();
  mChain.draw();
  offScreen.endDraw();
  image(offScreen, 0, 0);

  auto1.generate();
}

