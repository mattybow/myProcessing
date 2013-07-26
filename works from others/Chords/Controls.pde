ControlP5 controlP5;
ControlWindow controlWindow;

void menuSetup() {
  controlP5 = new ControlP5(this);
  controlP5.setAutoDraw(true);
  //Korg nano-kontrol automatic gui creation
  int x1 = 10;
  int y1 = 10;

  controlP5.addSlider("alphaBack", 0, 255, 80, x1, y1, 15, 100);
  controlP5.addSlider("cBackground", 0, 255, 0, x1 + 55, y1, 15, 100);
  controlP5.addSlider("stepV", 0, 1, 0.57, x1, y1 + 120, 15, 100);
  controlP5.addSlider("chordAmpV", 0, 2, 0.62, x1 + 55, y1 + 120, 15, 100);

  controlP5.addSlider("waveType", 1, 4, 50, x1 + 15, y1 + 240, 15, 100).setNumberOfTickMarks(4);

  controlP5.addToggle("autoV", true, x1+ 130, y1, 30, 30);
  controlP5.addToggle("drawColorChords", true, x1+ 130, y1 + 50, 30, 30); 
}

void autoV(){
 auto = !auto; 
}
void drawColorChords(){
  drawColorChords = !drawColorChords;
}

void waveType(int a){
  waveType = a;
}

void alphaBack(float a) {
  alphaBack = a;
}

void cBackground(float a) {
  cBackground = a;
}

void stepV(float a) {
  step = a;
}

void chordAmpV(float a) {
  chordAmp = a;
}

