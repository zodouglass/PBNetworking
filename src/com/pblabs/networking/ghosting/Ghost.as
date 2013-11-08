package com.pblabs.networking.ghosting
{
   import com.pblabs.engine.entity.IPropertyBag;
   import com.pblabs.engine.debug.*;
   import com.pblabs.networking.core.BitStream;
   import com.pblabs.networking.elements.NetRoot;
   
   import flash.events.*;
   import flash.utils.Dictionary;
   
   /**
    * Class for managing most recent state updates over a network.
    * 
    * On the client, ghosts are created by a GhostManager, and updated and deleted
    * as their state changes.
    * 
    * On the server, ghosts are created by user code, and marked as "in scope" to
    * one or more GhostManagers, which then transmit their state to clients.
    * 
    * A note on relationships. In a client situation, a GhostManager will
    * create an instance of Ghost for each replicated object. As updates come
    * in the relevant Ghost instance is used to deserialize it and push the 
    * updates to its owner's properties.
    * 
    * In a server situation, a Ghost may be in scope for one or more 
    * GhostManagers. There will be a GhostInfo for each Ghost-GhostManager
    * context, and that is where the connection-specific dirty state tracking 
    * happens. GhostInfos are created/destroyed/updated as Ghosts move in/out of 
    * scope and their state becomes dirty.
    */
   public class Ghost
   {
      /**
       * Map GhostManagers to their GhostInfo structures.
       */
      private var infoMap:Dictionary = new Dictionary(true);

      /**
       * String passed to clients to indicate what "type" this object is - 
       * typically name of an object from the TemplateManager.
       */
      public var prototypeName:String = null;
      
      /**
       * The protocol element from the NetRoot library that will be used to
       * serialize this ghost.
       */
      public function set protocolName(v:String):void
      {
         _protocol = NetRoot.getByName(v);
         
         if(!_protocol)
            Logger.error(this, "set ProtocolName", "Could not find protocol '" + v + "'");   

         // Set everything to dirty by default so we are in a consistent state.
         _protocol.setDirtyState(0xFFFFFFFF);
      }
      
      public function get protocolName():String
      {
         if(!_protocol)
            return null;
         
         return _protocol.getName();
      }
      
      /**
       * True if we are the "master" instance of an object, the one running on a server that
       * is ghosted out to clients.
       */
      public function get isServerObject():Boolean
      {
         return owningManager == null;
      }

      /**
       * The protocol that will be used for processing this ghost's data on the wire.
       */
      public function get protocol():NetRoot
      {
         return _protocol;
      }
      
      /**
       * If we were created via ghosting, we are owned by the manager that created us.
       */
      public var owningManager:GhostManager = null;
      
      /**
       * If we were created via ghosting, we are assigned a "Ghost Index."
       */
      public var ghostIndex:int = -1;
      
      /**
       * Object whose properties we are tracking. Usually our owning Entity.
       */
      public var trackedObject:IPropertyBag;
      
      /**
       * Array of properties that we are tracking - maps properties to fields in the protocol.
       */
      [TypeHint(type="com.pblabs.networking.ghosting.TrackedProperty")]
      public var trackedProperties:Array = new Array();
      
      /**
       * Callback when the ghost goes out of scope.
       */
      public var onOutOfScope:Function = null;

      /**
       * Used to determine if we'ved touched this already in the current scope query.
       */
      public var scopeToken:int = -1;
      
      /**
       * Our scope priority (from the last scoping operation).
       */
      public var scopePriority:Number = 0.0;

      /**
       * Get the GhostInfo, if any, for this Ghost in the context of the
       * specified manager.
       */
      public function getGhostInfo(gm:GhostManager):GhostInfo
      {
         if(infoMap[gm])
            return infoMap[gm];
         return null;
      }
      
      /**
       * Register a new GhostInfo with this ghost.
       */
      public function registerGhostInfo(gi:GhostInfo):void
      {
         if(infoMap[gi.managerInstance])
            throw new Error("Already have a GhostInfo for that manager!");
         
         infoMap[gi.managerInstance] = gi;
      }
      
      /**
       * Indicate a GhostInfo is no longer valid.
       */
      public function removeGhostInfo(gi:GhostInfo):void
      {
         infoMap[gi.managerInstance] = null;
      }
      
      /**
       * Mark this ghost as having some states dirty.
       */
      public function markDirty(flags:int):void
      {
         // Hit all our GhostInfos and update their dirty flags.
         for each(var gi:GhostInfo in infoMap)
         {
            if(!gi) continue;
            gi.markDirty(flags);
         }
      }
      
      /**
       * Check for modifications to the tracked properties, and update dirty states
       * if any are found.
       */ 
      public function checkTrackedProperties():void
      {
         // Only server objects do this, as they are the ones that have to send changes
         // out the world.
         if(!isServerObject)
         {
           // Logger.print(this, "Skipping ghost as it is not a server object.");
            return;
         }
         
         var dirtyBits:int = 0;
         
         // For each property...
         for each(var tp:TrackedProperty in trackedProperties)
         {
            if(tp.initialUpdateOnly && !_firstCheck)
               continue;
               
            // Get its current value.
            var propVal:* = trackedObject.getProperty(tp.property);

            // Compare to stored value.
            if(propVal != tp.lastValue)
            {
               //Logger.print(this, "   Comparing " + propVal + " to " + tp.lastValue);
               
               // If different, mark dirty.
               dirtyBits |= _protocol.getElementDirtyBits(tp.protocolField);
               
               // Also store the new value in the protocol and the TrackedProperty.
               (_protocol.getElement(tp.protocolField) as Object).value = propVal;
               tp.lastValue = propVal;
            }
         }
		 
		 _firstCheck = false;
         
         // Set dirty bits based on what changed.
         markDirty(dirtyBits);
      }
      
      /**
       * Write state to a network packet.
       */
      public function serialize(bs:BitStream, dirtyFlags:int):void
      {
         // Stuff our dirty flags into the protocol and let it serialize!
         _protocol.setDirtyState(dirtyFlags);
         
         // Write a sentinel.
         if(GhostManager.DEBUG_SENTINELS) bs.writeByte(0xBE);
         _protocol.serialize(bs);
         if(GhostManager.DEBUG_SENTINELS) bs.writeByte(0xEF);
      }
      
      /**
       * Read state from a network packet.
       */
      public function deserialize(bs:BitStream, firstUpdate:Boolean):void
      {
         // Parse the data.
         if(GhostManager.DEBUG_SENTINELS) bs.assertByte("Pre sentinel.", 0xBE);
         _protocol.deserialize(bs);
         if(GhostManager.DEBUG_SENTINELS) bs.assertByte("Post sentinel.", 0xEF);
         
         if(!trackedObject)
            return;
         
         // Stuff values into our object.
         for each(var tp:TrackedProperty in trackedProperties)
         {
            if(tp.initialUpdateOnly && firstUpdate == false)
               continue;
            
            // Get the value from the protocol.
            var netValue:* = (_protocol.getElement(tp.protocolField) as Object).value;
            
            // Set it on the object.
            trackedObject.setProperty(tp.property, netValue);
         }
         
         // Notify people we did an update, cuz we care.
         if(trackedObject.eventDispatcher)
            trackedObject.eventDispatcher.dispatchEvent(new Event("ghostUpdateEvent"));
      }

      private var _protocol:NetRoot = null; 
	  private var _firstCheck:Boolean = true;
   }
}