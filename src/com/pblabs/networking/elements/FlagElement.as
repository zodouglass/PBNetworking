package com.pblabs.networking.elements
{
   import com.pblabs.networking.core.*;
   
   /**
    * A boolean element that, if true, serializes its children as well.
    */
   public class FlagElement extends NetElementContainer implements IBooleanNetElement
   {
      public var value:Boolean;
      
      public function FlagElement(n:String = null, v:Boolean = false)
      {
         super();
         setName(n);
         value = v;
      }

      public override function serialize(bs:BitStream):void
      {
         if(bs.writeFlag(value))
            super.serialize(bs);
      }

      public override function deserialize(bs:BitStream):void
      {
         if(value = bs.readFlag())
            super.deserialize(bs);
      }
      
      public function getValue():Boolean
      {
         return value;
      }
      
      public function setValue(v:Boolean):void
      {
         value = v;
      }      
   }
}