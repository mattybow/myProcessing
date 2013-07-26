class ChainManager {
  ArrayList<Chain> chain;

  ChainManager() {
    chain = new ArrayList<Chain>();
  }

  void draw() {
    Iterator<Chain> it = chain.iterator();
    while (it.hasNext ()) {
      Chain p = it.next();
      p.draw();
      p.update();
      if (auto)
        p.moveEnd(auto1.x, auto1.y);
      else
        p.moveEnd(mouseX, mouseY);
    }
  }

  void setColors(color c) {
    Iterator<Chain> it = chain.iterator();
    while (it.hasNext ()) {
      Chain p = it.next();
      p.setColor( setGoodColor() );
    }
  }

  void pushPos(ParticleSystem physics, int n) { 
    for (int  i =0; i < n; i++)
      push(physics, new PVector(50, height/2), new PVector(width - 100, height/2));
  }

  void push(ParticleSystem physics, PVector init, PVector end) {
    chain.add(new Chain(physics, init, end));
  }

  void pushCircle(ParticleSystem physics, int n) {
    for (int i =0; i < n; i++) {
      addCircle(physics, n);
    }
  }

  void addCircle(ParticleSystem physics, int n) {
    float step = (TWO_PI/n)* (chain.size() - 1);
    chain.add(new Chain(physics, new PVector(width/2 + cos(step)*(radioChords + random(-5, 5) ), height/2 + sin(step)*(radioChords + random(-5, 5)) ), new PVector(width/2, height/2)));
  }

  void pop() {
    chain.remove( chain.size() -1 );
  }
}

