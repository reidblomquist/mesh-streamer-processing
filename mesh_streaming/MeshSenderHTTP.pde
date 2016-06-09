import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

class MeshSenderHTTP {
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
