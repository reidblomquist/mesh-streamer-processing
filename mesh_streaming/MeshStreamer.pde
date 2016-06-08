import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

class MeshStreamer {
  // Constructor vars
  String author;
  String title;
  int desiredSlot;

  // Data containers

  // Stream buffers


  MeshStreamer(String _author, String _title, int _desiredSlot) {
    author = _author;
    title = _title;
    desiredSlot = _desiredSlot;
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
    try {
      sendFrame(payload);
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }
  }

  void getSlots() {
  }

  void registerSlot() {
  }

  void updateBuffers(int positionCount, int colorCount, int indexCount) {
    int positionDataCount = positionCount;
    int colorDataCount = colorCount;
    int indexDataCount = indexCount;

    int headerSize = 16;

    int positionDataSize = positionDataCount;//wat? TODO: fix these to actually be right
    int colorDataSize = colorDataCount;
    int indexDataSize = indexDataCount;
    int payloadSize = positionDataSize + colorDataSize + indexDataSize;

    int dataSize = headerSize + payloadSize;
  }

  String sendFrame(String query) throws IOException {
    // Encode the query
    String encodedQuery = URLEncoder.encode(query, "UTF-8");
    // This is the data that is going to be send to itcuties.com via POST request
    // 'e' parameter contains data to echo
    String postData = "e=" + encodedQuery;

    // Connect to google.com
    URL url = new URL("http://echo.itcuties.com");
    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
    connection.setDoOutput(true);
    connection.setRequestMethod("POST");
    connection.setRequestProperty("Content-Type", "application/octet-stream");
    connection.setRequestProperty("Content-Length",  String.valueOf(postData.length()));

    // Write data
    OutputStream os = connection.getOutputStream();
    os.write(postData.getBytes());

    // Read response
    StringBuilder responseSB = new StringBuilder();
    BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream()));

    String line;
    while ( (line = br.readLine()) != null)
      responseSB.append(line);

    // Close streams
    br.close();
    os.close();

    return responseSB.toString();
  }

  vate void unregister(int index, String key) {
  }
}
