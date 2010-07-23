package com.pblabs.networking.elements
{
   /**
    * Interface for a NetElement that exposes floating point data.
    */ 
   public interface IFloatNetElement extends INetElement
   {
      function getValue():Number;
      function setValue(v:Number):void;
   }
}