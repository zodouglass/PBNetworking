package 
{
	import com.pblabs.engine.core.TemplateManager;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.networking.server.IServerGame;
	import com.pblabs.rendering2D.ui.SceneView;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import com.pblabs.engine.PBE;
	import flash.utils.getDefinitionByName;
	
	/**
	 * A Simple example of using AIR 2.0 SocketServer class to run a PushButtonEngine Server
	 * Listens for client socket connections, handles security for policy files, and contains a single instance of ServerGame.
	 * This example only runs a single instance of the game, but could be expanded to host multiple "rooms" over different ports.
	 * @author Zo Douglass
	 */
	public class ServerMain extends Sprite 
	{
		private var server:ServerSocket = new ServerSocket(); 
		private var policySocket:ServerSocket = new ServerSocket();
		private var port:int = 1337;
		
		/**
		 * Socket policy file
		 * @see http://www.adobe.com/devnet/flashplayer/articles/fplayer9_security.html#articlecontentAdobe_numberedheader_1
		 * @see http://www.adobe.com/devnet/flashplayer/articles/socket_policy_files.html
		 */
		private var policy:String = '<?xml version="1.0"?><cross-domain-policy>' +
									'<site-control permitted-cross-domain-policies="master-only"/>' +
									'<allow-access-from domain="*" to-ports="' + port + '" />' +
									'</cross-domain-policy>\x00'; 
		
		private var serverGame:IServerGame;
		
		private var scene:SceneView;
		
		public function ServerMain():void 
		{
			if ( this.stage )
				init();
			else
				this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			Logger.print(this, "ServerSocket started");
			
			server.addEventListener(Event.CONNECT, onConnect);
			
			server.bind(port); // Pass in the port number you want to listen on
			server.listen();
			
			policySocket.addEventListener( Event.CONNECT, onPolicyConnect );
			policySocket.bind( 843 ); //843 is adobe's default server policy port where the client will first check for permissions
			policySocket.listen();
			
			Logger.print(this,  "Running Policy File Server on port 843");
			Logger.print(this, "Running Game Server on port " + port );
			Logger.print(this,  "Starting PBE...");
			
			//register class types with PBE.  This is in a central location so both server and client can call this.
			Resources.registerTypes();
			
			// Set up the scene view.
			scene = new SceneView();
            scene.name = "MainView";
            scene.x = 0;
            scene.y = 0;
            scene.width = 640;
            scene.height = 480;
            addChild(scene);
			
			//PBE requires a scene at startup, so pass the server scene, which we can remove later
			PBE.startup(scene);
			
			serverGame = new ServerGame();
			serverGame.onStart();
			
			//dedicated server doesnt need the scene view rendering, so remove the scene after startup
			//removeChild(scene);
		}
		
		
		private function onPolicyConnect(e:ServerSocketConnectEvent):void
		{
			Logger.print(this, "onPolicyConnect::" + e.toString());
			
			//write the policy file to the client, but do NOT call the close() method (the socket will close on its own), 
			//Manually closing the policy socket sometimes causes the main socket connection to re-request the policy file.
			var incomingSocket:Socket = e.socket;
			incomingSocket.writeUTFBytes(policy );
			incomingSocket.flush(); 
			
		}
		
		private function onConnect(e:ServerSocketConnectEvent):void
		{
			// You can now read and write data from the socket instance
			Logger.print(this, "OnSocketConnect::" + e.toString());
			
			var clientSocket:Socket = e.socket;
			clientSocket.addEventListener(Event.CLOSE, onClose);
			
			//setup the ghost connection by calling the onConnection method in the IServerGame class
			serverGame.onConnection( clientSocket );
		}
		
		private function onClose(e:Event):void
		{
			Logger.print(this,"onClose::" + e.toString());
			var clientSocket:Socket = e.target as Socket;
			clientSocket.removeEventListener(Event.CLOSE, onClose);
			clientSocket = null;
		}

		
	}
	
}