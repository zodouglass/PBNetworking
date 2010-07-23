package PBLabs.Networking.Tests
{
   import net.digitalprimates.fluint.tests.*;
   import flash.errors.EOFError;
   import PBLabs.Networking.Core.*;
   import PBLabs.Networking.Elements.*;

   public class NetElementTests extends TestCase
   {
      static public function suite():TestSuite
      {
         var ts:TestSuite = new TestSuite();
         ts.addTestCase(new NetElementTests());
         return ts;
      }
         
      public function testNetElements():void
      {
         // Set up the serialization structure.
         var nr:NetRoot = new NetRoot();
         nr.AddElement(new StringElement("chatText", "hey there world"));
         nr.AddElement(new FloatElement("chatVolume", 14, 0.90001));
         
         // Write out to a stream. 
         var bs:BitStream = new BitStream(64);
   
         try
         {
            nr.Serialize(bs);         
         }
         catch(e:EOFError)
         {
            fail(e.toString());
         }
   
         
         // Change values.
         nr.SetString("chatText", "filler");
         nr.SetFloat("chatVolume", 0.0);
         
         // Read back.
         bs.reset();
         try
         {
            nr.Deserialize(bs);
         }
         catch(e:EOFError)
         {
            fail(e.toString());
         }
   
         
         // Validate results.
         assertEquals(nr.GetString("chatText"), "hey there world");
         
         var floatVal:Number = nr.GetFloat("chatVolume");
         if(Math.abs(floatVal - 0.90001) > 0.01)
            fail("Did not get back our expected float.");
      }
      
      public function testFlagElement():void
      {
         // Set up serialization 
         var nr:NetRoot = new NetRoot();
         nr.AddElement(new FlagElement("flag", true));
         nr.AddElement(new StringElement("string2", "end"));
         
         var fe:FlagElement = nr.GetElement("flag") as FlagElement;
         fe.AddElement(new StringElement("string", "hey there"));
         
         // Blast some permutations out to a BitStream.
         var bs:BitStream = new BitStream(256);
         
         // Write with flag set to true...
         try
         {
            nr.Serialize(bs);
         }
         catch(e:EOFError)
         {
            fail(e.toString());
         }
         
         // Write it with flag set to false.
         nr.SetBoolean("flag", false);

         try
         {
            nr.Serialize(bs);
         }
         catch(e:EOFError)
         {
            fail(e.toString());
         }
   
         // Ok, now read back the first one.
         bs.reset();
         
         nr.SetString("string2", "bad");
         nr.SetString("string", "bad2");
         
         try
         {
            nr.Deserialize(bs);
         }
         catch(e:EOFError)
         {
            fail(e.toString());
         }
         
         // Both strings should change in this case...
         assertEquals(nr.GetString("string2"), "end");
         assertTrue(nr.GetBoolean("flag"));
         assertEquals(nr.GetString("string"), "hey there");
         
         // Set more state to garbage...
         nr.SetString("string2", "bad");
         nr.SetString("string", "bad2");
         
         // Now, read back the second one.
         try
         {
            nr.Deserialize(bs);
         }
         catch(e:EOFError)
         {
            fail(e.toString());
         }
         
         // And check state...
         assertEquals(nr.GetString("string2"), "end");
         assertFalse(nr.GetBoolean("flag"));
         assertEquals(nr.GetString("string"), "bad2");
      }
      
      public function testXML():void
      {
         var testXml:String = "<root>\n" + 
                      "   <string name=\"stringItem\" />\n" + 
                      "   <float name=\"floatItem\" bitCount=\"8\" />\n" +
                      "   <flag name=\"flagItem\">\n" +
                      "      <float name=\"floatItem2\" bitCount=\"16\" />\n" +
                      "   </flag>\n" +
                      "</root>";
         
         // Note we test the deep copy here as well.
         var nr:NetRoot = NetRoot.createFromXML(testXml).DeepCopy() as NetRoot;
         
         // Make sure elements are of correct types and their properties are right.
         assertTrue(nr.GetElement("stringItem") is StringElement);
         assertTrue(nr.GetElement("floatItem") is FloatElement);
         assertEquals((nr.GetElement("floatItem") as FloatElement).bitCount, 8);
         
         assertTrue(nr.GetElement("floatItem2") is FloatElement);
         assertEquals((nr.GetElement("floatItem2") as FloatElement).bitCount, 16);
      }
      
      public function testDirtyFlags():void
      {
         var testXml:XML =
            <root>
               <dirtyFlag name="dirty01">
                  <string name="stringField1" />
                  <float name="floatItem" bitCount="8" />
               </dirtyFlag>
               <dirtyFlag name="dirty02">
                  <float name="floatItem2" bitCount="16" />
                  <dirtyFlag name="dirty03">
                     <string name="stringField2" />
                  </dirtyFlag>
               </dirtyFlag>
            </root>;
                     
         // Note we test the deep copy here as well.
         var nr:NetRoot = NetRoot.createFromXML(testXml.toString()).DeepCopy() as NetRoot;
         
         // Ok, let's check the dirty bits for each element. In reality, we do not assume what bits
         // get assigned where, since it's for internal tracking only.
         assertEquals(nr.GetElementDirtyBits("stringField1"), 0x1);
         assertEquals(nr.GetElementDirtyBits("floatItem"), 0x1);
         assertEquals(nr.GetElementDirtyBits("floatItem2"), 0x2);
         assertEquals(nr.GetElementDirtyBits("stringField2"), 0x2 | 0x4);
         
         // Test getting elemeny by id.
         assertEquals(nr.GetDirtyBitElement(0).GetName(), "dirty01");
         assertEquals(nr.GetDirtyBitElement(1).GetName(), "dirty02");
         assertEquals(nr.GetDirtyBitElement(2).GetName(), "dirty03");

         // Set some dirty states and check that the dirty flags are set properly.
         nr.SetDirtyState(0x0);
         assertEquals(nr.GetBoolean("dirty01"), false);
         assertEquals(nr.GetBoolean("dirty02"), false);
         assertEquals(nr.GetBoolean("dirty03"), false);

         nr.SetDirtyState(0x1);
         assertEquals(nr.GetBoolean("dirty01"), true);
         assertEquals(nr.GetBoolean("dirty02"), false);
         assertEquals(nr.GetBoolean("dirty03"), false);

         nr.SetDirtyState(0x1 | 0x2);
         assertEquals(nr.GetBoolean("dirty01"), true);
         assertEquals(nr.GetBoolean("dirty02"), true);
         assertEquals(nr.GetBoolean("dirty03"), false);

         nr.SetDirtyState(0x1 | 0x2 | 0x4);
         assertEquals(nr.GetBoolean("dirty01"), true);
         assertEquals(nr.GetBoolean("dirty02"), true);
         assertEquals(nr.GetBoolean("dirty03"), true);
         
         nr.SetDirtyState(0x2 | 0x4);
         assertEquals(nr.GetBoolean("dirty01"), false);
         assertEquals(nr.GetBoolean("dirty02"), true);
         assertEquals(nr.GetBoolean("dirty03"), true);
      }
   }
}