import processing.svg.*;

int numExportedFiles = 8;

String filename = "data.csv";
String exportFilePath = "svg/";
String exportFileName = "data";

Table t;
TableRow tr;
float[] x;
float[] y;
float[] z;
float[][] xyz;
int batchSize;
float maxX,minX, maxY, minY;

void setup(){
  
  //**LOAD TABLE**//
  t = loadTable(filename);
  x = t.getFloatColumn(3);
  y = t.getFloatColumn(4);
  z = t.getFloatColumn(5);
  xyz = new float[3][];
  xyz[0] = x;
  xyz[1] = y;
  xyz[2] = z;
  //**************//
  
  //**START RECORDING SVG**//
  batchSize = xyz[1].length/numExportedFiles + 1;
  minX = min(xyz[0]);
  maxX = max(xyz[0]);
  minY = min(xyz[1]);
  maxY = max(xyz[1]);
  
  size(400,400);
  
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
  }
}
