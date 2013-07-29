public class Grid{
  ArrayList<Bar> grid1 = new ArrayList<Bar>();
  Grid(ArrayList<Bar> gridIn){
    grid1=gridIn;
  }
  void display(){
    for(int i=0;i<grid1.size();i++){
      int x_val=grid1.get(i).getX();
      int y_val=grid1.get(i).getY();
      int z_val=grid1.get(i).getZ();
      pushMatrix();
      translate(x_val,y_val,z_val);                         //draws bars from the array
      grid1.get(i).display();
      popMatrix();
    }
  }
  int settle(){    //puts all bars back to zero plane
    int complete = 0;
    for(int i=0;i<grid1.size();i++){
      Bar iBar=grid1.get(i);
      int zVal = iBar.getZ();
      complete += zVal;
      if(zVal==0){
       if(iBar.dissolve()){
         grid1.remove(iBar);
       }
      } 
      else iBar.moveZ(1);
    }
    return complete;
  }
  void mixUp(){
    for(int i=0;i<grid1.size();i++){
      grid1.get(i).setZ((int)random(-1000,-100));
    }
  }
}
