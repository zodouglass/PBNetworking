package com.pblabs.networking.ghosting
{
   /**
    * Factory for creating entities based on the prototype string passed during
    * ghost creation.
    */
   public interface IGhostFactory
   {
      /**
       * Make an object instance using the specified prototype name, and
       * return a reference to the Ghost that controls it.
       */
      function makeGhost(prototypeName:String):Ghost;
   }
}