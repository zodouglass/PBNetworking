package
{
   import com.pblabs.engine.debug.*;
   import com.pblabs.networking.events.*;

   public class ChatEvent extends GenericNetEvent
   {
      public var message:String;
      
      public static var onChatCallback:Function = null;
      
      public function ChatEvent(msg:String = null)
      {
         super("chat");
         registerField("message");

         message = msg;
      }
      
      public override function process(conn:EventConnection):void
      {
         if(onChatCallback != null)
            onChatCallback(this);
      }
   }
}