PShape shape;

int gridSize = 10;
float scale = 1;
float noiseScale = 0.5;
 
MeshSenderHTTP meshSender;

void setup() {
  size(800, 600, P3D);
  meshSender = new MeshSenderHTTP("http://localhost:8080", "Joe", "thingy");
}


void draw() {
  float time = millis() * 0.001;
  
  // Generate a noisy grid
  
  shape = createShape();
  shape.beginShape(TRIANGLE);
  shape.noStroke();
  
  float halfGridWidth = (gridSize * scale) / 2;
  
  scale(10,10,10);
  
  // WHY?!?!
  camera(0, 20, 80, 
    0.0, 0.0, 0.0,  
    0.0, -1.0, 0.0);
  
  for(int x = 0; x < gridSize; x++){
    for(int y = 0; y < gridSize; y++){
      println((x * scale) - halfGridWidth);
      // first triangle
      shape.fill(float(x) / gridSize * 255, float(y) / gridSize * 255, 128);
      
      shape.vertex((x * scale) - halfGridWidth,       noise(x * noiseScale, y * noiseScale, time) * scale,           (y * scale) - halfGridWidth );
      shape.vertex(x * scale - halfGridWidth,         noise(x * noiseScale, (y+1) * noiseScale, time) * scale,       (y + 1) * scale - halfGridWidth);
      shape.vertex((x+1) * scale - halfGridWidth,     noise((x+1) * noiseScale, (y+1) * noiseScale, time) * scale,   (y + 1) * scale - halfGridWidth);
      
      
      // second triangle
      shape.fill(float(x) / gridSize * 255, float(y) / gridSize * 255, 128);
      shape.vertex((x+1) * scale - halfGridWidth,     noise((x+1) * noiseScale, y * noiseScale, time) * scale,       (y * scale) - halfGridWidth);
      shape.vertex(x * scale - halfGridWidth,         noise(x * noiseScale, y * noiseScale, time) * scale,            y * scale - halfGridWidth);
      shape.vertex((x+1) * scale - halfGridWidth,     noise((x+1) * noiseScale, (y+1) * noiseScale, time) * scale,   (y + 1) * scale - halfGridWidth);
      
    } 
  }
  
  shape.endShape();
  
  // Draw the shape in the center of the view
  background(64);
  translate(-gridSize * scale / 2, -gridSize * scale / 2);
  shape(shape);
  
  // Hand the shape to the streamer so it can convert it to the binary message format and send it.
   meshSender.sendFrame(shape);
}