public class Cloud {
  int c, alpha, age;
  PVector pos;
  Particle[] pArr;
  Cloud(int num_particles, int i_color, int x, int y, int z){
    c = i_color;
    age = 200;
    pos = new PVector(x,y,z);
    pArr = new Particle[num_particles];
    for(int i=0;i<num_particles;i++){
      pArr[i]=new Particle(c);
    }
  }
  void display(){
    pushMatrix();
    {
      translate(pos.x,pos.y,pos.z);
      for(int j=0;j<pArr.length;j++){
        pArr[j].display();
      }
    }
    popMatrix();
    age-=1;
  }
  int getAge(){
    return age;
  }
  boolean pop(){
    boolean remove=false;
    int count=0;
    for(int j=0;j<pArr.length;j++){
      if(pArr[j].getAlpha()==0) count+=1;
    }
    if(count==pArr.length){
     remove=true;
    }
    return remove;
  } 
}
