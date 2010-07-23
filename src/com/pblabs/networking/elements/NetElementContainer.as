package com.pblabs.networking.elements
{
   import com.pblabs.networking.core.*;
   
   import flash.utils.*;
   
   /**
    * Base class for NetElements that can contain other NetElements.
    */
   public class NetElementContainer implements INetElement, INetElementContainer, IContainerAccessors
   {
      public function getName():String
      {
         return name;
      }
      
      public function setName(v:String):void
      {
         name = v;
      }
      
      public function serialize(bs:BitStream):void
      {
         for each(var e:INetElement in elementList)
            e.serialize(bs);
      }
      
      public function deserialize(bs:BitStream):void
      {
           for each(var e:INetElement in elementList)
              e.deserialize(bs);
      }
      
      public function initFromXML(xml:XML):void
      {
      }
      
      public function deepCopy():INetElement
      {
         // Get our class and make a new instance of it. This allows us
         // to work properly with subclasses.
         var thisClassName:String = getQualifiedClassName(this);
         if(!thisClassName)
            throw Error("Somehow we don't know about our own class's name!");
         
         var thisClass:Class = getDefinitionByName(thisClassName) as Class;
         if(!thisClass)
            throw Error("Somehow we don't know about our own class!");
         
         var thisCopy:NetElementContainer = new thisClass;
         if(!thisCopy)
            throw Error("Somehow we can't instantiate a new version of ourselves.");
         
         // Actually copy contents.
         thisCopy.setName(getName());
         for(var i:int=0; i<elementList.length; i++)
            thisCopy.addElement((elementList[i] as INetElement).deepCopy());
         return thisCopy;
      }
      
      public function addElement(e:INetElement):void
      {
         elementList.push(e);
      }
      
      public function getElement(name:String):INetElement
      {
         for(var i:int=0; i<elementList.length; i++)
         {
            // Check this element for a match.
            var curNE:INetElement = elementList[i] as INetElement;
            
            if(curNE.getName().toLowerCase() == name.toLowerCase())
               return curNE;
               
            // Or maybe it's a container?
            var curNEC:INetElementContainer = curNE as INetElementContainer;
            if(!curNEC)
               continue;
               
            // Great, ask it for a match.
            var curNECChild:INetElement = curNEC.getElement(name);
            if(curNECChild)
               return curNECChild;
         }

         return null;
      }

      public function getElementCount():int
      {
         return elementList.length;
      }
      
      public function getElementByIndex(index:int):INetElement
      {
         return elementList[index];         
      }
      

      public function getString(name:String):String
      {
         return (getElement(name) as IStringNetElement).getValue();
      }
      
      public function getInteger(name:String):int
      {
         return (getElement(name) as IIntegerNetElement).getValue();
      }
      
      public function getFloat(name:String):Number
      {
         return (getElement(name) as IFloatNetElement).getValue();
      }
      
      public function getBoolean(name:String):Boolean
      {
         return (getElement(name) as IBooleanNetElement).getValue();
      }

      public function setString(name:String, v:String):void
      {
         return (getElement(name) as IStringNetElement).setValue(v);
      }
      
      public function setInteger(name:String, v:int):void
      {
         return (getElement(name) as IIntegerNetElement).setValue(v);
      }
      
      public function setFloat(name:String, v:Number):void
      {
         return (getElement(name) as IFloatNetElement).setValue(v);
      }
      
      public function setBoolean(name:String, v:Boolean):void
      {
         return (getElement(name) as IBooleanNetElement).setValue(v);
      }

      private var name:String;
      private var elementList:Array = new Array();
   }
}