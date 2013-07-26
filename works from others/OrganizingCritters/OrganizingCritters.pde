/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/6691*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
import controlP5.*;

ArrayList ps;
ArrayList ls;
PGraphics pg, pgA;

ControlP5 controlP5;
int ui_pane_width = 200;

public boolean no_bg = true;
public boolean pause = false;
public boolean show_trail = false;
public boolean show_brush = false;

public boolean isBounded = true;
public boolean isPeriodicBound = false;
public boolean orthographic = true;
public boolean repulse_hard = true;
public boolean repulse_bouncy = true;
public boolean show_ptcls = true;
public boolean show_vector = false;
public boolean show_network = false;
public boolean show_reff = false;
public boolean show_rview = false;

public int ptcl_count = 15;
public int attractable_count = 10;
public int max_speed = 50;
public int dimming = 0;

public int min_reff = 10;
public int max_reff = 30;
public float view_range = 3;
public float breathe_scale = 0.05;

public int Red, Green, Blue, Alpha;
public float cam_A = 0;
public float cam_Y = 300;
public float cam_Z = 500;
float p_cam_A, p_cam_Y, p_cam_Z;

Critter selectedPtcl = null;
float[] plane;

void setup()
{
  pg = createGraphics(400, 400, P3D);
  pg.background(255, 255, 255);

  pgA = createGraphics(pg.width, pg.height, P2D);
  pgA.background(255, 255, 255);

  size(pg.width + ui_pane_width, pg.height, P2D);
  background(255, 255, 255);

  Red = 100;
  Green = 100;
  Blue = 100;
  Alpha = 128;

  p_cam_A = cam_A;
  p_cam_Y = cam_Y;
  p_cam_Z = cam_Z;

  plane = new float[4];
  plane[0] = 0;
  plane[1] = 0;
  plane[2] = 1;
  plane[3] = 0;

  InitUI();
  InitParticleSystem();  
}

void InitUI()
{
  int ui_x = 10;
  int ui_y = 8;
  int ui_y_step = 10;
  int ui_y_space = 5;
  controlP5 = new ControlP5(this);

  controlP5.addToggle("pause",pause,ui_x + 90,ui_y,10,10);
  controlP5.addSlider("dimming",0,50,dimming,ui_x + 90,ui_y + 29,40,10);
  Radio r_bg = controlP5.addRadio("radio_bg",ui_x,ui_y);
  r_bg.add("no bg",0);
  r_bg.add("draw trail",1);
  r_bg.add("paint brush",2);
  r_bg.activate("draw trail");
  ui_y += ui_y_step + ui_y_space + 40;

  controlP5.addToggle("show_ptcls",show_ptcls,ui_x,ui_y,10,10);
  controlP5.addToggle("show_vector",show_vector,ui_x + 90,ui_y,10,10);
  ui_y += ui_y_step + ui_y_space + 10;
  controlP5.addSlider("Alpha",0,255,Alpha,ui_x,ui_y,128,10);
  ui_y += ui_y_step + 10;
  controlP5.addToggle("show_reff",show_reff,ui_x,ui_y,10,10);
  controlP5.addToggle("show_rview",show_rview,ui_x + 90,ui_y,10,10);
  ui_y += ui_y_step + ui_y_space + 10;
  controlP5.addSlider("view_range",1,20,view_range,ui_x,ui_y,90,10);
  ui_y += ui_y_step + ui_y_space;
  controlP5.addSlider("breathe_scale",0,2,breathe_scale,ui_x,ui_y,90,10);
  ui_y += ui_y_step + ui_y_space;
  controlP5.addToggle("show_network",show_network,ui_x,ui_y,10,10);
  controlP5.addToggle("orthographic",orthographic,ui_x + 90,ui_y + 8,10,10);
  ui_y += ui_y_step + ui_y_space + 20;

  controlP5.addSlider("cam_A",0,360,cam_A,ui_x + 90,ui_y,50,10);
  controlP5.addSlider("cam_Y",0,500,cam_Y,ui_x + 90,ui_y + 14,50,10);
  controlP5.addSlider("cam_Z",10,1000,cam_Z,ui_x + 90,ui_y + 28,50,10);

  Radio r_bound = controlP5.addRadio("radio_bound",ui_x,ui_y);
  r_bound.add("no bound",0);
  r_bound.add("bound",1);
  r_bound.add("periodic bound",2);
  r_bound.activate("periodic bound");
  ui_y += ui_y_step + ui_y_space + 30;

  controlP5.addSlider("max_speed",10,100,max_speed,ui_x,ui_y,90,10);
  ui_y += ui_y_step + ui_y_space;
  controlP5.addSlider("attractable_count",0,100,attractable_count,ui_x,ui_y,90,10);
  ui_y += ui_y_step + ui_y_space;
  controlP5.addToggle("repulse_hard",repulse_hard,ui_x,ui_y,10,10);
  controlP5.addToggle("repulse_bouncy",repulse_hard,ui_x + 90, ui_y,10,10);
  ui_y += ui_y_step + ui_y_space + 28;

  controlP5.addSlider("ptcl_count",0,200,ptcl_count,ui_x,ui_y,100,10);
  ui_y += ui_y_step + ui_y_space;
  controlP5.addSlider("min_reff",3,50,min_reff,ui_x,ui_y,90,10);
  ui_y += ui_y_step + ui_y_space;
  controlP5.addSlider("max_reff",3,50,max_reff,ui_x,ui_y,90,10);
  ui_y += ui_y_step + ui_y_space;

  controlP5.addSlider("Red",0,255,Red,ui_x,ui_y,128,10);
  ui_y += ui_y_step + 1;
  controlP5.addSlider("Green",0,255,Green,ui_x,ui_y,128,10);
  ui_y += ui_y_step + 1;
  controlP5.addSlider("Blue",0,255,Blue,ui_x,ui_y,128,10);
  ui_y += ui_y_step + 1;
}

