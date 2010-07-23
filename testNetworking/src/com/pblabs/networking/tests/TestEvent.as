package PBLabs.Networking.Tests
{
   import PBLabs.Networking.Events.EventConnection;
   import PBLabs.Networking.Events.GenericNetEvent;
   
   import net.digitalprimates.fluint.tests.*;

   
   /**
    * Helper event for EventConnection tests. Makes sure we receive events in
    * correct order, with no mixups, with correct payloads.
    */
   public class TestEvent extends GenericNetEvent
   {
      public function TestEvent(isServer:Boolean = false, index:int = 0)
      {
         super("TestEvent");

         data.SetInteger("counter", index);
         data.SetBoolean("fromServer", isServer);
         data.SetString("payload", isServer 
            ? "GENERIC FILLER" 
            : "GENERIC RESPONSE");
      }
      
      static public var LastServerIndex:int = -1;
      static public var LastClientIndex:int = -1;
      static public var CurrentTestCase:EventTests = null;
      
      public override function process(conn:EventConnection):void
      {
         var isServer:Boolean = data.GetBoolean("fromServer");
         
         if(isServer)
         {
            // Check the index.
            if(LastServerIndex + 1 != data.GetInteger("counter"))
               CurrentTestCase.failFromEvent("Counter did not increase correctly! (got " + data.GetInteger("counter") + " expected " + (LastServerIndex + 1));
            LastServerIndex = data.GetInteger("counter");
            
            // Check the payload.
            if("GENERIC FILLER" != data.GetString("payload"))
               CurrentTestCase.failFromEvent("Did not get expected payload string!"); 
         }
         else
         {
            // Check the index.
            if(LastClientIndex + 1 != data.GetInteger("counter"))
               CurrentTestCase.failFromEvent("Counter did not increase correctly!");
            LastClientIndex = data.GetInteger("counter");
            
            // Check the payload.
            if("GENERIC RESPONSE" != data.GetString("payload"))
               CurrentTestCase.failFromEvent("Did not get expected payload string!"); 
         }
      }
      
   }
}