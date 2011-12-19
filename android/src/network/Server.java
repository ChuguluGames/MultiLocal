package network;

import java.io.IOException;
import java.util.Enumeration;
import java.util.logging.ConsoleHandler;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import javax.jmdns.JmDNS;
import javax.jmdns.ServiceInfo;

import java.io.*;
import java.net.*;

public class Server {

  static String host = "192.168.10.122";
  static int port = 50961;
  private ServerSocket socket = null;
  private PrintWriter out = null;
  private boolean connected = false;

  /*
  * Starting the server
  */
  public void publish() {

    System.out.println("starting server");

    startServer();
    startService();
  }

  private void startServer() {
    Thread serverThread = new Thread(new ServerThread());
    serverThread.start();    
  }

  private void startService() {
    System.out.println("starting server service");

    try {
      JmDNS jmdns = JmDNS.create();

      ServiceInfo info = ServiceInfo.create("_chuguluMulti._tcp.local.", "server_android", 4242, "androidservice");
      jmdns.registerService(info);

      
    } catch (IOException e) {
      e.printStackTrace();
      connected = false;
    }     
  }

  public void sendToAll() {
    
  }
  
  public void sendToWithName() {
    
  }    

  public void sendTo() {
    
  }

  public void onCreate() {
    
  }

  public void onConnection() {
    
  }
  
  public void onDisconnection() {
    
  }
  
  public void onMessage() {
    
  }
  
  public void onError(String error) {
    
  }  
  
  public class ServerThread implements Runnable {
    public void run() {
      try {
        socket = new ServerSocket(port);
        while (connected) {
          // create a thread for each new client
          Thread client = new Thread(new ClientThread(socket.accept()));
          client.start();
        }

      } catch(Exception e) {
        
      }
    }
  }

  public class ClientThread implements Runnable {

    private Socket socketClient = null;
    private boolean connectedClient = false;
    private PrintWriter outClient = null;

    public ClientThread(Socket socketClient) {
      socketClient = socketClient;
    }

    public void run() {
      try {

        // get server socket input
        BufferedReader in = new BufferedReader(new InputStreamReader(socketClient.getInputStream()));
        // get server socket output
        outClient = new PrintWriter(socketClient.getOutputStream(), true);

        connectedClient = true;
        
        // Start listenning the client  
        while (connectedClient) {
          String response = in.readLine();
          System.out.println(response);
        }

        in.close();
        outClient.close();  
        socketClient.close();

      } catch (Exception e) {
        e.printStackTrace();
        connectedClient = false;
      }    
    }
  }

}