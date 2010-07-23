package
{
   import com.pblabs.networking.events.*;

   public class CircleEvent extends GenericNetEvent
   {
      public var x:int, y:int;
      
      public static var onCircleCallback:Function = null;
      
      public function CircleEvent()
      {
         super("circle");
         registerField("x");
         registerField("y");
      }
      
      public override function process(conn:EventConnection):void
      {
         if(onCircleCallback != null)
            onCircleCallback(this);
      }
   }
}