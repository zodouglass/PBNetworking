package com.pblabs.networking.ghosting
{
   /**
    * Used by the GhostManager to determine what objects are in scope. It will
    * be called approximately once per packet, and identify what objects should
    * be in scope and at what priority.
    */
   public interface IScoper
   {
      /**
       * When called, should call GhostManager.MarkGhostInScope() on any objects
       * that should be in scope for this connection.
       */
      function scopeObjects(gm:GhostManager):void;
   }
}