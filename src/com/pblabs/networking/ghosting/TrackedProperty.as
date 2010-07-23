package com.pblabs.networking.ghosting
{
   import com.pblabs.engine.entity.PropertyReference;
   
   /**
    * Map a property on an IPropertyBag to a field in our protocol/NetRoot.
    */
   final public class TrackedProperty
   {
      /**
       * Only set this property for the first network update. Useful for handling
       * fields that you otherwise to interpolate.
       */ 
      public var initialUpdateOnly:Boolean;
      
      /**
       * Property that is tracked.
       */
      public var property:PropertyReference;
      
      /**
       * Field on the protocol that is associated with the tracked property. Must
       * have a compatible type.
       */  
      public var protocolField:String;
      
      /**
       * Last value we saw in the tracked property. Used to detect changes and
       * update dirty state.
       */
      public var lastValue:*;
   }
}