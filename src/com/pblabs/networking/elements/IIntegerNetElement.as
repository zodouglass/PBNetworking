package com.pblabs.networking.elements
{
   /**
    * Interface for a NetElement that exposes integer data.
    */ 
   public interface IIntegerNetElement extends INetElement
   {
      function getValue():int;
      function setValue(v:int):void;
   }
}