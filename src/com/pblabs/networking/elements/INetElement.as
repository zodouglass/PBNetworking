package com.pblabs.networking.elements
{
   import com.pblabs.networking.core.*;
   
   /**
    * Interface for a NetElement.
    */
   public interface INetElement
   {
      function getName():String;
      function setName(v:String):void;

      /**
       * Write this NetElement's current state to a BitStream.
       */       
      function serialize(bs:BitStream):void;
      
      /**
       * Read state from a BitStream and store it in this NetElement.
       */
      function deserialize(bs:BitStream):void;
      
      /**
       * After instantiation, access any attributes from the XML describing
       * this NetElement.
       */
      function initFromXML(xml:XML):void;
      
      /**
       * Make a deep copy of this NetElement. Used when initializing a new
       * NetRoot.
       */
      function deepCopy():INetElement;
   }
}