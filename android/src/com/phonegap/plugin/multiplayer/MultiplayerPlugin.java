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

public class MultiplayerPlugin extends Plugin {

  private Client client = null;
  private Browser browser = null;
  private Server server = null;

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
    JSONObject response = new JSONObject();

    // this.ctx.sendJavascript("alert('from natif')");

    System.out.println("calling " + action);

    /* create a server */
    if (action.equals("createServer")) {
      server = new Server();
      server.publish();

      result = new PluginResult( Status.OK );

    /* connect to a server */
    } else if (action.equals("connectToServer")) {

      client = new Client();
      client.send("hello");

      result = new PluginResult( Status.OK );

    /* send data to a server */
    } else if (action.equals("sendToServer")) {

      client.send("a message");

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

      // browser = new Browser();
      // browser.startSearch();

      result = new PluginResult( Status.OK );

    /* stop the servers searching */  
    } else if (action.equals("stopSearchServers")) {

      // browser.stopSearch();

      result = new PluginResult( Status.OK );
    
    } else {
      result = new PluginResult(Status.INVALID_ACTION);
      // Log.d( "MultiplayerPlugin", "Invalid action : " + action + " passed");
    }

    return result;
  };

}