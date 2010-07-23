package com.pblabs.networking.elements
{
   /**
    * Just like FlagElement, but also assigns itself a dirty bit, and participates
    * in dirty bit tracking. Used in ghosts.
    */ 
   public class DirtyFlagElement extends FlagElement implements IBooleanNetElement, INetElementContainer
   {
      // The index of the dirty bit that corresponds to this flag.
      public var dirtyFlagIndex:int;
      
      public function DirtyFlagElement(n:String=null, v:Boolean=false)
      {
         super(n, v);
      }
      
      public override function deepCopy():INetElement
      {
         var c:DirtyFlagElement = super.deepCopy() as DirtyFlagElement;
         c.dirtyFlagIndex = dirtyFlagIndex;
         c.value = value;
         return c;
      }
   }
}