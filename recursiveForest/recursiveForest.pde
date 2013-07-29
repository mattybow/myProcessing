/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/18807*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
// Recursive Forest
// David Andreen
// Based on Alasdair Turner's sketch (http://www.openprocessing.org/visuals/?visualID=7150)

void setup() {
  size(700,500);
  background(204);
  smooth();
  noLoop();
}

void draw() {
  noStroke();  
  fill(204,50);
  rect(0,0,width,height);
  strokeWeight(10);
  translate(random(width), height);
  scale(random(0.5,1));
  branch(0);

}

void branch(int depth) {
  if (depth<8) {
    int col = (int)map(depth,0,8,255,0);
    if (depth<4)
    {
      stroke(col);
    }
    else if (depth<6){
      stroke(col,150);
    }
    else {
      stroke(col,50);
    }
    line (0,0,0,-height/3);
    pushMatrix();
    {
      translate(0,-height/5);
      rotate(random(-PI/4,PI/4));
      scale(random(0.5,0.6));
      branch(depth+int(random(1,2)));
      if (depth<4) branch(depth + 1);
      if (depth<3) branch(depth +1);
    }
    popMatrix();
    pushMatrix();
      {
      translate(0,-height/3);
      rotate(random(-PI/4,PI/4));
      scale(random(0.6,0.75));
      branch(depth+int(random(1,1)));
    }
    popMatrix();
    if(depth==1){
      pushMatrix();
      {
        translate(0,-height/10);
        rotate(random(-PI/4,PI/4));
        scale(random(0.5,0.6));
        branch(depth+int(random(1,2)));
        branch(depth+int(random(1,2)));
      }
      popMatrix();
    }
    pushMatrix();
      {
        translate(0,-height/3);
      rotate(random(-PI/4,PI/4));
      scale(random(0.6,0.7));
      branch(depth+int(random(1,1)));
    }
    popMatrix();
    pushMatrix();
      {
        translate(0,-height/3);
      rotate(random(-PI/4,PI/4));
      scale(random(0.55,0.65));
      branch(depth+int(random(1,3)));
    }
    popMatrix();
  }
}

void mouseClicked()
{
  redraw();
}

