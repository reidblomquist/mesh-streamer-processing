MeshStreamer streamer;
PShape shape;

int gridSize = 10;
float scale = 20;
float noiseScale = 0.5;


void setup() {
  size(800, 600, P3D);
  streamer = new MeshStreamer();
} //<>//


void draw() {
  
  // center the camera in world coordinate space
  translate(width / 2, height / 2, 300); //<>//
  
  // tilt the view a little.
  rotateX(20);
  
  
  float time = millis() * 0.001;
  
  // Generate a noisy grid
  
  shape = createShape();
  shape.beginShape(TRIANGLE);
  shape.noStroke();
  
  for(int x = 0; x < gridSize; x++){
    for(int y = 0; y < gridSize; y++){
      
      // first triangle
      shape.fill(float(x) / gridSize * 255, float(y) / gridSize * 255, 128);
      shape.vertex((x * scale), (y * scale),       noise(x * noiseScale, y * noiseScale, time) * scale);
      shape.vertex((x+1) * scale, (y+1) * scale,   noise((x+1) * noiseScale, (y+1) * noiseScale, time) * scale);
      shape.vertex(x * scale, (y + 1) * scale,     noise(x * noiseScale, (y+1) * noiseScale, time) * scale);
      
      // second triangle
      shape.fill(float(x) / gridSize * 255, float(y) / gridSize * 255, 128);
      shape.vertex((x+1) * scale, (y * scale),     noise((x+1) * noiseScale, y * noiseScale, time) * scale);
      shape.vertex((x+1) * scale, (y+1) * scale,   noise((x+1) * noiseScale, (y+1) * noiseScale, time) * scale);
      shape.vertex(x * scale, y * scale,           noise(x * noiseScale, y * noiseScale, time) * scale);
    } 
  }
  
  shape.endShape();
  
  
  // Draw the shape in the center of the view
  background(64);
  translate(-gridSize * scale / 2, -gridSize * scale / 2);
  shape(shape);
  
  // Hand the shape to the streamer so it can convert it to the binary message format and send it.
  streamer.sendShape(shape);
}