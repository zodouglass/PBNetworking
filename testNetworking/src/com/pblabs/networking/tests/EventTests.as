package PBLabs.Networking.Tests
{
   import PBLabs.Networking.Core.*;
   import PBLabs.Networking.Events.*;
   import PBLabs.Networking.Elements.*;
   
   import flash.utils.ByteArray;
   
   import net.digitalprimates.fluint.tests.*;

   /**
    * Test sending and receiving events via in-memory buffers.
    */
   public class EventTests extends TestCase
   {
      public function testFullDuplexEventTransfer():void
      {
         // Give the library a test event.
         var libraryXML:XML =
         <protocol>
            <event name="TestEvent">
               <rangedInt name="counter" min="0" max="1024"/>
               <string name="payload"/>
               <flag name="fromServer"/>
            </event>
         </protocol>;
         
         NetRoot.LoadNetProtocol(libraryXML.toString());
         NetEvent.registerClass("TestEvent", TestEvent);
         
         TestEvent.CurrentTestCase = this;
         TestEvent.LastClientIndex = -1;
         TestEvent.LastServerIndex = -1;
         
         // Create connections to simulate client and server.
         var ecServer:EventConnection = new EventConnection();
         var ecClient:EventConnection = new EventConnection();
         
         // Queue up enough events on both connections that it will take several packets to transfer them.
         for(var i:int=0; i<1024; i++)
         {
            // Produce an event with some filler content and a counter so we can validate it works
            // correctly. Also note direction so we can be sure we're not getting mixed up.

            // Server -> client event.
            ecServer.PostEvent(new TestEvent(true, i));

            // Client -> server event.
            ecServer.PostEvent(new TestEvent(false, i));
         }
         
         // Great. Now write and read packets and make sure the events make it through.
         
         // Sanity check: if we are taking close to 1 packet/event we are in trouble.
         var safetyCount:int = 4000; 
         
         var serverToClientBuffer:ByteArray = new ByteArray();
         var clientToServerBuffer:ByteArray = new ByteArray();
         
         while(ecServer.HasDataPending || ecClient.HasDataPending)
         {
            // Make sure our buffer pointers are right.
            serverToClientBuffer.position = 0;
            clientToServerBuffer.position = 0;

            // Have the connections write packets into buffers.
            ecServer.SendPacketToBuffer(serverToClientBuffer);
            ecClient.SendPacketToBuffer(clientToServerBuffer);
            
            // Make sure our buffer pointers are right.
            serverToClientBuffer.position = 0;
            clientToServerBuffer.position = 0;
            
            // And now have them read!
            ecServer.ReadPacketsFromBuffer(clientToServerBuffer);
            ecClient.ReadPacketsFromBuffer(serverToClientBuffer);

            // Update safety net.
            safetyCount--;
            if(safetyCount <= 0)
            {
               // We ran too long.
               fail("Took too many packets to send our data!");
               break;
            }
         }
         
         // Ok, make sure the right number of things made it over.
         assertEquals(TestEvent.LastClientIndex, 1023);
         assertEquals(TestEvent.LastServerIndex, 1023);
         
         // Clean up.
         TestEvent.CurrentTestCase = null;
      }
      
      public function failFromEvent(msg:String):void
      {
         fail("Event failed us for: " + msg);
      }
   }
}
