package com.pblabs.networking.events
{
   import com.pblabs.engine.debug.*;
   import com.pblabs.networking.core.*;
   import com.pblabs.networking.elements.*;
   import com.pblabs.networking.ghosting.*;
   
   import flash.errors.*;
   import flash.events.*;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Timer;

   /**
    * Implements an event passing protocol. The protocol is very simple. In each
    * packet, we write as many events as will fit. The protocol is a flag
    * indicating the presence of an event, a cached-string containing the event 
    * name, and then the event payload. This repeats until the flag is false.
    */ 
   public class EventConnection extends NetworkConnection
   {

      /**
       * Queue a NetEvent for transmission.
       */ 
      public function postEvent(e:NetEvent):void
      {
        eventQueue.push(e);
      }

      public override function get hasDataPending():Boolean
      {
        return eventQueue.length > 0;
      }
      
      protected override function writePacket(bs:BitStream):void
      {
         super.writePacket(bs);
          
         var curEventIdx:int = 0;
         var curPosition:int = -1;
          
         while(curEventIdx < eventQueue.length)
         {
            // Write each event; if it throws an exception
            // then we've either errored or run out of space.
            try
            {
               var curEvent:NetEvent = eventQueue[curEventIdx];
               curPosition = bs.currentPosition;
               
               // Write the "more events" flag.
               bs.writeFlag(true);
               
               // Write the event type.
               bs.stringCache.write(bs, curEvent.typeName);
               
               // Serialize the event payload.
               curEvent.serialize(this, bs);
               
               // Trigger a rollback if we have zero bits left, too, we need
               // at least one to encode the "no more events" flag.
               if(bs.remainingBits == 0)
                  throw new EOFError();
               
               curEventIdx++;
            }
            catch(eof:EOFError)
            {
               // We ran off the end of the buffer, so we're done writing
               // events. Roll back and break out of the loop.
               bs.currentPosition = curPosition;
               break;
            }
         }
          
         // If we couldn't send ANY events... then we are in trouble!
         if(curEventIdx == 0 && eventQueue.length)
            throw new Error("Could not send the first event! It is probably too big for our packet size.");
          
         // Wipe all the events we processed.
         eventQueue.splice(0,curEventIdx);
          
         try
         {
            // Awesome - spit out the "no more events" flag.
            bs.writeFlag(false);
         }
         catch(e:EOFError)
         {
            throw new EOFError("Ran out of space to write final flag!");
         }
      }
      
      protected override function readPacket(bs:BitStream):void
      {
         super.readPacket(bs);

         do
         {
            // Check if there is another event.
            if(bs.readFlag() == false)
               break;
             
            // Nope - we got an event to process.
            var eventType:String = bs.stringCache.read(bs);
            
            // First, create an instance of the event.
            var event:NetEvent = NetEvent.createFromName(eventType);
            
            if(!event)
               throw new Error("Got unknown event type '" + eventType +"'!");
              
            // Now let it deserialize.
            event.deserialize(this, bs);
            
            // Finally, let it process. (This will eventually want to be deferred I think).
            event.process(this);
         }
         while(true);
      }
 
      private var eventQueue:Array = new Array();
   }
}