void InitParticleSystem()
{
  ps = new ArrayList();
  ls = new ArrayList();
  for(int i = 0; i < ptcl_count; i++)
  {
    Critter c = AddNewPtcl();
    c.cR = random(0, 100);
    c.cG = random(100, 255);
    c.cB = random(200, 255);
  }
}

Critter AddNewPtcl()
{
  Critter ptcl = new Critter();
  ptcl.SetPosition(random(width), random(height));
  ptcl.vx = random(-max_speed, max_speed);
  ptcl.vy = random(-max_speed, max_speed);
  ptcl.r_eff = random(min_reff, max_reff);
  ptcl.cR = Red;
  ptcl.cG = Green;
  ptcl.cB = Blue;
  ps.add(ptcl);
  return ptcl;
}

void draw()
{
  background(255, 255, 255);
  noStroke();
  fill(64, 64, 64);
  rect(0, 0, ui_pane_width, height);
  stroke(100, 100, 100);
  line(0, 305, ui_pane_width - 1, 305);

  p_cam_A += (cam_A - p_cam_A) * 0.1;
  p_cam_Y += (cam_Y - p_cam_Y) * 0.1;
  p_cam_Z += (cam_Z - p_cam_Z) * 0.1;

  pgA.beginDraw();
  pgA.smooth();
  if(!pause)
  {
    if(no_bg || frameCount < 10)
    {
      pgA.background(255, 255, 255, 0);
    }
    if(dimming > 0)
    {
      pgA.noStroke();
      pgA.fill(0, 0, 0, dimming);
      pgA.rect(0, 0, pgA.width, pgA.height);
    }
    DrawA(pgA); 
  }
  pgA.endDraw();

  pg.beginDraw();
  pg.background(255, 255, 255, 0);
  if(!pause)
  {
    Update();
  }

  float r = p_cam_Z;
  float camX = r * cos(radians(p_cam_A));
  float camY = r * sin(radians(p_cam_A));
  if(orthographic)
  {
    pg.ortho(-pg.width * 0.5, pg.width * 0.5, -pg.height * 0.5, pg.height * 0.5, -1000, 1000);
  }
  else
  {
    pg.perspective();
  }
  pg.camera(camX, camY, p_cam_Y, 0, 0, 0, 0, 0, -1);

  pg.noStroke();
  pg.beginShape(QUADS);
  pg.textureMode(NORMALIZED);
  pg.texture(pgA);
  pg.vertex(-pg.width * 0.5, -pg.height * 0.5, 0, 0, 0);
  pg.vertex(pg.width * 0.5, -pg.height * 0.5, 0, 1, 0);
  pg.vertex(pg.width * 0.5, pg.height * 0.5, 0, 1, 1);
  pg.vertex(-pg.width * 0.5, pg.height * 0.5, 0, 0, 1);
  pg.endShape();

  pg.lights();
  pg.pushMatrix();
  pg.translate(-pg.width * 0.5, -pg.height * 0.5, 0);
  Draw(pg); 
  pg.popMatrix();
  pg.endDraw();

  image(pg, ui_pane_width, 0);

  if(ps.size() < ptcl_count)
  {
    AddNewPtcl();
  }
  if(ps.size() > ptcl_count)
  {
    ps.remove(0);
  }

  stroke(0, 0, 0);
  noFill();
  rect(0, 0, width-1, height-1);
  controlP5.draw();
}

