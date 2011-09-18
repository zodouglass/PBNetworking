package com.pblabs.networking.core
{
   import flash.utils.ByteArray;
   
   import mx.controls.TextArea;
   import mx.core.*;
   
   
   /**
    * Debug aid to visualize network traffic as it goes across the wire. It
    * receives callbacks, and looks for a TextArea called netDebugTextArea on the
    * root Application.application to display results in. This API is only used
    * internally so is not heavily documented.
    */ 
   public class NetworkDebugVisualizer
   {
      public static var smEnabled:Boolean = false;
   	
      private static var smSingleton:NetworkDebugVisualizer = null;
      
      /**
       * Get the global instance of the visualizer.
       */ 
      public static function getSingleton():NetworkDebugVisualizer
      {
      	 // Don't create it unless we are enabling the visualizer.
      	 if(smEnabled == false)
      	    return null;
      	    
         if(!smSingleton)
            smSingleton = new NetworkDebugVisualizer();
         return smSingleton;
      }
      
      private var textDisplay:TextArea;
      private var log:Array = new Array();
      
      public function NetworkDebugVisualizer()
      {
         // Find the debug text area.
         if(FlexGlobals.topLevelApplication.hasOwnProperty("netDebugTextArea"))
            FlexGlobals.topLevelApplication.netDebugTextArea.htmlText = "";
      }
      
      public function reportOutgoingTraffic(data:ByteArray):void
      {
         // Convert to a string.
         var outStr:String = "<P ALIGN=\"LEFT\"><b><FONT COLOR=\"#00FF00\">";
         
         while(data.bytesAvailable)
         {
            outStr += data.readUTFBytes(1);
         }
         
         outStr += "</FONT></b></p>";
         
         addLog(outStr);         
      }
      
      public function reportIncomingTraffic(data:ByteArray):void
      {
         // Convert to a string.
         var outStr:String = "<P ALIGN=\"RIGHT\"><b><FONT COLOR=\"#FF2222\">";
         
         var oldPosition:int = data.position;
         while(data.bytesAvailable)
            outStr += data.readUTFBytes(1);
         data.position = oldPosition;
         
         outStr += "</FONT></b></p>";
         
         addLog(outStr);         
      }
      
      public function addLog(s:String):void
      {
         // Update the log.
         log.push(s);
         
         // Cap to last few entries.
         while(log.length > 25)
            log.shift();
         
         // Regenerate the text.
         if(FlexGlobals.topLevelApplication.hasOwnProperty("netDebugTextArea"))
         {
            FlexGlobals.topLevelApplication.netDebugTextArea.htmlText = "";
            for(var i:int=log.length-1; i>=0; i--)
            {
               FlexGlobals.topLevelApplication.netDebugTextArea.htmlText += log[i];         
            }            
         }
      }

   }
}