package com.pblabs.networking.elements
{
   /**
    * Interface for something that can contain NetElements.
    */ 
   public interface INetElementContainer
   {
      /**
       * Add a NetElement to this container.
       */
      function addElement(e:INetElement):void;
      
      /**
       * Get an element by name. Searches all child containers as well.
       */ 
      function getElement(name:String):INetElement;
      
      /**
       * Get number of NetElements in just this container (not subcontainers).
       */
      function getElementCount():int;
     
      /**
       * Get a NetElement on this container by index.
       */ 
      function getElementByIndex(index:int):INetElement;
   }
}