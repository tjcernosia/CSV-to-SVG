import processing.svg.*;

int numExportedFiles = 8;

String filename = "data.csv";
String exportFilePath = "svg/";
String exportFileName = "data";
int finalWidth = 800;
int finalHeight = 800;

Table t;
TableRow tr;
float[] x;
float[] y;
float[] z;
float[][] xyz;
int batchSize;
float maxX,minX, maxY, minY;

void setup(){
  size(800,800);
  
  //**LOAD TABLE**//
  t = loadTable(filename);
  x = t.getFloatColumn(3);
  y = t.getFloatColumn(4);
  z = t.getFloatColumn(5);
  xyz = new float[3][];
  xyz[0] = x;
  xyz[1] = y;
  xyz[2] = z;
  
  println("UNSORTED DIST: " + averageDist(xyz));
  
  xyz = distSort(xyz);
  
  println("SORTED DIST: " + averageDist(xyz));
  //**************//
  
  //**START RECORDING SVG**//
  batchSize = xyz[1].length/numExportedFiles + 1;
  minX = min(xyz[0]);
  maxX = max(xyz[0]);
  minY = min(xyz[1]);
  maxY = max(xyz[1]);
  
  noLoop();
}

void draw(){
  int idx = 0;
  int length = xyz[1].length;
  for(int i = 0; i < numExportedFiles; i++){
    
    beginRecord(SVG, exportFilePath + exportFileName + i + ".svg");
    
    for(int j = 0; idx < length && j < batchSize; j++, idx++){
      point(
        map(xyz[0][idx],minX,maxX,0, width),
        map(xyz[1][idx], minY,maxY, 0, height));
    }
    
    endRecord();
    
    println("finished svg: " + i);
  }
}

float[][] distSort(float[][] d){
  
  int length = d[0].length;
  
  float[][] r = new float[d.length][d[0].length]; 
  
  float lastX = 0, lastY = 0;
  int idx = 0;
  
  while(d[0].length > 0){
    //println((100*(float)idx/length) + "% sorted");
    int lastIdx = distHelper(lastX,lastY,d);
    lastX = d[0][lastIdx];
    lastY = d[1][lastIdx];
    
    r[0][idx] = lastX;
    r[1][idx] = lastY;
    
    d = removeCopy(distHelper(lastX, lastY, d), d);
    idx++;
  }
  
  return r;
}

int distHelper(float x1, float y1, float[][] d){
  int length = d[0].length;
  float min = 100000;
  int minIdx = 0;
  for(int i = 0; i < length; i++){
    float dist = dist(x1,y1,d[0][i],d[1][i]);
    if(dist < min){
      min = dist;
      minIdx = i;
    }
  }
  
  //println(min);
  
  return minIdx;
}

float[][] removeCopy(int idx, float[][] d){
  float[][] r = new float[3][d[0].length - 1];
  
  for(int i = 0, j = 0; i < d[0].length; i++){
    if(i != idx){
      r[0][j] = d[0][i];
      r[1][j] = d[1][i];
      j++;
    }
  }
  
  return r;
}

float averageDist(float[][] d){
  float sum = 0;
  
  for(int i = 0; i < d[0].length - 1; i++){
    sum += dist(d[0][i], d[1][i], d[0][i+1], d[1][i+1]);
  }
  
  return sum / d[0].length;
}
