package com.pblabs.networking.elements
{
   /**
    * Interface for a NetElement that exposes Object data.
    */ 
   public interface IObjectNetElement extends INetElement
   {
      function setValue(v:Object):void;
      function getValue():Object;
   }
}