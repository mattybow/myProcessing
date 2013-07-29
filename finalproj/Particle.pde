public class Particle{
  PVector pos, vel, acc;
  int c, s, alpha, age, ageMax;
  float r;
  Particle(int i_color){
    pos = new PVector(random(10,50),0,0);
    vel = new PVector(0,0,random(.03,.04)*pos.x);
    s = 2;
    c = (int)random(i_color-10,i_color+10);
    r = random(0,TWO_PI);
    alpha = 100;
    age = 0;
    ageMax = 1000;
  }
  void update(){
    float rand=random(-1,1);
    int randDir = (int)(rand/abs(rand));
    float drg = (noise(pos.x/20+492,pos.y/20+490,frameCount/50.2)-0.5)/300 + 1.05;
    vel.x/=drg;
    r += .01;
    vel.x+=noise(pos.x,pos.y,pos.z)-.45;
  }
  void display(){
    update();
    age += 1;
    pos.add(vel);
    pushMatrix();
    {
      rotateZ(r);
      translate(pos.x,pos.y,pos.z);
      pushMatrix();
      {
        alpha=(int)map(age,0,ageMax,255,0);
        noStroke();
        fill(c,255,255,alpha);
        rotateX(PI/2.4);
        rect(0,0,s,s);
      }
      popMatrix();
    }
    popMatrix();
    //sphere(s);
  }
  int getAlpha(){
    return alpha;
  }
}
