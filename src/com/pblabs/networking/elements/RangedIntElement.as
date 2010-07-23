package com.pblabs.networking.elements
{
   import com.pblabs.networking.core.*;
   
   /**
    * An integer value that can range from min to max.
    */ 
   public class RangedIntElement implements IIntegerNetElement
   {
      private var _name:String;
      public var min:int, max:int, value:int;
      
      public function RangedIntElement(n:String = null, mn:int = 0, mx:int = 100, v:int = 1)
      {
         _name = n;
         min = mn;
         max = mx;
         value = v;   
      }

      public function getName():String
      {
         return _name;
      }
      
      public function setName(v:String):void
      {
         _name = v;
      }
      
      public function serialize(bs:BitStream):void
      {
         bs.writeRangedInt(value, min, max);
      }
      
      public function deserialize(bs:BitStream):void
      {
         value = bs.readRangedInt(min, max);
      }
      
      public function initFromXML(xml:XML):void
      {
         min = xml.@min;
         max = xml.@max;
      }
      
      public function deepCopy():INetElement
      {
         return new RangedIntElement(_name, min, max, value);
      }

      public function getValue():int
      {
         return value;
      }
      
      public function setValue(v:int):void
      {
         value = v;
      }         
   }
}