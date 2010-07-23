package com.pblabs.networking.core
{
   import flash.utils.setInterval;
   
   /**
    * Tracks active network connections. This mostly operates behind
    * the scenes; your code probably wants to use NetworkConnection (which will
    * register itself with NetworkInterface).
    */  
   public class NetworkInterface
   {
      /**
       * The singleton NetworkInterface instance.
       */
      public static function get instance():NetworkInterface
      {
         if (_instance == null)
            _instance = new NetworkInterface();
         
         return _instance;
      }
      
      private static var _instance:NetworkInterface = null;
      
      /**
       * Called when a connection is accepted by the server; this tracks
       * the connection, gives it chances to send packets, etc.
       */
      public function addConnection(conn:NetworkConnection):void
      {
         connections.push(conn);
         
         // Start getting ticks if we need. We use setInterval here because
         // ProcessManager may scale the reported time, but we need to deal
         // with the wide internet.
         if(interval == -1)
            interval = flash.utils.setInterval(tick, 100);
      }
      
      /**
       * Called when a connection has been closed and no longer requires tracking.
       */ 
      public function removeConnection(conn:NetworkConnection):void
      {
         var idx:int = connections.indexOf(conn);
         if(idx == -1)
            throw new Error("Tried to remove a non-existent connection!");
         connections.splice(idx, 1);
      }
      
      /**
       * Pass a function that takes a single NetworkConnection as an argument.
       */
      public function forEachConnection(f:Function):void
      {
         for each (var nc:NetworkConnection in connections)
            f(nc);
      }
      
      private function tick():void
      {
         // Send a packet on every connection.
         for each(var nc:NetworkConnection in connections)
         {
            nc.tick();
         }
      } 
      
      private var interval:int = -1;
      private var connections:Array = new Array();
   }
}