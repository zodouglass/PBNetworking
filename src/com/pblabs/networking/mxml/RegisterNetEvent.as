package com.pblabs.networking.mxml
{
   import mx.core.*;
   import com.pblabs.networking.events.*;

   /**
    * MXML Tag to automatically register a NetEvent subclass with an event name.
    * 
    * Wraps NetEvent.registerClass(). 
    */
   public class RegisterNetEvent implements IMXMLObject
   {
      [Bindable]
      public var eventClass:Class;

      [Bindable]
      public var eventName:String;

      public function initialized(document:Object, id:String):void
      {
         NetEvent.registerClass(eventName, eventClass);            
      }
   }
}