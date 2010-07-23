package flash.utils {

import avmplus.Domain;

    import avmplus.*;

    public function describeType (c :Object) :XML
    {
       // Make sure we pass a class in.
       if(!(c is Class))
          c = getDefinitionByName(avmplus.getQualifiedClassName(c));

          return avmplus.describeType(c, 0xFFFF);
    }

    public function getDefinitionByName (name :String) :Class
    {
       return Domain.currentDomain.getClass(name.replace("::", "."));
    }

   public function getQualifiedClassName (c :*) :String
   {
       return avmplus.getQualifiedClassName(c);
   }
   
   public function getQualifiedSuperclassName (c :*) :String
   {
       return avmplus.getQualifiedSuperclassName(c);
   }


}
