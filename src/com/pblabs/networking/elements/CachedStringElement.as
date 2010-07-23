package com.pblabs.networking.elements
{   
   import com.pblabs.networking.core.*;
   
   /**
    * A string, cached using a NetStringCache.
    */ 
   public class CachedStringElement implements IStringNetElement
   {
      private var _name:String;
      public var value:String;
      
      public function CachedStringElement(n:String = null, v:String = null)
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
         bs.stringCache.write(bs, value);
      }
      
      public function deserialize(bs:BitStream):void
      {
         value = bs.stringCache.read(bs);
      }
      
      public function initFromXML(xml:XML):void
      {
      }
      
      public function deepCopy():INetElement
      {
         return new CachedStringElement(_name, value);
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