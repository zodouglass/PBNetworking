package com.pblabs.networking.ghosting
{
   /**
    * Information about a ghost in the context of a specific GhostManager.
    */
   final public class GhostInfo
   {
      /**
       * Manager who is ghosting us.
       */
      public var managerInstance:GhostManager;
      
      /**
       * Ghost for which we are storing information.
       */
      public var ghostInstance:Ghost;
      
      /**
       * What states of ours are dirty? Used to test when we need to
       * do updates.
       */
      public var dirtyFlags:int;
      
      /**
       * How important is it to update this ghost in this context?
       */
      public var priority:Number;
      
      /**
       * How many times have we been skipped? This is necessary so that updates
       * eventually make it through.
       */
      public var timesSkipped:int;
      
      /**
       * Is the ghost currently in scope?
       */
      public var inScope:Boolean = false;
             
      /**
       * Is the ghost active on the client?
       */
      public var isGhosted:Boolean = false;
      
      /**
       * Do we need to kill this ghost?
       */
      public var shouldKill:Boolean = false;
      
      public static const csmAllDirty:int = int(0xFFFFFFFF);
      
      /**
       * Clear our dirty state, as we have completed an update. This is called
       * by the GhostManager for you.
       */
      public function markUpdated():void
      {
         dirtyFlags = 0;
         timesSkipped = 0;
      }
      
      /**
       * Indicate that one or more state flags have become dirty.
       */
      public function markDirty(flags:int):void
      {
         dirtyFlags |= flags;
      }
      
      /**
       * Mark all state flags as dirty.
       */
      public function markAllDirty():void
      {
         dirtyFlags = csmAllDirty;
      }
      
      /**
       * Clear one or more state flags. The GhostManager will deal with clearing
       * dirty state for you.
       */
      public function clearDirty(flags:int):void
      {
         dirtyFlags &= ~flags;
      }
      
      /**
       * Constructor 
       */
      public function GhostInfo(g:Ghost, m:GhostManager):void
      {
         ghostInstance = g;
         managerInstance = m;
         markAllDirty();
      }

      /**
       * Indicate that the ghost is out of scope in this context and should be
       * removed.
       */      
      public function markShouldKill():void
      {
         shouldKill = true;
         priority = Number.MAX_VALUE;
      }
   }
}