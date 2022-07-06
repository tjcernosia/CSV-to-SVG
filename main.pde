
int numExportedFiles = 8;

String filename = "data.csv";
String exportFilePath = "/svg/";
String exportFileName = "data";

Table t;
TableRow tr;
float[] x;
float[] y;
float[] z;
float[][] xyz;

void setup(){
  t = loadTable(filename);
  x = t.getFloatColumn(3);
  y = t.getFloatColumn(4);
  z = t.getFloatColumn(5);
  xyz = new float[3][];
  xyz[0] = x;
  xyz[1] = y;
  xyz[2] = z;
  noLoop();
}

void draw(){
  
}
