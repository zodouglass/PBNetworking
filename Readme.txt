PushButton Networking
Version 1.0
www.pushbuttonengine.com

(c) PushButtonLabs, LLC 2009
www.pushbuttonlabs.com

OVERVIEW

PushButton Networking integrates with the open source PushButton Engine to 
provide powerful networking capabilities for Flash games.

It provides an efficient networking library, components to easily integrate with
your game, and a server uses the Tamarin ActionScript runtime so you can run
identical game code on client and server. 

FEATURES
   * Write high performance networked Flash games fast!
   * Run the same ActionScript 3 game code on server and client. 
   * Encodes messages with bit-level efficiency.
   * Communicate with events.
   * Keep simulated objects synchronized with most-recent state updates.
   * Define your networking protocol using simple XML.
   * Brings the best practices of AAA C++ game networking to ActionScript 3.

GETTING STARTED

Drag the PBNetworking, PBNetworkingDemo, and PBNetworkingTests folders into the
Project folder of a copy of the PushButton Engine. You can get the Pushbutton
Engine at http://pushbuttonengine.com/download/.

Run the Engine Manager as described in the PushButton Engine docs to regenerate 
your Ant/Eclipse project files. Now you can compile and run the networking library, 
demo, and unit test suite.

If you are using Flash CS4, FlashDevelop, or another similar IDE, you can grab
the PBNetworking SWC from the Libraries/ folder and use it directly along with
the SWCs that ship with the PushButton Engine.

WHAT IS WHERE?

The Libraries/ folder contains PBNetworking.swc, a precompiled version of the 
networking library.

The PBNetworking/ folder contains the core PushButton Networking library code 
(in Source/), as well as documentation (in Documentation/) and the server 
binaries and source code (in Server/).

The PBNetworkingDemo/ folder has an example game demonstrating PBNetworking. You
can compile it, then use the same SWF with the server binary and as a client. If
you run it from your local disk, the networking demo will fail with a security
exception. Either mark the folder you are running it from as trusted (Flex Builder
and other IDEs do this automatically) or put it on a web server which is also
running the server binary.

The PBNetworkingTests/ folder has a simple application which runs all the unit
tests that come with the networking library.

SUPPORT

Contact us on our forums for support.

http://pushbuttonengine.com/forum/

CREDITS

PushButton Labs is:
   Timothy Aste
   Ben Garney
   Rick Overman
   Sean Sullivan
   Jeff Tunnell
