class Chain {
  ParticleSystem physics;
  Particle end;
  Particle start;
  Vector p;
  Vector s;
  
  java.util.List vertices;

  PVector initP;
  PVector endP;

  float angle;
  float inc;
  float nVal;
  float rest;
  int   n = 15;
  float t = 0.0;
  float amp = 100.0;

  color chordColor;

  Chain(ParticleSystem physics, PVector initP, PVector endP) {
    amp = 50 + random(-30, 30);
    inc = random(0.022, 0.029);
    nVal = random(0.2, 0.3);
    // t = random(-PI, PI);
    this.physics = physics;

    this.initP = initP;//new PVector(initP.x, initP.y);
    this.endP  = endP;//new PVector(endP.x, endP.y);
    inc = random(0.2, 0.3);

    end = physics.makeParticle(1.0, initP.x, initP.y, 0);
    end.makeFixed();
    start = physics.makeParticle(1.0, endP.x, endP.y, 0);
    start.makeFixed();

    p = new Vector();
    s = new Vector();

    p.add(start);
    for (int i=1; i < (n-1); i++) {
      p.add( physics.makeParticle(1.0, lerp(initP.x, endP.x, i/(float)(n-1) ), lerp(initP.y, endP.y, i/(float)(n-1) ), 0.0 ));
    }
    p.add(end);

    float d = dist(initP.x, initP.y, endP.x, endP.x)/(float)(n-1);

    for (int i=0; i < (n-1); i++) {
      Particle p1 = (Particle)p.get(i);
      Particle p2 = (Particle)p.get(i+1);
      s.add( physics.makeSpring(p1, p2, 1.0, 0.05, d));
    }
  }

  void draw() {

    angle = atan2(endP.y - initP.y, endP.x - initP.y );

    Vec2D[] handles=new Vec2D[n];
    for (int i=0; i<n; i++) {
      Particle p1=(Particle)p.get(i);
      handles[i]=new Vec2D(p1.position().x(), p1.position().y());
    }

    Spline2D spline = new Spline2D(handles);
    vertices = spline.computeVertices(8);

    setDraw();
  }

  void setDraw() {
    angle = PI + atan2(endP.y - initP.y, endP.x - initP.y );

    if (!drawColorChords) {
      offScreen.stroke( chordColor, 25 + noise(nVal)*50);
    }
    else {
      float mA = map(angle, 0, TWO_PI, 25, 75);
      float mG = mag(endP.x - initP.y, endP.y - initP.y)*0.2;
      offScreen.stroke(0, mA + mG + noise(nVal)*50, mG + mA + noise(nVal)*30, mA);
    }

    drawWave();
  }

  void drawWave() {
    offScreen.strokeWeight(1); 
    offScreen.noFill();
    offScreen.beginShape();
    for (int i=0; i < vertices.size();i++ ) {
      Vec2D v=(Vec2D)vertices.get(i);
      offScreen.vertex(v.x, v.y);
    }
    offScreen.endShape();
  }

  void update() {
    t += 1/24.0 +noise(nVal)/8;

    angle = PI + atan2(endP.y - initP.y, endP.x - initP.y );

    switch(waveType) {
    case 1:
      for (int i = 1; i < (n-1); i++) {
        Particle p1 = (Particle)p.get(i);
        p1.position().add(amp*chordAmp*cos(i * step + t)*sin(angle), amp*chordAmp*sin(i *step + t)*cos(angle), 0.0);
      }
      break;
    case 2:
      for (int i=1; i < (n-1); i++) {
        Particle p1 = (Particle)p.get(i);
        p1.position().add(chordAmp*log(i*step +1.0)*sin(angle), chordAmp*log(i*step +1.0)*cos(angle), 0.0);
      }
      break;
    case 3:
      for (int i=1; i < (n-1); i++) {
        Particle p1 = (Particle)p.get(i);
        p1.position().add(chordAmp*log(i*step +1.0)*sin(i*step +t), chordAmp*log(i*step +1.0)*cos(i*step +t), 0.0);
      }
      break;
    }

    nVal += inc;
  }

  void moveStart(float x, float y) {
    end.position().set(x, y, 0.0);
  }

  void moveEnd(float x, float y) {
    start.position().set(x, y, 0.0);
  }

  void setColor(color c) {
    chordColor = c;
  }

  void setColorR(float a) {
    color c = color(a, chordColor >> 8 & 0xFF, chordColor & 0xFF);
    chordColor = c;
  }

  void setColorG(float a) {
    color c = color( chordColor >> 16 & 0xFF, a, chordColor & 0xFF);
    chordColor = c;
  }

  void setColorB(float a) {
    color c = color(chordColor >> 16 & 0xFF, chordColor >> 8 & 0xFF, a);
    chordColor = c;
  }
}

