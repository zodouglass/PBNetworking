package PBLabs.Networking.Tests
{
   import PBLabs.Networking.Core.*;
   import net.digitalprimates.fluint.tests.*;

   /**
    * Various tests for the BitStream class. We captured
    * witnesses from the Java test suite to ensure that we're
    * testing identical data both here and there.
    */
   public class BitStreamTests extends TestCase
   {
      public function BitStreamTests()
      {
      }
      
        public static function suite():TestSuite {
            var ts:TestSuite = new TestSuite();
            
            ts.addTestCase( new BitStreamTests( ) );
            
            return ts;
         }
         
         public function testReadBit():void
         {
            var data:Array = [1, -128];
            
            var bs:BitStream = new BitStream(data);

         assertTrue("First bit we read should be true!", bs.readFlag());
         for(var i:int=0; i<14; i++)
            assertFalse("Next 14 bits should be false.", bs.readFlag());
         assertTrue("Last bit we read should be true!", bs.readFlag());
         assertTrue("We should be EOS after reading all 16 bits we put in.", bs.IsEof);         
         }
         
         public function testReadByte():void
         {
         var data:Array = [34, 209];
            
            var bs:BitStream = new BitStream(data);

            assertEquals(bs.readByte(), 34);
         assertEquals(bs.readByte(), 209);
         assertTrue("We end at EOS.", bs.IsEof);
         }
         
         public function testReadWriteBits():void
         {
         var witness:Array = [13];

            var bs:BitStream = new BitStream(1);

         bs.writeFlag(true);
         bs.writeFlag(false);
         bs.writeFlag(true);
         bs.writeFlag(true);
         
         bs.reset();
         
         assertTrue("First bit true.",   bs.readFlag());
         assertTrue("Second bit false.", bs.readFlag() == false);
         assertTrue("Third bit true.",   bs.readFlag());
         assertTrue("Fourth bit true.",  bs.readFlag());
         }
         
         public function testReadWriteBytes():void
         {
         var witness:Array = [-66, -17, -16, 13];

            var bs:BitStream = new BitStream(4);

         bs.writeByte(0xBE);
         bs.writeByte(0xEF);
         bs.writeByte(0xF0);
         bs.writeByte(0x0D);
         
         bs.reset();
         
         assertEquals(bs.readByte(), 0xBE);
         assertEquals(bs.readByte(), 0xEF);
         assertEquals(bs.readByte(), 0xF0);
         assertEquals(bs.readByte(), 0x0D);

         assertTrue(bs.IsEof);
         }
         
         public function testMixedReadWrite():void
         {
         var witness:Array = [87, -101, -67, 3, 4];

            var bs:BitStream = new BitStream(5);

         bs.writeFlag(true);
         bs.writeByte(0xAB);
         bs.writeByte(0xCD);
         bs.writeFlag(false);
         bs.writeByte(0xEF);
         bs.writeByte(0x00);
         bs.writeFlag(true);
         
         bs.reset();
         
         assertTrue("First bit should be true.", bs.readFlag());
         assertEquals(bs.readByte(), 0xAB);
         assertEquals(bs.readByte(), 0xCD);
         assertFalse("Middle bit should be false.", bs.readFlag());
         assertEquals(bs.readByte(), 0xEF);
         assertEquals(bs.readByte(), 0x00);
         assertTrue("Last bit should be true.", bs.readFlag());
         }
         
         public function testStringReadWrite():void
         {
         var witness:Array = [23, 32, -107, -27, -127, -48, -95, -107, -55, -107, -127, 36, -127, -124, -75, -127, -124, -127, -52, -47, -55, -91, -71, -99, -27, 64, -112, -37, 27, 29, 90, -103, 28, -56, 28, -99, 92, -102, -37, -39, 5];
            
         var test1:String = "Hey there I am a string";
         var test2:String = "Another string";
      
            var bs:BitStream = new BitStream(64);

         bs.writeString(test1);
         bs.writeFlag(true);
         bs.writeFlag(false);
         bs.writeString(test2);
         bs.writeByte(23);
         
         bs.reset();
         
         assertEquals(bs.readString(), test1);
         assertTrue  (bs.readFlag());
         assertFalse (bs.readFlag());
         assertEquals(bs.readString(), test2);
         assertEquals(bs.readByte(), 23);
         }
         
         public function testRangedReadWrite():void
         {
         var witness:Array = [-96, 80, 0, 0, -4, 31];
            var bs:BitStream = new BitStream(64);
            
         bs.writeRangedInt(5,  5, 25);
         bs.writeRangedInt(10, 5, 25);
         bs.writeRangedInt(25, 5, 25);
         
         bs.writeRangedInt(0,    0, 1024);
         bs.writeRangedInt(512,  0, 1024);
         bs.writeRangedInt(1023, 0, 1024);
   
         bs.reset();
         assertEquals(bs.readRangedInt(5, 25), 5);
         assertEquals(bs.readRangedInt(5, 25), 10);
         assertEquals(bs.readRangedInt(5, 25), 25);
         
         assertEquals(bs.readRangedInt(0, 1024), 0);
         assertEquals(bs.readRangedInt(0, 1024), 512);
         assertEquals(bs.readRangedInt(0, 1024), 1023);         
      }

      public function testIntReadWrite():void
      {
         var bs:BitStream = new BitStream(128);
         
         // Test smaller bit counts by checking every value.
         // Here we check everything from 1 to 8 bits.
         for(var curCount:int=0; curCount<=8; curCount++)
         {
            var maxVal:int = (1 << curCount)-1;
            for(var curVal:int=1; curVal<=maxVal; curVal++)
            {
               // Write some test data.
               bs.reset();
               bs.writeFlag(true);
               bs.writeFlag(false);
               bs.writeInt(curVal, curCount);
               bs.writeByte(0x13);
               
               // Read it back.
               bs.reset();
               assertTrue(bs.readFlag());
               assertFalse(bs.readFlag());
               assertEquals(bs.readInt(curCount), curVal);
               assertEquals(bs.readByte(), 0x13);
            }
         }
         
         // For higher bit counts, we run a hundred random numbers through each count.
         for(curCount=9; curCount<=32; curCount++)
         {
            maxVal = (1 << curCount) - 1;
            for(var trial:int=0; trial<100; trial++)
            {
               // Generate a random value.
               var randVal:int = Math.floor(Math.random() * maxVal);
               
               // Write the data out. We also write zero and max to be sure they
               // encode ok.
               bs.reset();
               bs.writeByte(0xFF);
               bs.writeInt(randVal, curCount);
               bs.writeInt(0, curCount);
               bs.writeInt(maxVal, curCount);
               bs.writeFlag(true);
               
               // And read it back...
               bs.reset();
               assertEquals(bs.readByte(), 0xFF);
               assertEquals(bs.readInt(curCount), randVal);
               assertEquals(bs.readInt(curCount), 0);
               assertEquals(bs.readInt(curCount), maxVal);
               assertTrue(bs.readFlag());
            }
         }
      }
   
      public function testFloatReadWrite():void
      {
         var bs:BitStream = new BitStream(128);
         
         // Determining the exact decimation that will occur is hard, so
         // instead we'll estimate acceptable error and fail if we exceed
         // that.
         //
         // (Note: simply duplicating the decimation that happens in the
         //  writeFloat isn't a suitable test; we need an independent test.)
         
         for(var bitCount:Number=2; bitCount<=30; bitCount++)
         {
            // Figure the acceptable error at this bit count.
            var acceptableError:Number = 1.0 / Number(((1<<bitCount)-1));
            
            // We choose a hundred random numbers, encode, decode, and validate them.
            for(var i:int=0; i<100; i++)
            {
               var randNum:Number = Math.random();
               
               bs.reset();
               bs.writeFloat(randNum, bitCount);
               
               bs.reset();
               var result:Number = bs.readFloat(bitCount);
               
               if(Math.abs(randNum - result) > acceptableError)
                  fail("Exceeded acceptable error (randNum=" + randNum + ", result=" + result +
                      ", error=" + Math.abs(randNum - result) + ", acceptableError=" + acceptableError);
            }
         }
         
         /*
         // We test the 32 bit case separately, since it should match one-to-one
         // with what we put in.
         for(int i=0; i<100; i++)
         {
            float randNum = (float)Math.random();
            
            bs.reset();
            bs.writeFloat(randNum, 32);
            
            bs.reset();
            float result = bs.readFloat(32);
            
            assertEquals(randNum, result);
         }
         */
            
      }
   }
}