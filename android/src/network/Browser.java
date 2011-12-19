package network;

import java.io.InterruptedIOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Browser  {

  public JSONArray serversArray; 
    
  public void startSearch() {
    System.out.println("Browser startSearch");

    serversArray = new JSONArray();

    onStart();

    addServer();
    onUpdate();
  }

  public void stopSearch() {
    
  }  

  private void addServer() {
    try {
      JSONObject serverObject = new JSONObject();

      // change it manually to connect to the ios server
      serverObject.put("name", "server_27");
      serverObject.put("address", "192.168.10.122");
      serverObject.put("port", 54787);

      serversArray.put(serverObject);       
    } catch (JSONException e) {
      System.out.println(e);
    }    
  }

  /* search and return a server by its name */
  public JSONObject findServerByName(String serverName) {

    try {
      for (int i = 0; i < serversArray.length(); ++i) {


          JSONObject serverObject = serversArray.getJSONObject(i);
          String aServerName = serverObject.getString("name");

          if(aServerName.equals(serverName)) {
            return serverObject;
          }
      }      
    } catch (JSONException e) {
      System.out.println(e);
    }

    return null;
  }

  public void onStart() {

  }  

  public void onUpdate() {
    
  }  
  
  public void onStop() {
    
  }  
  
  public void onError(String error) {
    
  }        
}