package com.pblabs.networking.ghosting
{
   import com.pblabs.engine.PBE;
   import com.pblabs.engine.core.*;
   import com.pblabs.engine.entity.*;
   
   /**
    * Ghost Factory that uses the TemplateManager to manufactore ghost instances.
    */
   public class TemplateGhostFactory implements IGhostFactory
   {
      /**
       * Allow us to specify a specific TemplateManager to use, instead
       * of the global instance.
       */
      public var overrideTemplateManager:TemplateManager = null;
      
      public function makeGhost(prototypeName:String, entityName:String=null):Ghost
      {
         var tm:TemplateManager = overrideTemplateManager;
         if(!tm) tm = PBE.templateManager;
         
         // Try instantiating the specified template.
         var entity:IEntity = tm.instantiateEntity(prototypeName, entityName);
         if(!entity)
            return null;
         
         // See if it has a ghost component on it.
         var entityGhostComponent:GhostComponent = entity.lookupComponentByType(GhostComponent) as GhostComponent;
         if(!entityGhostComponent)
         {
            entity.destroy();
            return null;
         }
         
         // Great, so get the ghost off it and return that.
         return entityGhostComponent.ghostInstance;
      }
   }
}