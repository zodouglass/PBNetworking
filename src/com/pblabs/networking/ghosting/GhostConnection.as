package com.pblabs.networking.ghosting
{
   import com.pblabs.engine.debug.Logger;
   import com.pblabs.networking.core.BitStream;
   import com.pblabs.networking.events.EventConnection;

   /**
    * EventConnection subclass which adds support for ghosting. This largely
    * passes control to a GhostManager.
    */ 
   public class GhostConnection extends EventConnection
   {
      /**
       * The GhostManager which manages our ghosting state.
       */ 
      public var manager:GhostManager;
      
      /**
       * Call this method to initialize ghosting over this connection.
       * 
       * @param isServer If true, we transmit ghosts. If false, we receive.
       */ 
      public function activateGhosting(isServer:Boolean = false):void
      {
         manager = new GhostManager();
         
         if(isServer)
         {
            isSendingGhosts = true;
            isReceivingGhosts = false;
         }
         else
         {
            isSendingGhosts = false;
            isReceivingGhosts = true;            
         }
      }
      
      /**
       * The object that will be used to determine what ghosts are in scope, and 
       * what priority they have.
       */ 
      public function set scopeObject(v:IScoper):void
      {
         manager.scoper = v;
      }
      
      public function get scopeObject():IScoper
      {
         if(!manager)
            return null;
         return manager.scoper;
      }
      
      public function get hasPendingData():Boolean
      {
         return true;
      }

      protected override function writePacket(bs:BitStream):void
      {
         // Give events priority.
         super.writePacket(bs);
         
         // Let the ghost manager write data.
         if(manager && isSendingGhosts)
            manager.writePacket(bs);
      }
      
      protected override function readPacket(bs:BitStream):void
      {
         // Let events read.
         super.readPacket(bs);
         
         // And give the ghosts a chance.
         if (manager && isReceivingGhosts)
            manager.readPacket(bs);
      }

      private var isSendingGhosts:Boolean = false;
      private var isReceivingGhosts:Boolean = true;
   }
}