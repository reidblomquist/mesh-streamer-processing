import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;

class MeshSenderHTTP {
  
  PShapeSerializer serializer = new PShapeSerializer();
  
  String rootServerUrl = "";
  String authorName = "";
  String title = "";
  
  boolean isRegistered = false;
  
  boolean needsToSend = true;
  
  int meshSlot = -1;
  int meshKey = 0;
  
  MeshSenderHTTP(String rootServerUrl, String authorName, String title) {
    
    this.rootServerUrl = rootServerUrl;
    this.authorName = authorName;
    this.title = title;
    
    JSONObject registrationMessage = new JSONObject();
    
    registrationMessage.setString("author",   this.authorName);
    registrationMessage.setString("title",    this.title);
    registrationMessage.setString("platform", "Processing");
    
    byte[] registration = registrationMessage.toString().getBytes();
    
    String responseText = doHTTPPost(this.rootServerUrl + "/mesh/register", registration);
    
    JSONObject result = JSONObject.parse(responseText);
    
    if(result.getBoolean("result")){
      isRegistered = true;
      meshKey = result.getInt("key");
      meshSlot = result.getInt("index");
    } else {
      isRegistered = false;
      println("Unable to register: " + result.getString("error"));
    }    
  }
  
  void sendFrame(PShape shape) {
    
    if(this.isRegistered && this.needsToSend) {
      doHTTPPost(this.rootServerUrl + "/mesh/" + this.meshSlot + "/frame", serializer.serialize(shape), meshKey);
      //needsToSend = false;
    }
    
  }
  
  
  
  
  
 // String sendFrame(byte[] meshFrame) throws IOException {
    
    // Encode the query
    // String encodedQuery = URLEncoder.encode(query, "UTF-8");
    // This is the data that is going to be send to itcuties.com via POST request
    // 'e' parameter contains data to echo
    // String postData = "e=" + encodedQuery;
  //}
  
  String doHTTPPost(String urlString, byte[] payload) {
    return doHTTPPost(urlString, payload, -1);
  }
  
  String doHTTPPost(String urlString, byte[] payload, int meshKey) {
    
    // Connect to google.com
    StringBuilder responseSB = new StringBuilder();
    
    try{
      URL url;
      url = new URL(urlString);
    
      HttpURLConnection connection = (HttpURLConnection) url.openConnection();
      
      connection.setDoOutput(true);
  
      
      connection.setRequestMethod("POST");
  
      connection.setRequestProperty("Content-Type", "application/octet-stream");
      connection.setRequestProperty("Content-Length",  String.valueOf(payload.length));
      
      if(meshKey != -1) {
        connection.setRequestProperty("slot-key", Integer.toString(meshKey));
      }
  
      // Write data
      OutputStream os = connection.getOutputStream();
      os.write(payload);
  
      // Read response
      
      BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
  
      String line;
      while ( (line = br.readLine()) != null)
        responseSB.append(line);
  
      // Close streams
      br.close();
      os.close();
    } catch(IOException e){
      println("Oh no, something happened.");
      e.printStackTrace();
    }
    
    return responseSB.toString();
  }
  
  void unregister(int index, String key) {
  }
}