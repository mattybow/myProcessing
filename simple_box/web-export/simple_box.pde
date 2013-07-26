import peasy.*;
PeasyCam cam;

void setup(){
  size(400,400,OPENGL);
  colorMode(HSB);
  cam = new PeasyCam(this,400);
}
void draw(){
  background(0);
  fill(200, 255, 255);
  lights();
  noStroke();
  translate(width/2, height/2);
  rotateX(frameCount/20.0);
  rotateY(radians(frameCount));
  box(50);
}

