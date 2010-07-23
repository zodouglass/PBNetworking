package com.pblabs.networking.elements
{
   /**
    * Interface describing the accessors on a NetElement container.
    * 
    * Basically, these methods let you get typed data by name.
    */ 
   public interface IContainerAccessors
   {
      function getString(name:String):String;
      function getInteger(name:String):int;
      function getFloat(name:String):Number;
      function getBoolean(name:String):Boolean;
      
      function setString(name:String,  v:String):void;
      function setInteger(name:String, v:int):void;
      function setFloat(name:String, v:Number):void;
      function setBoolean(name:String, v:Boolean):void;
   }
}