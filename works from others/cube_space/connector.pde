class Connector
{
  Box src,dst;
  float pointU,pointV;
  float len;
  float speed;
  boolean complete;
  color col;
  
  Connector()
  {
    while(src == null)
    {
      src = boxes[(int)random(boxes.length)];
    }
    while(dst == null)
    {
      dst = boxes[(int)random(boxes.length)];
    }
    pointU = 0;
    pointV = 0;
    len = random(0.3,0.5);
    speed = random(0.1,0.2);
    complete = false;
    col = src.col;
  }
  
  void update()
  {
    pointU+=speed;
    if(pointU>1)
    {
      pointU =1;
      
    }
    if(pointU>len)
    {
      pointV+=speed;
      if(pointV>1)
      {
        pointV = 1;
        complete = true;              //object will be removed next frame
        dst.size+=random(100)+50;       //try to enlarge the destination box when arrive
      }
    }
    render();
  }
  
  void render()
  {
    stroke(col);
    strokeWeight(1);
    
    //i did this sentense in a bad manner, too long lol
    line((pointU*src.x+(1-pointU)*dst.x)*a,(pointU*src.y+(1-pointU)*dst.y)*a,(pointU*src.z+(1-pointU)*dst.z)*a,(pointV*src.x+(1-pointV)*dst.x)*a,(pointV*src.y+(1-pointV)*dst.y)*a,(pointV*src.z+(1-pointV)*dst.z)*a);
  }
}
