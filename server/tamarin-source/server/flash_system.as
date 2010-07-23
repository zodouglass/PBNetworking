/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is [Open Source Virtual Machine.].
 *
 * The Initial Developer of the Original Code is
 * Adobe System Incorporated.
 * Portions created by the Initial Developer are Copyright (C) 2004-2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Zwetan Kjukov <zwetan@gmail>.
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

package flash.system
{
    import C.stdlib.getenv;
    
    import avmplus.CompatibilityMode;
    import avmplus.Domain;
    import avmplus.System;
    import avmplus.redtamarin;
    
    import flash.display.Loader;
    import flash.events.EventDispatcher;
    import flash.utils.ByteArray;
    
    public function fscommand(command:String, args:String = ""):void
    {
        
    }
    
    /* note:
       ideally we would want to implement this at the C/C++ level
       to be able to isolate domains,
       not sure it gonna happen, reasons:
       - we are one damn single exe, one app domain make sens here
       - we will not implement security (eg. we share everyhting in the exe)
    */
    public final class ApplicationDomain
    {
        private var _domain:Domain;
        
        public function ApplicationDomain( parentDomain:* = null )
        {
            _domain = new Domain( parentDomain );
        }
        
        public static function get currentDomain():ApplicationDomain
        {
            return new ApplicationDomain( Domain.currentDomain );
        }
        
        public static function get MIN_DOMAIN_MEMORY_LENGTH():uint
        {
            return Domain.MIN_DOMAIN_MEMORY_LENGTH;
        }
        
        public function get parentDomain():ApplicationDomain
        {
            return new ApplicationDomain( _domain );
        }
        
        public function get domainMemory():ByteArray
        {
            return _domain.domainMemory;
        }
        
        public function set domainMemory( value:ByteArray ):void
        {
            _domain.domainMemory = value;
        }
        
        public function getDefinition( name:String ):Object
        {
            return _domain.getClass( name ) as Object;
        }
        
        public function hasDefinition( name:String ):Boolean
        {
            var definition:Object = getDefinition( name );
            
            if( definition )
            {
                return true;
            }
            
            return false;
        }
        
    }
    
    
    public final class IME extends EventDispatcher
    {
        
    }
    
    public final class IMEConversionMode
    {
        
    }
    
    public class LoaderContext
    {
        
    }
    
    public class JPEGLoaderContext extends LoaderContext
    {
        
    }
    
    public final class Security
    {
        
    }
    
    public class SecurityDomain
    {
        
    }
    
    /* note:
       if we implement security somehow
       here the panel could be a CLI
       with readline/writeline instead of a GUI
    */
    public final class SecurityPanel
    {
        
    }
    
    public final class System
    {
        public static function get ime():IME
        {
            return null;
        }
        
        public static function get totalMemory():uint
        {
            return avmplus.System.totalMemory;
        }
        
        /* TODO:
           check the string that AIR / FLash Player return
        */
        public static function get vmVersion():String
        {
            return avmplus.System.getAvmplusVersion();
        }
        
        public static function exit( code:uint ):void
        {
            avmplus.System.exit( code );
        }
        
        public static function gc():void
        {
            //do nothing;
        }
        
        public static function pause():void
        {
            //do nothing;
            //hint: use C.unistd.sleep
        }
        
        public static function resume():void
        {
            //do nothing;
        }
        
        public static function setClipboard(string:String):void
        {
            
        }
        
    }
    
    
}

