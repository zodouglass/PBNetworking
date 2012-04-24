package com.pblabs.networking.ghosting
{
   import com.pblabs.engine.entity.*;
   import com.pblabs.engine.core.*;
   import com.pblabs.engine.debug.*;
   import com.pblabs.engine.resource.*;
   import com.pblabs.networking.core.*;
   import com.pblabs.networking.elements.*;
   import com.pblabs.networking.events.*;
   
   import flash.errors.*;
   
   /**
    * Manage ghosts across a connection. This is used in two ways. Internally
    * by GhostConnection and pals, and as a component which will automatically
    * connect to a 
    */
   public class GhostManager
   {
      /**
       * Set this to true to enable debug sentinels in the network stream.
       * Both ends must have this on/off.
       */
      public static var DEBUG_SENTINELS:Boolean = false;
      
      public var connection:GhostConnection = null;
      
      /**
       * What object is responsible for scoping? Until this is set, ghosting
       * cannot occur (since there won't be anything indicating what ghosts
       * to look at!).
       */
      public var scoper:IScoper;
      
      /**
       * This object is responsible for creating new object instances with
       * associated ghosts, and returning the ghost to us for further processing.
       */
      public var instanceFactory:IGhostFactory;
      
      public function GhostManager()
      {
         setGhostBitCount(ghostBitCount);
         instanceFactory = new TemplateGhostFactory();
      }
      
      /**
       * Set the number of bits we will use to encode ghost IDs. This affects
       * a variety of secondary things. If you change it during a ghosting session,
       * you will suffer, since it truncates structures with no regard for what's
       * in them and does not inform the other end about the change!
       */
      public function setGhostBitCount(count:int):void
      {
         ghostBitCount = count;
         maxGhostCount = 1 << ghostBitCount;
         ghostMap.length = maxGhostCount;
      }

      /**
       * Perform scoping and write as many ghost updates as will fit in the
       * BitStream.
       */
      public function writePacket(bs:BitStream):void
      {
         // Scope and prioritize.
         doScopeQuery();
         
         //Logger.Print(this, "Beginning ghost serialization for " + pendingUpdates.length + " ghosts");
         var startPos:Number = bs.currentPosition;
         
         if(DEBUG_SENTINELS) bs.writeByte(0x1A);
         
         // Then, write pending updates until the bitstream is full.
         while(bs.remainingBits > (ghostBitCount + 5) && pendingUpdates.length > 0)
         {
            // Get the first guy on the list. TODO: Reverse order so this isn't O(n^2)
            var curGhost:GhostInfo = pendingUpdates.shift();
            
            // If it is ghosted and has no updates, we can skip it.
            if(!curGhost.shouldKill && curGhost.isGhosted == true && curGhost.dirtyFlags == 0)
               continue;
            
            // Speculatively write this update. If it fails, back up and indicate the stream has ended.
            var lastStreamPos:int = bs.currentPosition;
            
            try
            {
               // Indicate we have another ghost.
               bs.writeFlag(true);

               if(DEBUG_SENTINELS) bs.writeByte(0x1B);
               
               // Determine the ghost's id.
               var id:int = findGhostId(curGhost.ghostInstance);
               if(id==-1)
                  throw new Error("All ghosts must have an ID by the time we start writing a packet!");
               
               // Note it in the stream.
               bs.writeInt(id, ghostBitCount);
               
               // Check if the existing ghost is marked for death.
               if(bs.writeFlag(curGhost.shouldKill))
               {
                  // Clear out the ghost info. Safe to do shere because we have written all we need to.
                  detachGhost(curGhost.ghostInstance);
                  
                  // And move on to next ghost.
                  continue;                     
               }
               
               // Is this the first update for this id?
               if(!curGhost.isGhosted)
               {
                  if(curGhost.ghostInstance.prototypeName == null)
                     throw new Error("Warning - you did not set GhostInstance.PrototypeName so the ghosting system will not be able to instantiate a proxy!");
                  
                  // Yes, new ghost. Write its template name so the other end can make it.
                  bs.stringCache.write(bs, curGhost.ghostInstance.prototypeName);
				  var entityName:String = curGhost.ghostInstance.entityName == null ? "0" : curGhost.ghostInstance.entityName; //used to indicate null value and avoid bitstream eof error
				  bs.stringCache.write(bs, entityName );
				  
				  //bs.stringCache.write(bs, "TestGhostName"); //testing
               }
               
               // Serialize this ghost.
               curGhost.ghostInstance.serialize(bs, curGhost.dirtyFlags);
            }
            catch(e:EOFError)
            {
               // Ran out of space, so roll back.
               bs.currentPosition = lastStreamPos;
               
               // And leave the loop.
               break;
            }
   
            // It has been ghosted at this point.
            curGhost.isGhosted = true;
   
            // Mark it as updated.
            curGhost.markUpdated();
         }
         
         // Ok, write a terminating flag, and we're done.
         bs.writeFlag(false);
         
         // Report and wipe pending updates; we regenerate next time around.
         _sizeOfLastUpdate = bs.currentPosition - startPos;
         //Logger.Print(this, "Wrote " + _SizeOfLastUpdate + " bits. There are " + pendingUpdates.length + " ghosts waiting for update");
         
         // Wipe the pending list.
         pendingUpdates.length = 0;
      }
      
      /**
       * Read ghost updates from a BitStream, and apply them to ghosts.
       */
      public function readPacket(bs:BitStream):void
      {
		 // Logger.print(this, "readPacket");
         if(DEBUG_SENTINELS) bs.assertByte("Packet pre sentinel", 0x1A);
         
         while(bs.readFlag())
         {
            if(DEBUG_SENTINELS) bs.assertByte("Ghost pre sentinel", 0x1B);
            
            // What ghost ID does this update pertain to?
            var ghostId:int = bs.readInt(ghostBitCount);
            
            // Are we deleting it?
            if(bs.readFlag())
            {
               // Sanity check.
               if(ghostMap[ghostId] == null)
                  throw new Error("Trying to delete a ghost ID that has no ghost!");

               (ghostMap[ghostId] as Ghost).onOutOfScope();
               (ghostMap[ghostId] as Ghost).owningManager = null;
               ghostMap[ghostId] = null;

               // Done!               
               continue;
            }
            
            // Nope, it's a real update. Is the slot empty?
            if(ghostMap[ghostId])
            {
               // An active ghost, let it parse the update.
               (ghostMap[ghostId] as Ghost).deserialize(bs, false);
            }
            else
            {
               // Empty slot, this is a new ghost.
               var newGhostTemplate:String = bs.stringCache.read(bs);
			   var entityName:String = bs.stringCache.read(bs);
			   if ( entityName == "0" ) //in the writePacket method above, if the ghostInstance is null, a string of "0" is writting, indicating to use no name.
					entityName = null;
               var newGhost:Ghost = instanceFactory.makeGhost(newGhostTemplate, entityName);
               
               if(!newGhost)
                  throw new Error("Instantiated template '" + newGhostTemplate + "' with no GhostComponent, deleted it.");                   
               
               // Let the ghost update itself.
               newGhost.deserialize(bs, true);
               
               // Map it.
               ghostMap[ghostId] = newGhost;
               newGhost.ghostIndex = ghostId;
               newGhost.owningManager = this;
               
               //Logger.print(this, "Got ghost on id " + ghostId + ": " + newGhostTemplate);
            }
         }
      }
      
      /**
       * Get the ID we have assigned a ghost, if any. If none, return -1.
       */
      public function findGhostId(g:Ghost):int
      {
         for(var i:int=0; i<ghostMap.length; i++)
         {
            if(ghostMap[i] && (ghostMap[i] as GhostInfo).ghostInstance == g)
               return i;
         }
         
         return -1;
      }
      
      /**
       * Indicate that a ghost is now in scope - called by the IScoper during
       * scope queries.
       * 
       * @param priority Priority to assign to this ghost.
       */
      public function markGhostInScope(g:Ghost, priority:Number = 1.0):void
      {
         if(g.scopeToken == scopePassToken)
            return;
         
         g.scopeToken = scopePassToken;
         g.scopePriority = priority;
         scopeQueue.push(g);
      }
      
      public function get attachedGhosts():int
      {
         return _attachedGhosts;
      }

      /**
       * Size in bits of the last update this manager sent.
       */
      public function get sizeOfLastUpdate():int
      {
         return _sizeOfLastUpdate;
      }

      private function attachGhost(g:Ghost):GhostInfo
      {
         // Set up the ghost info.
         var gi:GhostInfo = new GhostInfo(g, this);
         gi.priority = g.scopePriority;
         g.registerGhostInfo(gi);
         assignGhostID(gi);
         return gi;
      }
      
      private function assignGhostID(gi:GhostInfo):int
      {
         // Look for an empty slot to assign to this ghost.
         for(var i:int=0; i<ghostMap.length; i++)
         {
            // If a slot is in use, skip it.
            if(ghostMap[i])
               continue;

            // Great, we found an empty slot.
            ghostMap[i] = gi;
            _attachedGhosts++;
            return i;
         }
         
         throw new Error("No free IDs!");
         return -1;
      }
      
      private function detachGhost(g:Ghost):void
      {
         // Get the ghosts id.
         var ghostId:int = findGhostId(g);
         if(ghostId == -1)
            throw new Error("Did not know about this ghost, so could not detach it.");
         
         // Remove it from the ghost map.
         ghostMap[ghostId] = null;
         
         // Remove the ghost info from the ghost.
         g.removeGhostInfo(g.getGhostInfo(this));
         
         _attachedGhosts--;
      }
      
      private function doScopeQuery():void
      {
         // Increment the token, taking care to skip -1, as that is the default.
         scopePassToken++;
         if(scopePassToken == -1)
            scopePassToken = 0;
         
         // Clear the query array.
         scopeQueue.length = 0;
         
         // Do the query.
         if(!scoper)
            throw new Error("Cannot ghost with no scoper!");
         scoper.scopeObjects(this);
         
         // Now we have everything buffered... So prioritize it.
         scopeQueue.sortOn("scopePriority", Array.DESCENDING | Array.NUMERIC);
         
         // Take the top MaxGhostCount - that's what we want ideally to be scoped. Mark
         // the remainder as not-scoped.
         for(var i:int=maxGhostCount; i<scopeQueue.length; i++)
            (scopeQueue[i] as Ghost).scopeToken = scopePassToken - 1;
         scopeQueue.splice(maxGhostCount);
         
         // Now - look at our GhostMap and mark anything not in the current scoping pass
         // for deletion.
         for each(var gi:GhostInfo in ghostMap)
         {
            // Skip empties or stuff from this scoping query.
            if(!gi || gi.ghostInstance.scopeToken == scopePassToken)
               continue;
            
            // Great, it wasn't in this pass, so we can kill it.
            if(gi.isGhosted)
               gi.markShouldKill();          
         }
         
         // Now, until we hit the max ghost count, add things from the top of
         // the list on down.
         for(i=0; i < scopeQueue.length 
                && _attachedGhosts < maxGhostCount; i++)
         {
            var g:Ghost = scopeQueue[i];
            gi = g.getGhostInfo(this);
            
            if(!gi)
            {
               // Wasn't attached.
               attachGhost(scopeQueue[i]);
               continue;
            }
            
            // Was attached, but update priority.
            gi.priority = g.scopePriority;
         }
         
         // At this point we have everything in the GhostMap. So put it into pendingUpdates.
         pendingUpdates.length = 0;
         for each(gi in ghostMap)
         {
            if(!gi)
               continue;
            
            if(gi.shouldKill || gi.dirtyFlags || !gi.isGhosted)
               pendingUpdates.push(gi);
         }
         
         // Sort by priority.
         pendingUpdates.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
         
         // And we are ready to go!
      } 
      /**
       * Map ghost IDs to ghost instances.
       */
      internal var ghostMap:Array = new Array();

      private var scopeQueue:Array = new Array();
      
      static private var scopePassToken:int = 1;
     
      private var _attachedGhosts:int = 0;
      private var _sizeOfLastUpdate:int = 0;

      /**
       * List of ghosts with pending updates. 
       */
      private var pendingUpdates:Array = new Array();;

      private var ghostBitCount:int = 10;
      private var maxGhostCount:int = 1 << 10;

   }
}