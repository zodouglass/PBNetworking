package com.pblabs.networking.events
{
   import com.pblabs.networking.core.BitStream;
   import com.pblabs.networking.elements.*;
   
   import com.pblabs.engine.core.*;
   import com.pblabs.engine.debug.*;
   
   import flash.utils.Dictionary;
   
   /**
    * Base class for all network events. NetEvents are sent via EventConnection,
    * and when they are received, process() is called on them. You subclass them
    * as needed to implement your desired event functionality.
    */
   public class NetEvent
   {
      private static var smClassLookup:Dictionary = new Dictionary();
      
      /**
       * Associate a class with a given event type name.
       */
      static public function registerClass(name:String, c:Class):void
      {
         smClassLookup[name] = c;
      }
      
      /**
       * Create a NetEvent subclass by event name.
       */
      static public function createFromName(name:String):NetEvent
      {
         // Grab the name.   
         var eventClazz:Class = smClassLookup[name];
         
         if(!eventClazz)
            return null;
         
         // Ok - so create an instance of it and return it.
         try
         {
            var newEvent:NetEvent = new eventClazz;
            newEvent.data = NetRoot.getByName(name);
            newEvent.typeName = name;
            return newEvent;
         }
         catch(e:Error)
         {
            Logger.printError(null, "createFromName", "Error creating event of type '" + name + "' - " + e.toString());
         }
         
         return null;
      }
      
      /**
       * The name of the event type.
       */
      public var typeName:String;
      
      /**
       * The network protocol we will use to transmit our data.
       */
      public var data:NetRoot;
      
      public function serialize(conn:EventConnection, bs:BitStream):void
      {
         data.serialize(bs);
      }
      
      public function deserialize(conn:EventConnection, bs:BitStream):void
      {
         data.deserialize(bs);
      }
      
      /**
       * Callback when an event is received; subclasses will implement this.
       */ 
      public function process(conn:EventConnection):void
      {
      }
   }
}