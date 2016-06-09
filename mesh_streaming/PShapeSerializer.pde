class PShapeSerializer {
  
  private final byte[] marker = "MESHDATA".getBytes();
  
  public byte[] serialize(PShape shape) {
    
    if (shape == null) {
      // oh no!
      println("ERROR! PShape is null in serializer.");
      return null;
    }
    
    int vertexCount = shape.getVertexCount();
        
    int positionCount      = vertexCount; // x, y, z tripplets
    int colorCount         = vertexCount; // r, g, b tripplets
    int indexCount         = vertexCount;
    
    int headerDataByteCount   = 16;
    int positionDataByteCount = positionCount * 3 * 4;
    int colorDataByteCount    = colorCount * 3;
    int indexDataByteCount    = indexCount * 3 * 2;
    
    int packetSize = headerDataByteCount + positionDataByteCount + colorDataByteCount + indexDataByteCount;
    
    byte[] packet = new byte[packetSize];
    
    System.arraycopy(marker, 0, packet, 0, marker.length);
    
    int endOfMarker = marker.length;
    putInt16(packet, endOfMarker, positionCount);
    putInt16(packet, endOfMarker + 2, colorCount);
    putInt16(packet, endOfMarker + 4, indexCount / 3);
    
    int positionDataStart = 16;
    int colorDataStart    = positionDataStart + positionDataByteCount;
    int indexDataStart    = colorDataStart + colorDataByteCount;
    
    for(int i = 0; i < shape.getVertexCount(); i++) { //<>//

      PVector position = shape.getVertex(i);
      int vertexColor  = shape.getFill(i);
      
      // encode the position data
      putFloat(packet, positionDataStart + (i * 12),     position.x);
      putFloat(packet, positionDataStart + (i * 12) + 4, position.y);
      putFloat(packet, positionDataStart + (i * 12) + 8, position.z);
      
      byte r = (byte)((vertexColor >> 16) & 0xff);
      byte g = (byte)((vertexColor >> 8) & 0xff);
      byte b = (byte)((vertexColor) & 0xff);
      
      packet[colorDataStart + (i * 3)] = r;
      packet[colorDataStart + (i * 3) + 1] = g;
      packet[colorDataStart + (i * 3) + 2] = b;
      
      putInt16(packet, indexDataStart + (i * 2), i);
    }
    
    
    return packet;
  }
  
  
  void putInt16(byte[] destination, int offset, int value) {
    byte firstByte = (byte)(value & 0xff);
    byte secondByte = (byte)((value >> 8) & 0xff);
    
    destination[offset]     = firstByte;
    destination[offset + 1] = secondByte;    
  }
  
  void putFloat(byte[] destination, int offset, float value) {
    int floatBits = Float.floatToRawIntBits(value);
    
    destination[offset]     = (byte)(floatBits & 0xff);;
    destination[offset + 1] = (byte)((floatBits >> 8) & 0xff);   
    destination[offset + 2] = (byte)((floatBits >> 16) & 0xff);
    destination[offset + 3] = (byte)((floatBits >> 24) & 0xff);
  }
}