package PBLabs.Networking.Tests
{
   import net.digitalprimates.fluint.tests.TestSuite;

   public class NetworkingTestSuite extends TestSuite
   {
      public function NetworkingTestSuite()
      {
         addTestCase(new GhostTests());
         addTestCase(new EventTests());
         addTestCase(new NetElementTests());
         addTestCase(new BitStreamTests());
         addTestCase(new NetStringCacheTests());
      }
   }
}