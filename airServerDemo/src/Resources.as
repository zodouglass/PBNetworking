/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/

package
{
	import com.pblabs.engine.PBE;
    import com.pblabs.engine.resource.*;
	import com.pblabs.networking.ghosting.GhostComponent;
	import com.pblabs.rendering2D.BasicSpatialManager2D;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.Interpolated2DMoverComponent;
	import com.pblabs.rendering2D.SimpleShapeRenderer;
    
    public class Resources extends ResourceBundle
    {
        [Embed(source = "../assets/levelDescriptions.xml", mimeType = 'application/octet-stream')]
        public var _levelDesc:Class;
        [Embed(source = "../assets/levels/common.xml", mimeType = 'application/octet-stream')]
        public var _levelCommon:Class;
        [Embed(source = "../assets/levels/level1.xml", mimeType = 'application/octet-stream')]
        public var _level1:Class;
        [Embed(source = "../assets/levels/templates.xml", mimeType = 'application/octet-stream')]
        public var _levelTemplates:Class;
		
		/**
		 * Registers the classes with PBE.  
		 * This method is called by both the client and server so that class types do not need to be registered in two locations
		 */
		public static function registerTypes():void
		{
			PBE.registerType(SimpleShapeRenderer);
			PBE.registerType(BasicSpatialManager2D);
			PBE.registerType(DisplayObjectScene);
			PBE.registerType(Interpolated2DMoverComponent);
			PBE.registerType(GhostComponent);
		}
    }
}