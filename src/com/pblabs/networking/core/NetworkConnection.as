package com.pblabs.networking.core
{
   import com.pblabs.engine.debug.*;
   
   import flash.events.*;
   import flash.net.Socket;
   import flash.utils.*;
   
   /**
    * Basic network connection which can send and receive fixed size "packets"
    * over a TCP stream. We refer to "packets" because if we ever support UDP
    * then they will become real individual packets flying over the wire.
    * 
    * This deals with most of the hassle around opening or accepting a connection.
    * 
    * Packets are (currently) 100 bytes in size with a 2 byte short indicating
    * how many bytes are in use. These are configured using constants.
    * 
    * We use fixed size packets at a fixed rate in order to have very consistent
    * bandwidth usage. This is important because routers will tend to allocate
    * bandwidth to those that use it. If we have an uneven bandwidth usage, then
    * when a lot of activity comes down the wire, there may be a lag spike or
    * dropped packets as routers along the network path adjust to the new load.
    * 
    * Subclasses implement their own logic in ReadPacket/WritePacket (making
    * sure to pass control up to the super class).
    * 
    * You will not ever need to call any of the send packet methods except in
    * test/debug situations as NetworkInterface deals with it for you. The
    * receive methods are called automatically as data comes in, as well.
    */
   public class NetworkConnection
   {
      /**
       * The host name or IP that we are connected to.
       */ 
      public function get host():String
      {
         return _host;
      }
      
      /**
       * The port that we are connected to.
       */
      public function get port():int
      {
         return _port;
      }
      
      /**
       * Called every so often from the NetworkInterface to give us a chance 
       * to send packets.
       */
      internal function tick():void
      {
         // For now, just send a packet every network tick (about 10hz).
         sendPacket();
      }

      /**
       * Associate this connection with a socket that's been opened to us.
       * Called by the server, and only called once on a connection.
       */ 
      public function acceptClientConnection(s:Socket, host:String, port:int):void
      {
         // Add us to the network interface.
         NetworkInterface.instance.addConnection(this);
         
         // Note who the connection is with.
         _host = host;
         _port = port;
         
         // Set up the socket.
         socket = s;
         configureListeners();
      }
      
      /**
       * Create a new socket and open a connection to a host.
       */ 
      public function connectToServer(host:String, port:int):void
      {
         // Add us to the network interface.
         NetworkInterface.instance.addConnection(this);
         
         // Create & connect with a socket.
         socket = new Socket(host, port);
         _host = host;
         _port = port;
         configureListeners();
      }
      
      /**
       * Returns true when there is data to send.
       */ 
      public function get hasDataPending():Boolean
      {
         return false;
      }
      
      /**
       * Read a packet contained in a BitStream.
       */
      protected function readPacket(bs:BitStream):void
      {
         bs.stringCache = stringCache;
         
         // Do nothing - subclasses will implement this!
      }
      
      /**
       * Write a packet to the provided BitStream.
       */
      protected function writePacket(bs:BitStream):void
      {
         bs.stringCache = stringCache;
         
         // Do nothing - subclasses will implement this!
      }
      
      /**
       * Prepare and send a packet.
       */ 
      public function sendPacket():void
      {
          if(!socket.connected)
          {
              // Just wait if we never were connected.
              if(!_wasConnected)
                  return;
             Logger.error(this, "SendPacket", "Could not send packet on a closed socket!");
             NetworkInterface.instance.removeConnection(this);
             return;
          }
          
          _wasConnected = true;
          
          var bs:BitStream = new BitStream(PACKETSIZE);
          bs.reset();
          writePacket(bs);
          transmitPacket(bs);
      }
      
      /**
       * En-packet-ize and transmit a BitStream down the wire.
       */
      public function transmitPacket(bs:BitStream):void
      {
         // Write bitstream.
         var ba:ByteArray = new ByteArray();
         ba.writeShort(Math.ceil(bs.currentPosition / 8.0));
         ba.writeBytes(bs.getByteArray(), 0, PACKETSIZE);
         
         ba.position = 0;
         if(NetworkDebugVisualizer.getSingleton())
         	NetworkDebugVisualizer.getSingleton().reportOutgoingTraffic(ba);
         
         socket.writeBytes(ba, 0, PACKETSIZE + LENGTHFIELDSIZE);
         socket.flush();
		 
		// Logger.print(this, "transmitPacket" + getTimer() );
      }
      
       /**
        * Same as SendPacket, but write to a buffer rather than across the wire.
        */ 
       public function sendPacketToBuffer(buffer:ByteArray):void
       {
          // Prepare packet.
          var bs:BitStream = new BitStream(PACKETSIZE);
          bs.reset();
          writePacket(bs);
          
          // Write bitstream.
          var ba:ByteArray = buffer;
          ba.writeShort(Math.ceil(bs.currentPosition / 8.0));
          ba.writeBytes(bs.getByteArray(), 0, PACKETSIZE);
          ba.position = 0;
       }
      
      /**
       * Send data until there is none more remaining. NOTE: This can
       * run forever if there is always data available (like with networked
       * state).
       */ 
      protected function sendPackets():void
      {
          var bs:BitStream = new BitStream(PACKETSIZE);
          
          while(hasDataPending)
          {
             bs.reset();
             writePacket(bs);
             transmitPacket(bs);
          }         
      }
      
      /**
       * Look for one or more packets buffered in the socket, parse and process
       * them.
       */ 
      private function readPackets():void
      {
          // We are looking for a specific scenario here - if there are say 16
          // bytes available and it's the first response, then it's probably
          // a policy request. So we check for a certain starting length which
          // indicates that the first two bytes are '<p' (the start of
          // the policy request). If they are, then we respond with the policy
          // response that allows access. If not then we continue with our lives
          // normally.
          
          var firstDataLen:int = -1;
          if(firstResponse && socket.bytesAvailable > 10)
          {
             firstDataLen = socket.readShort();
             Logger.print(this, "First len was " + firstDataLen + " with " + socket.bytesAvailable + " bytes available.");

             // If the length is equal to '<p' then it is a policy request. 
             if(firstDataLen == 15472)
             {
                Logger.print(this, "sending cross-domain-policy XML response.");
                // this should already be handled through the Server
                socket.writeUTFBytes(
                "<?xml version=\"1.0\"?>" + 
                "<!DOCTYPE cross-domain-policy SYSTEM \"/xml/dtds/cross-domain-policy.dtd\">"+
                "<cross-domain-policy>" +
				"<site-control permitted-cross-domain-policies=\"master-only\"/>" +
                "<allow-access-from domain=\"*\" to-ports=\"1337\" />" + 
                "</cross-domain-policy>");
                socket.flush();
				
                return;
             }
             
             firstResponse = false;
          }
          
          // Ok, go into our normal parse loop.
          while(socket.bytesAvailable >= PACKETSIZE + LENGTHFIELDSIZE || firstDataLen != -1)
          {
             // Reuse the original read if we made one, otherwise it's -1 and
             // we read it ourselves.
             var dataLen:int = firstDataLen;
             if(dataLen == -1)
                dataLen = socket.readShort();
             else
                Logger.print(this, "Suppressing readShort");
                
             // All subsequent reads are done properly.
             firstDataLen = -1;
             
             var bytes:ByteArray = new ByteArray();
             socket.readBytes(bytes, 0, PACKETSIZE);
             
             if(dataLen)
             {
      	        if(NetworkDebugVisualizer.getSingleton())
                   NetworkDebugVisualizer.getSingleton().reportIncomingTraffic(bytes);
   
                //trace("Got " + dataLen + " bytes of real data.");
                var bs:BitStream = new BitStream(bytes);
                readPacket(bs);
             }
         }         
      }
      
      /**
       * Parse a buffer of packets and process them with ReadPacket.
       */
      public function readPacketsFromBuffer(ba:ByteArray):void
      {
         while(ba.bytesAvailable >= PACKETSIZE + LENGTHFIELDSIZE)
         {
            var dataLen:int = ba.readShort();
            var bytes:ByteArray = new ByteArray();
            ba.readBytes(bytes, 0, PACKETSIZE);
              
            // Skip empty packets.
            if(!dataLen)
               continue;

            var bs:BitStream = new BitStream(bytes);
            readPacket(bs);
         }            
      }

      /**
       * Hook up listeners to our socket.
       */
      private function configureListeners():void 
      {
         socket.addEventListener(Event.CLOSE, closeHandler);
         socket.addEventListener(Event.CONNECT, connectHandler);
         socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
         socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
         socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
      }

      private function closeHandler(event:Event):void
      {
          _wasConnected = true;
         Logger.print(this, "closeHandler: " + event);
         
         // Remove ourselves from the NetworkInterface.
         NetworkInterface.instance.removeConnection(this);
      }
 
      private function connectHandler(event:Event):void 
      {
          _wasConnected = true;
         Logger.error(this, "connectHandler", event.toString());
      }
 
      private function ioErrorHandler(event:IOErrorEvent):void 
      {
          _wasConnected = true;
         Logger.error(this, "ioErrorHandler", event.toString());
      }
 
      private function securityErrorHandler(event:SecurityErrorEvent):void 
      {
          _wasConnected = true;
         Logger.error(this, "securityErrorHandler", event.toString());
      }
 
      private function socketDataHandler(event:ProgressEvent):void 
      {
		 // Logger.print(this, "socketDataHandler " + getTimer() );
          _wasConnected = true;
         readPackets();
      }

      protected var stringCache:NetStringCache = new NetStringCache();
      private var firstResponse:Boolean = true;
      private var socket:Socket = null;
      private var _host:String; 
      private var _port:int;
      private var _wasConnected:Boolean = false;
      
      /**
       * Size of the packets in bytes that we will be sending over the wire. You
       * can tweak this to suit your application.
       */ 
      private const PACKETSIZE:int = 100;
      
      /**
       * Size of the length field preceding each packet in bytes. This 
       * is sizeof(short) currently.
       */
      private const LENGTHFIELDSIZE:int = 2;
   }
}