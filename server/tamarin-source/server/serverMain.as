/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/

// Flash emulation layer from redtamarin
include "flash_accessibility.as"
include "flash_data.as"
include "flash_desktop.as"
include "flash_display.as"
include "flash_errors.as"
include "flash_events.as"
include "flash_external.as"
include "flash_filters.as"
include "flash_geom.as"
include "flash_html.as"
include "flash_media.as"
include "flash_net.as"
include "flash_printing.as"
include "flash_profiler.as"
include "flash_sampler.as"
include "flash_security.as"
include "flash_system.as"
include "flash_text.as"
include "flash_ui.as"
include "flash_utils.as"
include "flash_xml.as"
include "flash_filesystem.as"

// And Global, so we can store references to our stage.
include "Global.as"

// SWF parsing.
include "utils/SWFTags.as"
include "utils/SWFRect.as"
include "utils/SWF.as"

import flash.display.*;
import flash.net.*;
import flash.events.*;
import flash.utils.*;
import com.pblabs.engine.core.Global;
import utils.*;
import avmplus.*;

trace("PushButton Network Server v1.0");

// Storage for the server game object.
var serverGame:* = null;

// Set up a dummy stage, as the servergame will probably not do this.
var dummyStage:Stage = new Stage();
dummyStage.stage = dummyStage;
Global.startup(dummyStage);

// Main tick function.
function tick():Boolean
{   
   // Give Thane some love.
   Thane.heartbeat();
   
   // Kick a frame event to the main class.
   Global.mainClass.dispatchEvent(new Event(Event.ENTER_FRAME));
   
   // Look for connections.
   var acceptedSocket:Socket = ServerSocket.accept();
   if(acceptedSocket)
   {
      trace("Accepted connection: " + acceptedSocket);
      acceptedSocket.forceConnected();
      serverGame.onConnection(acceptedSocket);
   }
   
   // Keep running.
   return true;
}

trace("   - Registering heartbeat callback.");
System.setHeartbeatCallback(tick);

// Parse the command lines.
var listenPort:int = 1337;
var appSwfFile:String = "NetworkDemo.swf";

for(var cmdIdx:int = 0; cmdIdx<System.argv.length; cmdIdx++)
{
   if(System.argv[cmdIdx] == "-p")
      listenPort = System.argv[++cmdIdx];
   else
      appSwfFile = System.argv[cmdIdx];
}

// Attempt to load game SWF.
trace("   - Loading application SWF '" + appSwfFile + "'.");
var serverCodeDomain:Domain = Domain.currentDomain;
SWF.LoadABCFromFile(appSwfFile, serverCodeDomain);

// Locate the server game class.
trace("      o Looking up ServerGame.");
var serverGameClass:Class = serverCodeDomain.getClass("ServerGame");
if(!serverGameClass)
{
   trace("      x Failed.");
   exit(1);
}

// Instantiate it...
trace("      o Instantiating ServerGame.");
serverGame =  new serverGameClass();
trace("      o Calling startGame().");
serverGame.onStart();

// Set up our socket for accepting connections.
trace("Initializing socket.");
var ServerSocket:Socket = new Socket();
trace("   - Listening on port " + listenPort + ".");
if(!ServerSocket.listen(listenPort))
{
	trace("        x Failed!");
	exit(1);
}

// Great, all done, let the program execute normally!
trace("   - Beginning main loop...");

