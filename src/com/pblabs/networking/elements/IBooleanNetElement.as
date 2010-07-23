package com.pblabs.networking.elements
{
   /**
    * Interface for a NetElement that exposes boolean data.
    */ 
   public interface IBooleanNetElement extends INetElement
   {
      function getValue():Boolean;
      function setValue(v:Boolean):void;      
   }
}