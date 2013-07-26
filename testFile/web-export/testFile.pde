ArrayList<Integer> aArray = new ArrayList<Integer>();
void setup(){
//  float vectorH=sqrt(sq(2)+sq(2));
//  println(vectorH);
//  var testAr = new Array();
//  testAr.push(1);
//  int[] test2ar = {0,0,0,0};
//  testAr.push(test2ar);
//  println(testAr.length);
//  println(testAr[-1]);
//  int[] fibArray = fibGen(10);
//  println("fibArray " + fibArray);
  size(200,300);
}

//function randOne(){
//  int randNum = floor(random(0,2));
//  if(randNum==0) return 1;
//  else return -1;
//}
//function fibGen(int number){
//  int[] result={0,1};
//  for(i=0;i<number;i++){
//    int last = result[result.length-1];
//    int last_1 = result[result.length-2];
//    int new_num=last+last_1;
//    result.push(new_num);
//  }
//  println("created fib sequence " + result);
//  return result;
//}

void draw(){
  background(255);
  strokeWeight(2);
  stroke(0,50);
  
  line(width/2,0,width/2,height/4);
  pushMatrix();
  {
  translate(100,0);
  }
  popMatrix();
  //println(randOne());
}
void mouseClicked(){
  aArray.add(0);
  println(aArray.get(-1));
}

