package
{
   import com.pblabs.engine.PBE;
   import com.pblabs.engine.core.*;
   import com.pblabs.engine.debug.*;
   import com.pblabs.engine.entity.*;
   import com.pblabs.networking.core.*;
   import com.pblabs.networking.elements.*;
   import com.pblabs.networking.events.*;
   import com.pblabs.networking.ghosting.*;
   import com.pblabs.networking.server.IServerGame;
   import com.pblabs.rendering2D.ui.FlexSceneView;
   
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.StatusEvent;
   import flash.geom.Point;
   import flash.net.Socket;
   import flash.utils.*;
   
	/**
	* Implementation of server side game logic.
	* Defines the networking protocol, handles net events sent from clients, starts PBE, and loads the level
	*/ 
	public class ServerGame implements IServerGame, IScoper
	{
		/**
		* Common initialization of networking protocol + events.
		*/ 
		static public function initializeGameData():void
		{
			// Load up some network protocol XML.
			Logger.print(null, "Initializing networking protocol.");
			var eventXML:XML =
			<library>
			<event name="chat">
			   <string name="message"/>
			</event>
			<event name="circle">
			  <rangedInt name="x" min="-1000" max="1000"/>
			  <rangedInt name="y" min="-1000" max="1000"/>
			</event>
			<ghost name="CircleGhost">
			   <dirtyFlag name="flag1">
				  <rangedInt name="x" min="-1000" max="1000"/>
				  <rangedInt name="y" min="-1000" max="1000"/>
				  <flag name="state"/>
			   </dirtyFlag>
			</ghost>
			</library>;
			NetRoot.loadNetProtocol(eventXML.toXMLString());

			// Register our event.
			NetEvent.registerClass("chat", ChatEvent);
			NetEvent.registerClass("circle", CircleEvent);
		}

		/**
		* Called by the server binary when it starts up.
		*/ 
		public function onStart():void
		{
			// Load up some network protocol XML.
			initializeGameData();

			// Load resources.
			PBE.addResources(new Resources());


			LevelManager.instance.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, _onLoadComplete);
			LevelManager.instance.load("../assets/levelDescriptions.xml", 1);

			// Echo chat messages.
			ChatEvent.onChatCallback = function(ce:ChatEvent):void
			{
				Logger.print(this, "Chat: " + ce.message);

				// Echo events out to each connection.
				NetworkInterface.instance.forEachConnection(function (nc:NetworkConnection):void
				{
					if(nc is EventConnection)
						(nc as EventConnection).postEvent(new ChatEvent(ce.message));
				});
			}

			// Update circle state.
			CircleEvent.onCircleCallback = function(ce:CircleEvent):void
			{
				Logger.print(this, "Handling click!"+ ce.x + " " + ce.y);
				_lastClickTime = PBE.processManager.virtualTime;
				for each(var circle:IEntity in circles)
					circle.setProperty(new PropertyReference("@ServerMover.goalPosition"), new Point(ce.x, ce.y));
			}
		}

		/**
		* Called by the server binary when a connection comes in.
		*/ 
		public function onConnection(clientSocket:Socket):void
		{
			// Set up the connection, and add it to the list.
			var connection:GhostConnection = new GhostConnection();
			connection.activateGhosting(true);
			connection.scopeObject = this;
			connection.acceptClientConnection(clientSocket, null, 0);

			// Send a welcome message.
			connection.postEvent(new ChatEvent("Welcome to Circle Click: Multiplayer Edition!"));

			connection.sendPacket();
		}
		
		/**
		 * Called by the server when the connection is closed
		 */
		public function onDisconnect(s:Socket):void
		{
			
		}
      
		/**
		* Scope callback; set all the circles in scope.
		*/ 
		public function scopeObjects(gm:GhostManager):void
		{
			for each(var circle:IEntity in circles)
			{
				if(!circle)
					continue;
				var g:Ghost = (circle.lookupComponentByType(GhostComponent) as GhostComponent).ghostInstance;
				g.checkTrackedProperties();
				gm.markGhostInScope(g, 1.0);
			}
		}

		/**
		* Kick off game simulation once level load is done.
		*/ 
		private function _onLoadComplete(e:*):void
		{
			Logger.print(this, "Loaded level data, initializing ghosts.");

			for(var i:int=0; i < 10; i++)
			{
				var newC:IEntity = PBE.templateManager.instantiateEntity("ServerCircle");
				newC.setProperty(new PropertyReference("@ServerMover.initialPosition"), new Point(50 * i, 25));
				circles.push(newC);
			}

			Logger.print(this, "Ghosts initialized.");

			// Every 1 second, assign a new random position.
			setInterval(_MoveGhosts, 1000);
		}
      
		/**
		* Update the target position on all the circles.
		*/  
		private function _MoveGhosts():void
		{
			if(PBE.processManager.virtualTime - _lastClickTime < 2000)
				return;

		//	Logger.print(this, "Moving ghosts.");
			for each(var circle:IEntity in circles)
				circle.setProperty(new PropertyReference("@ServerMover.goalPosition"), new Point( -320 + (640 * Math.random()), -120 + 240* Math.random()));
		}
      
		private var _lastClickTime:Number = 0;
		private var circleStates:Array = new Array(10);
		private var circles:Array = new Array();
   }
}