float jx, jy, jz;

void Update()
{
  ls.clear();
  pg.noFill();
  pg.stroke(0 ,0, 0);
  for(int i = 0; i < ps.size(); i++)
  {
    Critter critter = (Critter)ps.get(i);
    critter.Update();
  }
  MoveCritter(mouseX - ui_pane_width, mouseY);
}

void Draw(PGraphics pg)
{
  pg.noFill();

  if(show_reff)
  {
    for(int i = 0; i < ps.size(); i++)
    {
      Particle ptcl = (Particle)ps.get(i);
      ptcl.DrawReff(pg);
    }
  }

  if(show_rview)
  {
    for(int i = 0; i < ps.size(); i++)
    {
      Particle ptcl = (Particle)ps.get(i);
      ptcl.DrawRview(pg);
    }
  }

  if(show_network)
  {
    pg.stroke(0, 0, 0, 64);
    for(int i = 0; i < ls.size(); i++)
    {
      Link li = (Link)ls.get(i);
      li.Draw(pg);
    }
  }

  if(show_ptcls)
  {
    if(selectedPtcl != null)
    {
      pg.stroke(255, 0, 0);
      pg.strokeWeight(2);
      pg.ellipse(selectedPtcl.x, selectedPtcl.y, selectedPtcl.R_eff * 2, selectedPtcl.R_eff * 2);
      pg.strokeWeight(1);
    }
    pg.noStroke();
    for(int i = 0; i < ps.size(); i++)
    {
      Particle ptcl = (Particle)ps.get(i);
      ptcl.Draw(pg);
    }
    for(int i = 0; i < ps.size(); i++)
    {
      Critter critter = (Critter)ps.get(i);
      critter.DrawCritter(pg);
    }
  }

  if(show_vector)
  {
    pg.stroke(255, 255, 255);
    for(int i = 0; i < ps.size(); i++)
    {
      Particle ptcl = (Particle)ps.get(i);
      ptcl.DrawV(pg);
    }
  }
}

void DrawA(PGraphics pg)
{
  if(show_trail)
  {
    for(int i = 0; i < ps.size(); i++)
    {
      Particle ptcl = (Particle)ps.get(i);
      ptcl.DrawTrail(pg);
    }
  }

  if(show_brush)
  {
    pg.noStroke();
    for(int i = 0; i < ps.size(); i++)
    {
      Particle ptcl = (Particle)ps.get(i);
      ptcl.Draw(pg);
    }
  }
}

void radio_bound(int theID) {
  switch(theID) {
    case(0):
    isBounded = false;   
    break;  
    case(1):
    isBounded = true;
    isPeriodicBound = false;
    break;  
    case(2):
    isBounded = true;
    isPeriodicBound = true;
    break;
  }
}

void radio_bg(int theID) {
  switch(theID) {
    case(0):
    no_bg = true;
    show_trail = false;
    show_brush = false;   
    break;  
    case(1):
    no_bg = false;
    show_trail = true;
    show_brush = false;
    break;  
    case(2):
    no_bg = false;
    show_trail = false;
    show_brush = true;
    break;
  }
}

