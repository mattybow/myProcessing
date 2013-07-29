public class Grid{
  ArrayList<Bar> grid1 = new ArrayList<Bar>();
  int[] x_range={0,width};
  int[] z_range={-100,0};
  int GRID_X = (int)(width/SQ);
  int GRID_Y = 10;
  Square[][] s_grid = new Square[GRID_X+1][GRID_Y+1];
  ArrayList<Cloud> c_grid = new ArrayList<Cloud>();

  Grid(){
  //FOR static grid
    for(int j=0;j<GRID_X;j++){
        for(int k=0;k<GRID_Y;k++){
          s_grid[j][k]=new Square(SQ*j+5*j,SQ*k+5*k);
        }
    }
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
    for(int j=0;j<GRID_X;j++){
        for(int k=0;k<GRID_Y;k++){
          s_grid[j][k].display();
        }
    }
    for(int k=0;k<c_grid.size();k++){
      Cloud i_cloud = c_grid.get(k);
      i_cloud.display();
      if (i_cloud.getAge()<=0){
        c_grid.remove(i_cloud);
      }
    }
  }
  int settle(){    //puts all bars back to zero plane
    int complete = 0;
    for(int i=0;i<grid1.size();i++){
      Bar iBar=grid1.get(i);
      int xVal=iBar.getX();
      int yVal=iBar.getY();
      int zVal=iBar.getZ();
      complete += zVal;
      if(zVal==0){
       s_grid[iBar.get_col()][iBar.get_row()].setMode();
       if (iBar.getH()==iBar.getMH()){
         c_grid.add(new Cloud(20,iBar.getC(),xVal,yVal,zVal));
       }
       if(iBar.dissolve()){
         grid1.remove(iBar);
       }
      } 
      else iBar.moveZ(2);
    }
    return complete;
  }
  void mixUp(){
    for(int i=0;i<grid1.size();i++){
      grid1.get(i).setZ((int)random(-500,-200));
    }
  }
  
  void addBar(int power, int row, int col){
    //power=>height
//    int col=(int)((i_x /width)*GRID_X); 
//    int row=(int)((i_y-height/2) / (height/2) * GRID_Y);
    int x_conv = SQ*col+5*col;
    int y_conv = SQ*row+5*row;
    grid1.add(new Bar(power,x_conv,y_conv,-60,row,col));
  }
}
