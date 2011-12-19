package network;

import java.io.IOException;
import java.util.Enumeration;
import java.util.logging.ConsoleHandler;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import java.io.*;
import java.net.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

public class Client {

  private String serverName;
  private String serverAddress;
  private int serverPort;
      
  private Socket socket = null;
  private PrintWriter out = null;
  private boolean connected = false;

  public Client() {

  }

  public void connectTo(JSONObject serverInfo) {

    try {

      serverName = serverInfo.getString("name");
      serverAddress = serverInfo.getString("address");
      serverPort = serverInfo.getInt("port");
      
      System.out.println("connecting to " + serverName + " " + serverAddress + " " + serverPort);

    } catch (JSONException e) {
      System.out.println(e);
    }  

    Thread clientThread = new Thread(new ClientThread());
    clientThread.start();        
  }

  public void send(String message) {
    if(connected) {

      // send it to the socket
      out.println(message);      
    } else {
     // put in queue for the next connection? 
     onError("Disconnected from the server");
    }
  }

  public void onConnection() {
    
  }

  public void onDisconnection() {
    
  }

  public void onMessage(String message) {
    
  }
  
  public void onError(String error) {
    
  }    
  
  public class ClientThread implements Runnable {

    public void run() {
      try {
        // open a socket to the server
        socket = new Socket(serverAddress, serverPort);

        // get server socket input
        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        // get server socket output
        out = new PrintWriter(socket.getOutputStream(), true);

        connected = true;

        onConnection();

        while (connected) {
          String responseString = in.readLine();
          onMessage(responseString);         
        }

        in.close();
        out.close();  
        socket.close();

      } catch (Exception e) {
        StringWriter w = new StringWriter();
        e.printStackTrace(new PrintWriter(w));
        e.printStackTrace();
        onError(w.toString());
        connected = false;
        onDisconnection();
      }    
    }
  }
}