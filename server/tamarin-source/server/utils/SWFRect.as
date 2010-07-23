/*
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is [ASTUce: ActionScript Test Unit compact edition CLI]. 
  
  The Initial Developer of the Original Code is
  Zwetan Kjukov <zwetan@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2006-2009
  the Initial Developer. All Rights Reserved.
  
  Contributor(s):
  
*/

package utils
{
    public class SWFRect
    {
        public var nBits:int;
        public var xMin:int;
        public var xMax:int;
        public var yMin:int;
        public var yMax:int;
        
        public function SWFRect()
        {
        }
        
        public function toString():String
        {
            return "[Rect "+xMin+" "+yMin+" "+xMax+" "+yMax+"]";
        }
        
    }
}