void mousePressed()
{
  if(mouseX < ui_pane_width) return;

  SelectCritter(mouseX - ui_pane_width, mouseY);
}

void mouseReleased()
{
  selectedPtcl = null;
}

void SelectCritter(float x, float y)
{
  float[] pos = mpoint_on_plane(plane, x, y);
  if(pos != null)
  {
    for(int i = 0; i < ps.size(); i++)
    {
      Critter c = (Critter)ps.get(i);
      float dx = pos[0] + pg.width * 0.5 - c.x;
      float dy = pos[1] + pg.height * 0.5 - c.y;
      float dz = pos[2] - c.z;
      float d = sqrt(dx*dx + dy*dy + dz*dz);
      if(d < c.R_eff * 1.5)
      {
        selectedPtcl = c;
        break;
      }
    }
  }
  if(selectedPtcl != null) return;
  if ( x < 0 || x >= pg.width || y < 0 || y >= pg.height) return;
  PGraphics3D g3d = (PGraphics3D)pg; 
  float z = g3d.zbuffer[(int)y * pg.width + (int)x];
  pos = unproject(x, y, z);
  if(pos != null)
  {
    for(int i = 0; i < ps.size(); i++)
    {
      Critter c = (Critter)ps.get(i);
      float dx = pos[0] + pg.width * 0.5 - c.x;
      float dy = pos[1] + pg.height * 0.5 - c.y;
      float dz = pos[2] - c.z;
      float d = sqrt(dx*dx + dy*dy + dz*dz);
      if(d < c.R_eff * 1.5)
      {
        selectedPtcl = c;
        break;
      }
    }
  }
}

void MoveCritter(float x, float y)
{
  if(selectedPtcl != null)
  {
    float[] pos = mpoint_on_plane(plane, x, y);
    if(pos != null)
    {
      selectedPtcl.vx = (pos[0] + pg.width * 0.5 - selectedPtcl.x);
      selectedPtcl.vy = (pos[1] + pg.height * 0.5 - selectedPtcl.y);
    }
    
    selectedPtcl.cR = Red;
    selectedPtcl.cG = Green;
    selectedPtcl.cB = Blue;
    selectedPtcl.r_eff = (min_reff + max_reff) * 0.5;
    selectedPtcl.Update();
  }
}

float[] unproject(float x, float y, float z)
{
  float[] in = new float[4];
  float[] out = new float[4];
  in[0] = map(x, 0, pg.width, -1, 1); 
  in[1] = map(y, 0, pg.height, -1, 1); 
  in[2] = map(z, 0, 1, -1, 1);
  in[3] = 1;

  PGraphics3D g3d = (PGraphics3D)pg; 
  PMatrix3D mv = g3d.modelview.get(); 
  PMatrix3D pr = g3d.projection.get();

  mv.invert();
  pr.invert();
  mv.apply(pr);
  mv.mult(in ,out);

  if(out[3] != 0)
  {
    out[0] /= out[3];
    out[1] /= out[3];
    out[2] /= out[3];
    return out;
  } 
  return null;
}

float[] mpoint_on_plane(float[] plane, float x, float y)
{
  float[] r0 = unproject(mouseX - ui_pane_width, mouseY, 0);
  float[] r1 = unproject(mouseX - ui_pane_width, mouseY, 1);
  float[] rd = new float[3];
  rd[0] = r1[0] - r0[0];
  rd[1] = r1[1] - r0[1];
  rd[2] = r1[2] - r0[2];

  float vd = plane[0] * rd[0] + plane[1] * rd[1] + plane[2] * rd[2];
  if(vd != 0)
  {
    float v0 = -(plane[0] * r0[0] + plane[1] * r0[1] + plane[2] * r0[2] + plane[3]);
    float t = v0 / vd;
    float[] out = new float[3];
    out[0] = r0[0] + rd[0] * t;
    out[1] = r0[1] + rd[1] * t;
    out[2] = r0[2] + rd[2] * t;
    return out;
  }
  return null;
}



