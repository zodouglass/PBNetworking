package com.pblabs.networking.events
{
   import com.pblabs.networking.core.*;
   import com.pblabs.networking.elements.*;
   
   /**
    * Simplified NetEvent subclass creation.
    * 
    * Most NetEvents have a few fields they want to send, and a callback
    * when the data is received on the other end. The GenericNetEvent exists
    * to make this usage pattern simple.
    * 
    * @example Example of subclassing GenericNetEvent in order to make a simple
    *          event:
    * 
    * <listing version="3.0">
    *   class ChatEvent extends GenericNetEvent
    *   {
    *      public var chatterName:String;
    *      public var chatMessage:String;
    *  
    *      public function MyEvent()
    *      {
    *         // Indicate what protocol fragment we are using.
    *         super("myEventProtocol");
    *         
    *         // Register fields with the protocol. Notice they must be the
    *         // same name as the protocol has. They will then be deserialized
    *         // into automatically.
    *         registerField("chatterName");
    *         registerField("chatMessage");
    *      }
    * 
    *      public function process(ec:EventConnection):void
    *      {
    *         trace(chatterName + " said " + chatMessage);
    *      }
    *   }
    * 
    * </listing>
    *
    */
   public class GenericNetEvent extends NetEvent
   {
      private var fieldList:Array = new Array();
      
      public function GenericNetEvent(protocolName:String)
      {
         super();
         
         data = NetRoot.getByName(protocolName);
         typeName = protocolName;
      }
      
      public function registerField(name:String):void
      {
         fieldList.push(name);
      }
      
      public override function serialize(conn:EventConnection, bs:BitStream):void
      {
         // Iterate over all the elements and grab members with the same name.
         for each(var fieldName:String in fieldList)
         {
            // Is there a matching element in our protocol?
            var elem:INetElement = data.getElement(fieldName);
            if(!elem)
               continue;
            
            // Determine the type and set the value.
            if(elem is IIntegerNetElement)
               (elem as IIntegerNetElement).setValue(this[fieldName]);
            else if(elem is IFloatNetElement)
               (elem as IFloatNetElement).setValue(this[fieldName]);
            else if(elem is IStringNetElement)
               (elem as IStringNetElement).setValue(this[fieldName]);
            else if(elem is IBooleanNetElement)
               (elem as IBooleanNetElement).setValue(this[fieldName]);
            else
            {
               throw Error("Unknown NetElement type!");
            }
         }
         
         super.serialize(conn, bs);
      }
      
      public override function deserialize(conn:EventConnection, bs:BitStream):void
      {
         super.deserialize(conn, bs);
         
         // Iterate over all the elements and grab members with the same name.
         for each (var fieldName:String in fieldList)
         {
            // Is there a matching element in our protocol?
            var elem:INetElement = data.getElement(fieldName);
            if(!elem)
               continue;
            
            // Determine the type and set the value.
            if(elem is IIntegerNetElement)
               this[fieldName] = (elem as IIntegerNetElement).getValue();
            else if(elem is IFloatNetElement)
               this[fieldName] = (elem as IFloatNetElement).getValue();
            else if(elem is IStringNetElement)
               this[fieldName] = (elem as IStringNetElement).getValue();
            else if(elem is IBooleanNetElement)
               this[fieldName] = (elem as IBooleanNetElement).getValue();
            else
            {
               throw Error("Unknown NetElement type!");
            }
         }
      }
      
      public override function process(conn:EventConnection):void
      {
         // To be overriden.
      }
   }
}