package PBLabs.Networking.Tests
{
   import PBLabs.Engine.Components.*;
   import PBLabs.Engine.Core.*;
   import PBLabs.Engine.Debug.*;
   import PBLabs.Engine.Entity.*;
   import PBLabs.Networking.Core.BitStream;
   import PBLabs.Networking.Core.NetStringCache;
   import PBLabs.Networking.Elements.*;
   import PBLabs.Networking.Ghosting.*;
   
   import net.digitalprimates.fluint.tests.TestCase;

   /**
    * Test ghosting to and from a server. We implement IScoper so we don't
    * have to have yet another helper object.
    */
   public class GhostTests extends TestCase implements IScoper
   {
      private var _Ghosts:Array = new Array();
      private var _PriorityToggle:Boolean = false;
      
      public function ScopeObjects(gm:GhostManager):void
      {
         if(_PriorityToggle)
         {
            // If _PriorityToggle is set assign priority from first to last.
            for(var i:int=0; i<_Ghosts.length; i++)
               gm.MarkGhostInScope(_Ghosts[i] as Ghost, _Ghosts.length - i);
         }
         else
         {
            // Otherwise reverse priority.
            for(i=0; i<_Ghosts.length; i++)
               gm.MarkGhostInScope(_Ghosts[i] as Ghost, i);
         }
      }
      
      public function testHalfDuplexGhosting():void
      {
         var resolveLinker:GroupMemberComponent;
         var resolveLinker2:DataComponent;
         
         // Init our templates.
         var tm:TemplateManager = new TemplateManager();
         tm.AddXML(
            <template name="TestGhost">
               <component name="ghost" type="PBLabs.Networking.Ghosting.GhostComponent">
                  <GhostInstance>
                     <ProtocolName>TestGhost</ProtocolName>
                     <PrototypeName>TestGhost</PrototypeName>
                     <TrackedProperties>
                        <_>
                           <Property>@data.Value1</Property>
                           <ProtocolField>payload</ProtocolField>
                        </_>
                        <_>
                           <Property>@data.Value2</Property>
                           <ProtocolField>payloadFloat</ProtocolField>
                        </_>
                     </TrackedProperties>
                  </GhostInstance>
               </component>
               <component name="data" type="PBLabs.Engine.Components.DataComponent">
                  <Value1>A</Value1>
                  <Value2>0.5</Value2>
               </component>
               <component name="member" type="PBLabs.Engine.Components.GroupMemberComponent">
                  <GroupName>ClientGroup</GroupName>
               </component>
            </template>,
            "", 1);
         tm.AddXML(
            <entity name="ServerGroup">
               <component name="groupManager" type="PBLabs.Engine.Components.GroupManagerComponent"/>
            </entity>,
            "", 1);
         tm.AddXML(
            <entity name="ClientGroup">
               <component name="groupManager" type="PBLabs.Engine.Components.GroupManagerComponent"/>
            </entity>,
            "", 1);
         
         var libraryXML:XML =
         <protocol>
            <event name="TestGhost">
               <rangedInt name="id" min="0" max="8191"/>
               <dirtyFlag name="dirty01">
                  <string name="payload" value="" />
                  <float name="payloadFloat" bitCount="8" />
               </dirtyFlag>
            </event>
         </protocol>;
         NetRoot.LoadNetProtocol(libraryXML.toString());
         
         // Instantiate the server and client groups.
         var serverGroup:GroupManagerComponent = tm.InstantiateEntity("ServerGroup").LookupComponentByName("groupManager") as GroupManagerComponent;
         assertNotNull(serverGroup);
         var clientGroup:GroupManagerComponent = tm.InstantiateEntity("ClientGroup").LookupComponentByName("groupManager") as GroupManagerComponent;
         assertNotNull(clientGroup);
         
         // And our ghost factor.
         var tgf:TemplateGhostFactory = new TemplateGhostFactory();
         tgf.OverrideTemplateManager = tm;
         
         // Set up a server ghost manager using dummy scoper.
         var serverManager:GhostManager = new GhostManager();
         serverManager.InstanceFactory = tgf;
         serverManager.Scoper = this;
         serverManager.SetGhostBitCount(8);
         
         // Set up a client ghost manager.
         var clientManager:GhostManager = new GhostManager();
         clientManager.InstanceFactory = tgf;
         clientManager.SetGhostBitCount(8);
         
         // Set up a lot of ghosts on the server - more than we can fit in scope at a time.
         for(var i:int=0; i<4*256; i++)
         {
            // Set up the ghost and place it in the server group.
            var g:Ghost = tgf.MakeGhost("TestGhost");
            g.TrackedObject.SetProperty(new PropertyReference("@member.GroupName"), "ServerGroup");
            g.Protocol.SetInteger("id", i);
            _Ghosts.push(g);
         }
         
         // Make sure we have the expected number.
         assertEquals(serverGroup.EntityList.length, 4*256);
         
         // Run a few dozen update packets.
         var serverToClientBuffer:BitStream = new BitStream(100);
         var serverStringCache:NetStringCache = new NetStringCache();
         var clientStringCache:NetStringCache = new NetStringCache();
         
         for(i=0; i<50; i++)
         {
            serverToClientBuffer.CurrentPosition = 0;
            serverToClientBuffer.StringCache = serverStringCache;
            serverManager.writePacket(serverToClientBuffer);
            
            serverToClientBuffer.CurrentPosition = 0;
            serverToClientBuffer.StringCache = clientStringCache;
            clientManager.readPacket(serverToClientBuffer);
         }
         
         // Now, check what has been scoped to the client - is it the right stuff?
         var clientEntityList:Array = clientGroup.EntityList;
         for each(var e:IEntity in clientEntityList)
         {
            var gc:GhostComponent = e.LookupComponentByType(GhostComponent) as GhostComponent;
            assertNotNull(gc);
            assertTrue("Got back ID " + gc.GhostInstance.Protocol.GetInteger("id") + " > " + (serverGroup.EntityList.length / 2),
                        gc.GhostInstance.Protocol.GetInteger("id") > serverGroup.EntityList.length / 2);
         }
         
         // Invert priority levels.
         _PriorityToggle = !_PriorityToggle;
         
         // Run some more update packets.
         for(i=0; i<50; i++)
         {
            serverToClientBuffer.CurrentPosition = 0;
            serverToClientBuffer.StringCache = serverStringCache;
            serverManager.writePacket(serverToClientBuffer);
            
            serverToClientBuffer.CurrentPosition = 0;
            serverToClientBuffer.StringCache = clientStringCache;
            clientManager.readPacket(serverToClientBuffer);
         }
         
         // Are we seeing the right stuff on the client now? (ie the other half of the data)
         clientEntityList = clientGroup.EntityList;
         for each(e in clientEntityList)
         {
            gc = e.LookupComponentByType(GhostComponent) as GhostComponent;
            assertNotNull(gc);
            assertTrue("Got back ID " + gc.GhostInstance.Protocol.GetInteger("id") + " < " + (serverGroup.EntityList.length / 2),
                        gc.GhostInstance.Protocol.GetInteger("id") < serverGroup.EntityList.length / 2);
         }
         
         // Sweet! Now let's test dirty tracking. The first couple hundred ghosts are scoped right now.
         
         // Let's change the first few directly.
         var aGhost:Ghost = _Ghosts[0];
         aGhost.Protocol.SetString("payload", "monkey");
         aGhost.MarkDirty(aGhost.Protocol.GetElementDirtyBits("payload"));
         
         aGhost = _Ghosts[1];
         aGhost.Protocol.SetString("payload", "pony");
         aGhost.MarkDirty(aGhost.Protocol.GetElementDirtyBits("payload"));
         
         aGhost = _Ghosts[2];
         aGhost.Protocol.SetString("payload", "pirate");
         aGhost.MarkDirty(aGhost.Protocol.GetElementDirtyBits("payload"));

         aGhost = _Ghosts[3];
         aGhost.Protocol.SetString("payload", "ninja");
         aGhost.MarkDirty(aGhost.Protocol.GetElementDirtyBits("payload"));

         // Run an update packet.
         serverToClientBuffer.CurrentPosition = 0;
         serverToClientBuffer.StringCache = serverStringCache;
         serverManager.writePacket(serverToClientBuffer);
            
         serverToClientBuffer.CurrentPosition = 0;
         serverToClientBuffer.StringCache = clientStringCache;
         clientManager.readPacket(serverToClientBuffer);
         
         // Clear out the old state.
         _Ghosts[0].Protocol.SetString("payload", "monkey");
         _Ghosts[1].Protocol.SetString("payload", "pony");
         _Ghosts[2].Protocol.SetString("payload", "pirate");
         _Ghosts[3].Protocol.SetString("payload", "ninja");
         
         // They'd better have made it over!
         clientEntityList = clientGroup.EntityList;
         var numChecked:int = 0;
         for each(e in clientEntityList)
         {
            gc = e.LookupComponentByType(GhostComponent) as GhostComponent;
            assertNotNull(gc);
            switch(gc.GhostInstance.Protocol.GetInteger("id"))
            {
               case 0:
                  assertEquals(gc.GhostInstance.Protocol.GetString("payload"), "monkey");
                  numChecked++;
                  break;
               case 1:
                  assertEquals(gc.GhostInstance.Protocol.GetString("payload"), "pony");
                  numChecked++;
                  break;
               case 2:
                  assertEquals(gc.GhostInstance.Protocol.GetString("payload"), "pirate");
                  numChecked++;
                  break;
               case 3:
                  assertEquals(gc.GhostInstance.Protocol.GetString("payload"), "ninja");
                  numChecked++;
                  break;
            }
         }
         
         // Make sure all 4 changes made it over.
         assertEquals(numChecked, 4);
         Logger.Print(this, "Checked " + numChecked + " things!");
         
         // Great, now let's check property tracking.
         (_Ghosts[0] as Ghost).CheckTrackedProperties();
         (_Ghosts[1] as Ghost).CheckTrackedProperties();
         (_Ghosts[2] as Ghost).CheckTrackedProperties();
         (_Ghosts[3] as Ghost).CheckTrackedProperties();
                  
         // Send the packet.
         serverToClientBuffer.CurrentPosition = 0;
         serverToClientBuffer.StringCache = serverStringCache;
         serverManager.writePacket(serverToClientBuffer);
            
         serverToClientBuffer.CurrentPosition = 0;
         serverToClientBuffer.StringCache = clientStringCache;
         clientManager.readPacket(serverToClientBuffer);
         
         // Make sure we wrote some bits - should see a change here.
         assertTrue(serverManager.SizeOfLastUpdate > 24);
         
         // Do another check/update - should see no change.
         (_Ghosts[0] as Ghost).CheckTrackedProperties();
         (_Ghosts[1] as Ghost).CheckTrackedProperties();
         (_Ghosts[2] as Ghost).CheckTrackedProperties();
         (_Ghosts[3] as Ghost).CheckTrackedProperties();

         // Send the packet.
         serverToClientBuffer.CurrentPosition = 0;
         serverToClientBuffer.StringCache = serverStringCache;
         serverManager.writePacket(serverToClientBuffer);
            
         serverToClientBuffer.CurrentPosition = 0;
         serverToClientBuffer.StringCache = clientStringCache;
         clientManager.readPacket(serverToClientBuffer);

         // Should have seen no data.
         assertTrue("Update size " + serverManager.SizeOfLastUpdate, serverManager.SizeOfLastUpdate < 24);
         
         // Ok, change some properties and track.
         (_Ghosts[0] as Ghost).TrackedObject.SetProperty(new PropertyReference("@data.Value1"), "B");
         (_Ghosts[0] as Ghost).TrackedObject.SetProperty(new PropertyReference("@data.Value2"), "3.0");
         (_Ghosts[0] as Ghost).CheckTrackedProperties();

         // Send the packet.
         serverToClientBuffer.CurrentPosition = 0;
         serverToClientBuffer.StringCache = serverStringCache;
         serverManager.writePacket(serverToClientBuffer);
            
         serverToClientBuffer.CurrentPosition = 0;
         serverToClientBuffer.StringCache = clientStringCache;
         clientManager.readPacket(serverToClientBuffer);

         // Should have seen data.
         assertTrue(serverManager.SizeOfLastUpdate > 24);
      }
   }
}