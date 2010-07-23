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
    import flash.utils.*;
    import avmplus.*;
    
    public class SWF
    {
        private var _bitPos:int;
        private var _bitBuf:int;
        
        private var _data:ByteArray;
        
        private var _size:SWFRect;
        private var _frameRate:uint;
        private var _frames:uint;
        private var _abc:ByteArray;
        private var _abcName:String;
        
        public function SWF( data:ByteArray, loadIntoDomain:Domain )
        {
           //trace("decoding SWF");
            _data = data;
            
            _size      = _decodeRect();
            _frameRate = ( _data.readUnsignedByte()<<8 | _data.readUnsignedByte() );
            _frames    = _data.readUnsignedShort();
            
            _decodeTags(loadIntoDomain);
        }
        
        
        private static var verbose:Boolean = false;
        
        private static function _getABCfromSWF( swf:ByteArray, compressed:Boolean, loadIntoDomain:Domain ):ByteArray
        {
            var uswf:ByteArray;
            
            if( compressed )
            {
                uswf = new ByteArray();
                uswf.endian = "littleEndian";
                swf.position = 8;
                swf.readBytes(uswf,0,swf.length-swf.position);
                var usize:int = uswf.length;
                uswf.uncompress();
                
                if( verbose )
                {
                   trace(  "decompressed swf "+usize+" -> "+uswf.length);
                }
                
                uswf.position = 0;
            }
            else
            {
                swf.position = 8
                uswf = swf;
                uswf.endian = "littleEndian";
            }
            
            //trace("parsing swf...");
            var swffile:SWF = new SWF( uswf, loadIntoDomain );
            
            //trace( "SWF abc: " + swffile.abc );
            
            if( verbose )
            {
                trace(  "SWF " + swffile.size.toString() );
                trace(  swffile.frameRate + "fps, frame(s): " + swffile.frames );
                trace(  "abc name: " + swffile.abcName );
            }
            
            return swffile.abc;
        }
        
        private static function _isValidABC( data:ByteArray ):Boolean
        {
            data.position = 0;
            var magic:int = data.readInt();
            
            if( verbose )
            {
                trace(  "abc magic = " + magic.toString(16) );
            }
            
            if( (magic != (46<<16|14)) &&
                (magic != (46<<16|15)) &&
                (magic != (46<<16|16)) )
            {
                trace(  "Error: not an abc file.  magic=" + magic.toString(16) );
                return false;
            }
            
            return true;
        }
        
        /**
         * Load, parse, and execute the specified SWF.
         */
        public static function LoadABCFromFile( filepath:String, loadIntoDomain:Domain ):void
        {
            var file:String = filepath;
            
            var data:ByteArray;
            var abcdata:ByteArray;
            
            if( File.exists( file ) )
            {
                data = ByteArray.readFile( file );
                data.endian = "littleEndian";
                
                var version:uint = data.readUnsignedInt();
                
                switch( version )
                {
                    case 46<<16|14:
                    case 46<<16|15:
                    case 46<<16|16:
                    if( verbose )
                    {
                        trace(  "found *.abc" );
                    }
                    
                    abcdata = data;
                    break;
                    
                    case 67|87<<8|83<<16|9<<24: // SWC9
                    case 67|87<<8|83<<16|8<<24: // SWC8
                    case 67|87<<8|83<<16|7<<24: // SWC7
                    case 67|87<<8|83<<16|6<<24: // SWC6
                    if( verbose )
                    {
                        trace(  "found zipped *.swf" );
                    }
                    
                    abcdata = _getABCfromSWF( data, true, loadIntoDomain );
                    break;
                    
                    case 70|87<<8|83<<16|9<<24: // SWC9
                    case 70|87<<8|83<<16|8<<24: // SWC8
                    case 70|87<<8|83<<16|7<<24: // SWC7
                    case 70|87<<8|83<<16|6<<24: // SWC6
                    case 70|87<<8|83<<16|5<<24: // SWC5
                    case 70|87<<8|83<<16|4<<24: // SWC4
                    if( verbose )
                    {
                        trace(  "found unzipped *.swf" );
                    }
                    
                    abcdata = _getABCfromSWF( data, false, loadIntoDomain );
                    break;
                    
                    default:
                    if( verbose )
                    {
                       trace( 'unknown format '+version);
                    }
                    
                    trace(  "Error: \"" + file + "\" is not an *.abc or *.swf file" );
                    exit( EXIT_FAILURE );
                }
                
                //verify abc magic number
                if( !_isValidABC( abcdata ) )
                {
                    exit( EXIT_FAILURE );
                }
                
                //loadIntoDomain.loadBytes( abcdata );
                
                if( verbose )
                {
                    trace(  "\"" + file + "\" loaded in memory ..." );
                }
            
            }
            else
            {
                trace(  "Error: \"" + file + "\" could not be found" );
                exit( EXIT_FAILURE );
            }
        }
                
        public function get size():SWFRect
        {
            return _size;
        }
        
        public function get frameRate():uint
        {
            return _frameRate;
        }
        
        public function get frames():uint
        {
            return _frames;
        }
        
        public function get abc():ByteArray
        {
            return _abc;
        }
        
        public function get abcName():String
        {
            return _abcName;
        }
        
        private function _decodeRect():SWFRect
        {
            _syncBits();
            
            var rect:SWFRect = new SWFRect();
            
            var nBits:int = _readUBits( 5 );
            
            rect.xMin = _readSBits( nBits );
            rect.xMax = _readSBits( nBits );
            rect.yMin = _readSBits( nBits );
            rect.yMax = _readSBits( nBits );
            
            return rect;
        }
        
        private function _decodeTags(loadIntoDomain:Domain):void
        {
            var type:int
            var h:int;
            var length:int;
            var offset:int;
            
            while( _data.position < _data.length )
            {
                type = (h = _data.readUnsignedShort()) >> 6;
                
                if( ((length = h & 0x3F) == 0x3F) )
                {
                    length = _data.readInt();
                }
                
                //trace( tagNames[type]+" "+length+"b "+int(100*length/_data.length)+"%");
                
                switch( type )
                {
                    case SWFTags.End.valueOf():
                    //trace("end of SWF");
                    return;
                    
                    case SWFTags.DoABC2.valueOf():
                    //trace("saw DoABC2");
                    var pos1:int = _data.position;
                    _data.readInt()
                    _abcName = _readString();
                    length -= (_data.position-pos1);
                    // fall through
                    
                    case SWFTags.DoABC.valueOf():
                    //trace("saw ABC");
                    var data2 = new ByteArray();
                    data2.endian = "littleEndian";
                    _data.readBytes( data2, 0, length );
                    _abc = data2;
                    loadIntoDomain.loadBytes( _abc );
                    break; 
                    
                    default:
                    //trace("skipping ahead " + length);
                    _data.position += length;
                }
            }
        }
        
        
        private function _syncBits():void 
        {
            _bitPos = 0;
        }
        
        private function _readString():String
        {
            var s:String = ""
            var c:int;
            
            while( c = _data.readUnsignedByte() )
            {
                s += String.fromCharCode( c );
            }
            
            return s;
        }
        
        private function _readSBits( numBits:int ):int
        {
            if (numBits > 32)
            {
                throw new Error("Number of bits > 32");
            }
            
            var num:int   = _readUBits( numBits );
            var shift:int = 32 - numBits;
            
            // sign extension
            num = (num << shift) >> shift;
            return num;
        }
        
        private function _readUBits( numBits:int ):uint
        {
            if (numBits == 0)
            {
                return 0;
            }
            
            var bitsLeft:int = numBits;
            var result:int   = 0;
            
            if( _bitPos == 0 ) //no value in the buffer - read a byte
            {
                _bitBuf = _data.readUnsignedByte()
                _bitPos = 8;
            }
            
            while( true )
            {
                var shift:int = bitsLeft - _bitPos;
                
                if( shift > 0 )
                {
                    // Consume the entire buffer
                    result   |= _bitBuf << shift;
                    bitsLeft -= _bitPos;
                    
                    // Get the next byte from the input stream
                    _bitBuf = _data.readUnsignedByte();
                    _bitPos = 8;
                }
                else
                {
                    // Consume a portion of the buffer
                    result  |= _bitBuf >> -shift;
                    _bitPos -= bitsLeft;
                    _bitBuf &= 0xff >> (8 - _bitPos); // mask off the consumed bits
                    
                    //if (print) System.out.println("  read"+numBits+" " + result);
                    return result;
                }
            }
            
            return 0;
        }
        
        
    }
}