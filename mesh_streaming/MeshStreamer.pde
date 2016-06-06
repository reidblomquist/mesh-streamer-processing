class MeshStreamer {
  
  MeshStreamer() {
    // TODO: Connect to server and all that mumbo-jumbo.
  }
 
  public void sendShape(PShape shape){
    
    println("Shape has " + shape.getVertexCount() + " vertices.");
    
    for(int i = 0; i < shape.getVertexCount(); i++) {
     
      PVector position = shape.getVertex(i);
      int vertexColor  = shape.getFill(i);
      
      // TODO: encode position and color values according to the binary format.
      
      // the iterator variable 'i' will be the same as the vertex index since the PShape
      // class stores triangles without sharing vertices. Less efficient but there's not 
      // an alternative without building a custom mesh class to use in place of PShape.
    }
    
    // TODO: build the complete binary message and send it..
  }
}