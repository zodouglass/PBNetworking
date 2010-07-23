package com.pblabs.networking.elements
{
   import com.pblabs.networking.core.*;
   
   /**
    * A floating point value that can be encoded with variable precision.
    */
   public class FloatElement implements IFloatNetElement
   {
      private var _name:String;
      public var bitCount:int = 30;
      public var value:Number;
      
      public function FloatElement(n:String = null, bc:int = 30, v:Number = 0.0)
      {
         _name = n;
         bitCount = bc;
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
         bs.writeFloat(value, bitCount);
      }
      
      public function deserialize(bs:BitStream):void
      {
         value = bs.readFloat(bitCount);
      }
      
      public function initFromXML(xml:XML):void
      {
         bitCount = xml.@bitCount;
      }
      
      public function deepCopy():INetElement
      {
         return new FloatElement(_name, bitCount, value);
      }

      public function getValue():Number
      {
         return value;
      }
      
      public function setValue(v:Number):void
      {
         value = v;
      }
   }
}