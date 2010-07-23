package com.pblabs.networking.elements
{
   import com.pblabs.networking.core.*;
   
   import flash.utils.Dictionary;
   
   import mx.utils.*;
   
   /**
    * NetRoot wraps an XML bitstream protocol description to simplify 
    * serializing/deserializing your data.
    * 
    * Basically, you describe the protocol you want in a simple XML syntax. Then
    * the XML description is used to construct a tree of NetElement subclasses,
    * which do the actual serialization/deserialization.
    * 
    * Elements in the tree are named, and can have their values set or retrieved
    * by those names. So you can have an element named "id" and set it to 12.
    * But because the protocol is defined in XML, you can tweak how many bits
    * are used, or wrap it in a flag so that the data is only sent if the flag
    * is true.
    * 
    * The NetElements system also interfaces with Ghosts. Using the dirtyFlag
    * tag, you can group like fields together. If any one of them changes in the
    * ghosted object, then all are updated.
    */
   public class NetRoot extends NetElementContainer implements INetElement, INetElementContainer
   {
      private static var smRoots:Dictionary = new Dictionary();
      
      /**
       * Parse XML descriptions of protocol and store by name.
       */
      public static function loadNetProtocol(libraryText:String):void
      {
         var parsedData:XML = new XML(libraryText);

         for each(var e:XML in parsedData.*)
         {
            smRoots[e.@name.toString().toLowerCase()] = createFromXML(e.toString());
         }         
      }
      
      /**
       * Fetch a NetRoot from a named item in the library. This makes a deep
       * copy, so serialization state is not shared between objects.
       */
      public static function getByName(name:String):NetRoot
      {
         if(!smRoots)
            return null;
         
         if(!smRoots[name.toLowerCase()])
            return null;
            
         return (smRoots[name.toLowerCase()] as NetRoot).deepCopy() as NetRoot;
      }
      
      /**
       * Create a NetRoot directly from an XML description.
       */
      public static function createFromXML(x:String):NetRoot
      {
         var parsedData:XML = new XML(x);
         
         var nr:NetRoot = new NetRoot();
         parseFromXML(parsedData, nr);
         nr.setName(parsedData.@name.toString());
         return nr;
      }
      
      private static function parseFromXML(x:XML, container:INetElementContainer):void
      {
         for each(var e:XML in x.*)
         {
            var ne:INetElement = null;
            
            // Identify the kind of element we need to add...
            var newElemName:String  = e.name().toString();
            
            if(newElemName.toLowerCase() == "string")
            {
               ne = new StringElement();
            }
            else if(newElemName.toLowerCase() == "cachedstring")
            {
               ne = new CachedStringElement();
            }
            else if(newElemName.toLowerCase() == "float")
            {
               ne = new FloatElement();
            }
            else if(newElemName.toLowerCase() == "flag")
            {
               ne = new FlagElement();
               parseFromXML(e, ne as INetElementContainer);
            }
            else if(newElemName.toLowerCase() == "dirtyflag")
            {
               ne = new DirtyFlagElement();
               parseFromXML(e, ne as INetElementContainer);
            }
            else if(newElemName.toLowerCase() == "rangedint")
            {
               ne = new RangedIntElement();
            }
            else
            {
               throw new Error("Unknown tag " + newElemName);
            }
            
            // Set the name
            ne.setName(e.@name.toString());
            
            // Let it parse itself...
            ne.initFromXML(e);
            
            // Add it to the root...
            container.addElement(ne);            
         }
      }

      /**
       * Map dirty bit indices to a DirtyFlagElement.
       */
      private var bitToDirtyFlagMap:Array = null;
      
      /**
       * Map INetElements to their dirty flags.
       */
      private var elementsToDirtyFlagsMap:Dictionary = null;
      
      private function updateDirtyFlagMap_r(item:INetElement, activeDirtyFlags:int):void
      {
         // Is this one a dirty flag?
         var curFlag:DirtyFlagElement = item as DirtyFlagElement
         if(curFlag)
         {
            // Assign an ID.
            curFlag.dirtyFlagIndex = bitToDirtyFlagMap.length;
            bitToDirtyFlagMap.push(curFlag);
            
            // Note the new bit in our parameter.
            activeDirtyFlags |= 1 << curFlag.dirtyFlagIndex;
         }
         
         // Note what flags this element is affected by.
         elementsToDirtyFlagsMap[item] = activeDirtyFlags;
         
         // Process children.
         var curContainer:INetElementContainer = item as INetElementContainer;
         if(!curContainer)
            return;

         for(var i:int=0; i<curContainer.getElementCount(); i++)
            updateDirtyFlagMap_r(curContainer.getElementByIndex(i), activeDirtyFlags);
      }
      
      private function updateDirtyFlagMap():void
      {
         // Wipe existing data.
         bitToDirtyFlagMap = new Array();
         elementsToDirtyFlagsMap = new Dictionary(true);
         
         // Traverse the whole tree and assign dirty flags.
         updateDirtyFlagMap_r(this, 0);
      }

      /**
       * An element may have one or more dirty bits that correspond to it.
       * For instance, it might nested two deep in DirtyFlags. So this 
       * returns whatever bits need to be set when it changes for it to
       * get serialized.
       */
      public function getElementDirtyBits(name:String):Number
      {
         if(!bitToDirtyFlagMap)
            updateDirtyFlagMap();
         
         return elementsToDirtyFlagsMap[getElement(name)];
      }
      
      /**
       * Tells you the name of the DirtyFlag element that corresponds to
       * the specified bit. Notice that bit is a log2 parameter, ie the 4th
       * bit would be 0x8 from GetElementDirtyBits but 4 here.
       */
      public function getDirtyBitElement(bit:int):DirtyFlagElement
      {
         if(!bitToDirtyFlagMap)
            updateDirtyFlagMap();

         return bitToDirtyFlagMap[bit];
      }
      
      /**
       * Set the state of all the DirtyFlag nodes in this root based on 
       * dirty bits.
       */
      public function setDirtyState(v:int):void
      {
         if(!bitToDirtyFlagMap)
            updateDirtyFlagMap();

         for(var i:int=0; i<bitToDirtyFlagMap.length; i++)
            (bitToDirtyFlagMap[i] as DirtyFlagElement).value = Boolean((1<<i) & v);
      }
   }
}