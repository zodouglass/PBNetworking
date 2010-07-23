package PBLabs.Networking.Tests
{
   import net.digitalprimates.fluint.tests.*;
   import PBLabs.Networking.Core.*;

   public class NetStringCacheTests extends TestCase
   {
        public static function suite():TestSuite {
            var ts:TestSuite = new TestSuite();
            
            ts.addTestCase( new NetStringCacheTests( ) );
            
            return ts;
         }

      public function testNetStringCache():void
      {
         // Make quite a large BitStream as we'll be writing loads of data.
         var bs:BitStream = new BitStream(1024*1024);
         
         // First, let's test that writing a single string multiple times
         // is working correctly.
         {
            var nsc:NetStringCache = new NetStringCache();
            
            for(var i:int=0; i<4096; i++)
               nsc.write(bs, "hello world how are you?");
            
            // At this time, the bitstream should be approximately
            // 10bits * 4096 long (plus overhead for the first time,
            // when we encode the string). If we hit 8192 bytes we
            // have not operated properly, as that's 16bits per entry
            // and we should only be using 10 plus a little bit on
            // average.
            assertTrue(bs.CurrentPosition < 8192*8);
            
            // Ok, great - now let's read back.
            bs.reset();
            for(i=0; i<4096; i++)
               assertEquals(nsc.read(bs), "hello world how are you?");
         }
         
         // Reset the BS so we can do another test.
         bs.reset();
         
         // Great - now let's force it to purge stuff, so we can confirm
         // that A) the LRU logic isn't totally broken and B) we're meeting
         // our expectations on bit usage.
         {
            nsc = new NetStringCache();
            
            // Write two thousand unique values, then quite a few of the same thing
            for(i=0; i<2048; i++)
               nsc.write(bs, "#" + i);
            
            for(i=0; i<4096; i++)
               nsc.write(bs, "i am long but I will be cached as I am always the same.");
            
            // We should see a fairly low size of the string.
            // Working conservatively, we should have 
            // 4095*2 + 2049 * (2 + 4)  = 20484 bytes in the stream.
            assertTrue(bs.CurrentPosition < 20484*8);
            
            // Do the readback.
            bs.reset();
            
            for(i=0; i<2048; i++)
               assertEquals(nsc.read(bs), "#" + i);
            
            for(i=0; i<4096; i++)
               assertEquals(nsc.read(bs), "i am long but I will be cached as I am always the same.");
         }
         
      }

   }
}