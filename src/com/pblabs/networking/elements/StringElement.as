package com.pblabs.networking.elements
{
   import com.pblabs.networking.core.*;
   
   /**
    * A simple string.
    */ 
   public class StringElement implements IStringNetElement
   {
      private var _name:String;
      public var value:String;
      
      public function StringElement(n:String = null, v:String = null)
      {
         _name = n;
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
         bs.writeString(value);
      }
      
      public function deserialize(bs:BitStream):void
      {
         value = bs.readString();
      }
      
      public function initFromXML(xml:XML):void
      {
         value = xml.@value.toString();
      }
      
      public function deepCopy():INetElement
      {
         return new StringElement(_name, value);
      }

      public function getValue():String
      {
         return value;
      }
      
      public function setValue(v:String):void
      {
         value = v;
      }
   }
}