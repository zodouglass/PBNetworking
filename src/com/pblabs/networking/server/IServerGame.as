package com.pblabs.networking.server
{
   import flash.net.Socket;
   /**
    * Since Flash cannot listen on a socket, we provide a server environment.
    * This is a Tamarin-based binary which will load a SWF and look for a
    * class that implements this interface. It will deal with opening a socket
    * and listening for connections. It will also issue certain callbacks to
    * the "server game" (an implementor of this interface) so that your game
    * can run.
    */ 
   public interface IServerGame
   {
      /**
       * Called as part of server initialization. Load resources and start
       * simulation.
       */
      function onStart():void;
      
      /**
       * Called when a new connection is opened on our listen port. The Socket
       * which is passed here is already connected to whoever initiated the 
       * connection, and ready to go.
       * 
       * You will typically want to instantiate a NetworkConnection subclass and
       * call AssignSocket, passing it the socket.
       */
      function onConnection(s:Socket):void;
	  
	  /**
       * Called when a connection is closed on our listen port. 
       */
      function onDisconnect(s:Socket):void;
   }
}