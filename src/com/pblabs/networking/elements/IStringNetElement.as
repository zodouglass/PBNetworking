package com.pblabs.networking.elements
{
   /**
    * Interface for a NetElement that exposes String data.
    */ 
   public interface IStringNetElement extends INetElement
   {
      function getValue():String;
      function setValue(v:String):void;      
   }
}