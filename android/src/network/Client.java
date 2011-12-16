package network;

import java.io.IOException;
import java.util.Enumeration;
import java.util.logging.ConsoleHandler;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import java.io.*;
import java.net.*;

public class Client {

  static String host = "192.168.10.122";
  static int port = 50961;
  private Socket socket = null;
  private PrintWriter out = null;
  private boolean connected = false;

  public Client() {
    Thread clientThread = new Thread(new ClientThread());
    clientThread.start();    
  }

  public void send(String message) {
    if(connected) {
      System.out.println("sending " + message);
      out.println(message);      
    }
  }
  
  public class ClientThread implements Runnable {

    public void run() {
      try {
        // open a socket to the server
        socket = new Socket(host, port);

        // get server socket input
        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        // get server socket output
        out = new PrintWriter(socket.getOutputStream(), true);

        connected = true;

        while (connected) {
          String response = in.readLine();
          System.out.println(response);
        }

        in.close();
        out.close();  
        socket.close();

      } catch (Exception e) {
        e.printStackTrace();
        connected = false;
      }    
    }
  }
}