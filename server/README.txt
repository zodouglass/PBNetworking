PushButton Networking Server v1
(c) PushButton Labs 2009

INTRODUCTION

This directory contains the ActionScript and C++ code required to build the PushButton Networking Server.

Networking your game requires that you run a server. However, Flash currently does not allow you to run a server via the Player or AIR. Luckily, the source code for key parts of Flash has been released, and we are able to build our own ActionScript runtime for servers.

GETTING STARTED - THE EASY WAY

Check the bin folder. There will be a serverMain.abc and (potentially) binary for your platform. To run a server, enter this command line:

{binaryname} serverMain.abc -- -p {port#} {YourSwfFile.swf}

For instance on Win32 you would do:

avmplus_sd.exe serverMain.abc -- -p 1337 NetworkDemo.swf

Run with no command line parameters to get usage information. Of note are the --daemon parameter which allows you to run the server in daemon mode.

Note that the SWF file you provide must contain a class ServerGame in the default package which implements IServerGame. See the IServerGame code documentation for more details. 

COMPILING - THE HARD WAY

If there is no binary available for your platform, or you modify the core server code, you will have to compile your own binary or ABC file.

See https://developer.mozilla.org/En/Tamarin/Tamarin_Build_Documentation for the official Tamarin build instructions.

To compile the binary, use the appropriate bullet point. You need to build the Debug_Debugger target in the IDEs.
   * On OSX, go to tamarin-source/tamarin-central/platform/mac and use the XCode projects.
   * On Windows, go to tamarin-source/tamarin-central/platform/win32 and use the Visual Studio projects.
   * Everywhere else, make a new directory for binaries, cd into it, run python ../configure.py --enable-shell --enable-debug --enable-debugger followed by make. The Tamarin Build documentation linked above goes into more detail. You may need to go to tamarin-source/tamarin-central/build and do chmod o+x *.py for the build to work.

Build-wise, this is a very straightforward build of Tamarin with just a few added source files.

To compile the byte code:
   * Go to tamarin-source/server and run ant.

CREDITS

PushButton Networking Server is based on:
   * RedTamarin (http://code.google.com/p/redtamarin/)
   * Thane (http://code.threerings.net/svn/whirled/).
   
Thanks to Michael Bayne (Three Rings), Steven Johnson (Adobe), and zwetan (???) for their help. Thanks to everyone on tamarin-devel for their advice as well.

At PushButton Labs, Ben Garney worked on this product.