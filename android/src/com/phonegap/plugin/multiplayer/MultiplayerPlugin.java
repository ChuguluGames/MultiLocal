package com.phonegap.plugin.multiplayer;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.api.PluginResult.Status;

import network.Browser;
import network.Client;
import network.Server;

/*
try to send back some js data directly
try to send data asynchronisly
delegate the class events
*/

/*
le mieu est davoir une class qui gere tous les events et qui switch en fonction de levent
genre on envoie un params 


list des events a gerer:
browser:
  - onUpdate
client:
  - onConnection
  - onDisconnection
  - onMessage
  - onError
server:
  - onCreate
  - onConnection
  - onDisconnection
  - onMessage
  - onError
*/


public class MultiplayerPlugin extends Plugin {

  private ClientDelegate client = null;
  private BrowserDelegate browser = null;
  private ServerDelegate server = null;

  /*
  * Executes the request and returns PluginResult.
  *
  * @param action action to perform. Allowed values: turnOn, turnOff, toggle, isOn, isCapable
  * @param data input data, currently not in use
  * @param callbackId The callback id used when calling back into JavaScript.
  * @return A PluginResult object with a status and message.
  *
  * @see com.phonegap.api.Plugin#execute(java.lang.String,
  * org.json.JSONArray, java.lang.String)
  */
  @Override
  public PluginResult execute(String action, JSONArray data, String callbackId) {

    PluginResult result = null;
    JSONObject response = null;

    try {
      response = data.getJSONObject(0);
        
    } catch (JSONException e) {
      System.out.println(e);
    }

    System.out.println(response);
    System.out.println("calling " + action);

    /* create a server */
    if (action.equals("createServer")) {

      server = new ServerDelegate();
      server.publish();

      result = new PluginResult( Status.OK );

    /* connect to a server */
    } else if (action.equals("connectToServer")) {

      // creating the client
      client = new ClientDelegate();

      // connect to the specified server
      try {
        String serverName = response.getString("name");
        JSONObject serverObject = browser.findServerByName(serverName);
        client.connectTo(serverObject);

      } catch (JSONException e) {
        System.out.println(e);
      }

      result = new PluginResult( Status.OK );

    /* send data to the server */
    } else if (action.equals("sendToServer")) {

      try {
        String message = response.getString("message");
        client.send(message);

      } catch (JSONException e) {
        System.out.println(e);
      }     

      result = new PluginResult( Status.OK );

    /* send data to all the server clients */  
    } else if (action.equals("sendToAllClients")) {

      result = new PluginResult( Status.OK );

    /* send data to the clients server list */  
    } else if (action.equals("sendToClientsFromList")) {

      result = new PluginResult( Status.OK );

    /* send data to a specific client */  
    } else if (action.equals("sendToClient")) {

      result = new PluginResult( Status.OK );

    /* search the available servers */  
    } else if (action.equals("searchServers")) {

      browser = new BrowserDelegate();
      browser.startSearch();

      result = new PluginResult( Status.OK );

    /* stop the servers searching */  
    } else if (action.equals("stopSearchServers")) {

      browser.stopSearch();

      result = new PluginResult( Status.OK );
    
    } else {
      result = new PluginResult(Status.INVALID_ACTION);
      // Log.d( "MultiplayerPlugin", "Invalid action : " + action + " passed");
    }

    return result;
  };

  public void sendJavascript(String object, String event, String data) {
    ctx.sendJavascript("window.plugins.Multiplayer.events." + object + "." + event + "(" + data + ")");
  }

  public void sendJavascript(String object, String event) {
    ctx.sendJavascript("window.plugins.Multiplayer.events." + object + "." + event + "()");
  }

  public class BrowserDelegate extends Browser {

    @Override
    public void onStart() {
      System.out.println("Browser extends onStart");
      sendJavascript("browser", "onStart");
    }

    @Override
    public void onStop() {
      sendJavascript("browser", "onStop");
    }

    @Override
    public void onUpdate() {
      System.out.println("Browser extends onUpdate");

      try {
        JSONObject responseObject = new JSONObject();
        responseObject.put("servers", this.serversArray); 

        String responseString = responseObject.toString();
        System.out.println(responseString);
          
        sendJavascript("browser", "onUpdate", responseString);
          
      } catch (JSONException e) {
        System.out.println(e);
      }
     
    }

    @Override
    public void onError(String error) {
      try {
        JSONObject responseObject = new JSONObject();
        responseObject.put("error", error); 

        String responseString = responseObject.toString();
        System.out.println(responseString);
          
        sendJavascript("browser", "onError", responseString);


      } catch (JSONException e) {
        System.out.println(e);
      }      
    }

  }

  public class ClientDelegate extends Client {
    @Override
    public void onConnection() {
      sendJavascript("client", "onConnection");
    }

    @Override
    public void onDisconnection() {
      sendJavascript("client", "onDisconnection");
    }

    @Override
    public void onMessage(String message) {
      System.out.println("CLient extends onMessage");

      try {
        JSONObject responseObject = new JSONObject();
        responseObject.put("message", message); 

        String responseString = responseObject.toString();
        System.out.println(responseString);
          
        sendJavascript("client", "onMessage", responseString);
          
      } catch (JSONException e) {
        System.out.println(e);
      }
    }
    
    @Override
    public void onError(String error) {
      try {
        JSONObject responseObject = new JSONObject();
        responseObject.put("error", error); 

        String responseString = responseObject.toString();
        System.out.println(responseString);
          
        sendJavascript("client", "onError", responseString);


      } catch (JSONException e) {
        System.out.println(e);
      }      
    }        
  }

  public class ServerDelegate extends Server {
    @Override
    public void onCreate() {
      sendJavascript("server", "onCreate", "");
    }

    @Override
    public void onConnection() {
      sendJavascript("server", "onConnection", "");
    }
    
    @Override
    public void onDisconnection() {
      sendJavascript("server", "onDisconnection", "");
    }
    
    @Override
    public void onMessage() {
      sendJavascript("server", "onMessage", "");
    }
    
    @Override
    public void onError(String error) {
      try {
        JSONObject responseObject = new JSONObject();
        responseObject.put("error", error); 

        String responseString = responseObject.toString();
        System.out.println(responseString);
          
        sendJavascript("server", "onError", responseString);


      } catch (JSONException e) {
        System.out.println(e);
      }      
    }                

  }    

}