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
    import system.Enum;
    
    public class SWFTags //extends Enum
    {
        private var v:int, n:String;
        
        public function SWFTags( value:int = 0, name:String = "" )
        {
           v = value; n = name;
            //super( value, name );
        }
        
        public function valueOf():int
        {
           return v;
        }
        
        public static const End:SWFTags                 = new SWFTags(  0, "End" );
        public static const ShowFrame:SWFTags           = new SWFTags(  1, "ShowFrame" );
        public static const DefineShape:SWFTags         = new SWFTags(  2, "DefineShape" );
        public static const FreeCharacter:SWFTags       = new SWFTags(  3, "FreeCharacter" );
        public static const PlaceObject:SWFTags         = new SWFTags(  4, "PlaceObject" );
        public static const RemoveObject:SWFTags        = new SWFTags(  5, "RemoveObject" );
        public static const DefineBits:SWFTags          = new SWFTags(  6, "DefineBits" );
        public static const DefineButton:SWFTags        = new SWFTags(  7, "DefineButton" );
        public static const JPEGTables:SWFTags          = new SWFTags(  8, "JPEGTables" );
        public static const SetBackgroundColor:SWFTags  = new SWFTags(  9, "SetBackgroundColor" );
        
        public static const DefineFont:SWFTags          = new SWFTags( 10, "DefineFont" );
        public static const DefineText:SWFTags          = new SWFTags( 11, "DefineText" );
        public static const DoAction:SWFTags            = new SWFTags( 12, "DoAction" );
        public static const DefineFontInfo:SWFTags      = new SWFTags( 13, "DefineFontInfo" );
        
        public static const DefineSound:SWFTags         = new SWFTags( 14, "DefineSound" );
        public static const StartSound:SWFTags          = new SWFTags( 15, "StartSound" );
        public static const StopSound:SWFTags           = new SWFTags( 16, "StopSound" );
        
        public static const DefineButtonSound:SWFTags   = new SWFTags( 17, "DefineButtonSound" );
        
        public static const SoundStreamHead:SWFTags     = new SWFTags( 18, "SoundStreamHead" );
        public static const SoundStreamBlock:SWFTags    = new SWFTags( 19, "SoundStreamBlock" );
        
        public static const DefineBitsLossless:SWFTags  = new SWFTags( 20, "DefineBitsLossless" );
        public static const DefineBitsJPEG2:SWFTags     = new SWFTags( 21, "DefineBitsJPEG2" );
        
        public static const DefineShape2:SWFTags        = new SWFTags( 22, "DefineShape2" );
        public static const DefineButtonCxform:SWFTags  = new SWFTags( 23, "DefineButtonCxform" );
        
        public static const Protect:SWFTags             = new SWFTags( 24, "Protect" );
        
        public static const PathsArePostScript:SWFTags  = new SWFTags( 25, "PathsArePostScript" );
        
        public static const PlaceObject2:SWFTags        = new SWFTags( 26, "PlaceObject2" );
        public static const _27:SWFTags                 = new SWFTags( 27, "27 (invalid)" );
        public static const RemoveObject2:SWFTags       = new SWFTags( 28, "RemoveObject2" );
        
        public static const SyncFrame:SWFTags           = new SWFTags( 29, "SyncFrame" );
        public static const _30:SWFTags                 = new SWFTags( 30, "30 (invalid)" );
        public static const FreeAll:SWFTags             = new SWFTags( 31, "FreeAll" );
        
        public static const DefineShape3:SWFTags        = new SWFTags( 32, "DefineShape3" );
        public static const DefineText2:SWFTags         = new SWFTags( 33, "DefineText2" );
        public static const DefineButton2:SWFTags       = new SWFTags( 34, "DefineButton2" );
        public static const DefineBitsJPEG3:SWFTags     = new SWFTags( 35, "DefineBitsJPEG3" );
        public static const DefineBitsLossless2:SWFTags = new SWFTags( 36, "DefineBitsLossless2" );
        public static const DefineEditText:SWFTags      = new SWFTags( 37, "DefineEditText" );
        
        public static const DefineVideo:SWFTags         = new SWFTags( 38, "DefineVideo" );
        
        public static const DefineSprite:SWFTags        = new SWFTags( 39, "DefineSprite" );
        public static const NameCharacter:SWFTags       = new SWFTags( 40, "NameCharacter" );
        public static const ProductInfo:SWFTags         = new SWFTags( 41, "ProductInfo" );
        public static const DefineTextFormat:SWFTags    = new SWFTags( 42, "DefineTextFormat" );
        public static const FrameLabel:SWFTags          = new SWFTags( 43, "FrameLabel" );
        public static const DefineBehavior:SWFTags      = new SWFTags( 44, "DefineBehavior" );
        public static const SoundStreamHead2:SWFTags    = new SWFTags( 45, "SoundStreamHead2" );
        public static const DefineMorphShape:SWFTags    = new SWFTags( 46, "DefineMorphShape" );
        public static const FrameTag:SWFTags            = new SWFTags( 47, "FrameTag" );
        public static const DefineFont2:SWFTags         = new SWFTags( 48, "DefineFont2" );
        public static const GenCommand:SWFTags          = new SWFTags( 49, "GenCommand" );
        public static const DefineCommandObj:SWFTags    = new SWFTags( 50, "DefineCommandObj" );
        public static const CharacterSet:SWFTags        = new SWFTags( 51, "CharacterSet" );
        public static const FontRef:SWFTags             = new SWFTags( 52, "FontRef" );
        
        public static const DefineFunction:SWFTags      = new SWFTags( 53, "DefineFunction" );
        public static const PlaceFunction:SWFTags       = new SWFTags( 54, "PlaceFunction" );
        
        public static const GenTagObject:SWFTags        = new SWFTags( 55, "GenTagObject" );
        
        public static const ExportAssets:SWFTags        = new SWFTags( 56, "ExportAssets" );
        public static const ImportAssets:SWFTags        = new SWFTags( 57, "ImportAssets" );
        
        public static const EnableDebugger:SWFTags      = new SWFTags( 58, "EnableDebugger" );
        
        public static const DoInitAction:SWFTags        = new SWFTags( 59, "DoInitAction" );
        public static const DefineVideoStream:SWFTags   = new SWFTags( 60, "DefineVideoStream" );
        public static const VideoFrame:SWFTags          = new SWFTags( 61, "VideoFrame" );
        
        public static const DefineFontInfo2:SWFTags     = new SWFTags( 62, "DefineFontInfo2" );
        public static const DebugID:SWFTags             = new SWFTags( 63, "DebugID" );
        public static const EnableDebugger2:SWFTags     = new SWFTags( 64, "EnableDebugger2" );
        public static const ScriptLimits:SWFTags        = new SWFTags( 65, "ScriptLimits" );
        
        public static const SetTabIndex:SWFTags         = new SWFTags( 66, "SetTabIndex" );
        
        public static const DefineShape4:SWFTags        = new SWFTags( 67, "DefineShape4" );
        public static const DefineMorphShape2:SWFTags   = new SWFTags( 68, "DefineMorphShape2" );
        
        public static const FileAttributes:SWFTags      = new SWFTags( 69, "FileAttributes" );
        
        public static const PlaceObject3:SWFTags        = new SWFTags( 70, "PlaceObject3" );
        public static const ImportAssets2:SWFTags       = new SWFTags( 71, "ImportAssets2" );
        
        public static const DoABC:SWFTags               = new SWFTags( 72, "DoABC" );
        public static const _73:SWFTags                 = new SWFTags( 73, "73 (invalid)" );
        public static const _74:SWFTags                 = new SWFTags( 74, "74 (invalid)" );
        public static const _75:SWFTags                 = new SWFTags( 75, "75 (invalid)" );
        public static const SymbolClass:SWFTags         = new SWFTags( 76, "SymbolClass" );
        public static const _77:SWFTags                 = new SWFTags( 77, "77 (invalid)" );
        public static const _78:SWFTags                 = new SWFTags( 78, "78 (invalid)" );
        public static const _79:SWFTags                 = new SWFTags( 79, "79 (invalid)" );
        public static const _80:SWFTags                 = new SWFTags( 80, "80 (invalid)" );
        public static const _81:SWFTags                 = new SWFTags( 81, "81 (invalid)" );
        public static const DoABC2:SWFTags              = new SWFTags( 82, "DoABC2" );
        public static const _83:SWFTags                 = new SWFTags( 83, "83 (invalid)" );
        
    }
}
