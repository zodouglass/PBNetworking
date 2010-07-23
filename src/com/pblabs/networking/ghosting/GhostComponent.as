package com.pblabs.networking.ghosting
{
   import com.pblabs.engine.entity.*;
   import com.pblabs.engine.core.*;
   import com.pblabs.engine.debug.*;
   import com.pblabs.networking.core.*;
   
   import flash.events.*;

   /**
     * Implements most-recent-state networking in the context of components.
     */
   public class GhostComponent extends EntityComponent implements ITickedObject
   {
      /**
       * The actual Ghost which interfaces with the networking system.
       */
      public var ghostInstance:Ghost = new Ghost();
      
      public function onInterpolateTick(factor:Number):void
      {
         // Nothing for now.
      }      
      
      public function onTick(tickRate:Number):void
      {
         // Give the ghost a chance to check for changes to our state.
         ghostInstance.checkTrackedProperties();         
      }
      
      protected override function onAdd():void
      {
         // Bind the ghost to us.
         ghostInstance.trackedObject = owner;
         
         // Destroy ourselves when we go out of scope.
         ghostInstance.onOutOfScope = function():void { owner.destroy(); }

         // Tick so we update our dirty state.
         ProcessManager.instance.addTickedObject(this);
      }
      
      protected override function onRemove():void
      {
         ghostInstance.trackedObject = null;
         ghostInstance.onOutOfScope = null;
         ProcessManager.instance.removeTickedObject(this);
      }
   }
}