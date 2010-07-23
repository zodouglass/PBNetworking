//
// $Id: 

// Inexplicably, OS X includes OpenTransportProviders.h somewhere, and as a
// result, we end up with TCP_NODELAY getting defined multiple times. We define
// this macro to keep OpenTransportProviders.h from being processed, which fixes
// the issue. We are not proud of this but it works; improvements welcome. -- PBL
#define __OPENTRANSPORTPROVIDERS__

# ifdef WIN32
# include <winsock2.h>

// Copied out of winsock2.h, so that we don't have to #ifdef all our error codes.
#define EWOULDBLOCK             WSAEWOULDBLOCK
#define EINPROGRESS             WSAEINPROGRESS
#define EALREADY                WSAEALREADY
#define ENOTSOCK                WSAENOTSOCK
#define EDESTADDRREQ            WSAEDESTADDRREQ
#define EMSGSIZE                WSAEMSGSIZE
#define EPROTOTYPE              WSAEPROTOTYPE
#define ENOPROTOOPT             WSAENOPROTOOPT
#define EPROTONOSUPPORT         WSAEPROTONOSUPPORT
#define ESOCKTNOSUPPORT         WSAESOCKTNOSUPPORT
#define EOPNOTSUPP              WSAEOPNOTSUPP
#define EPFNOSUPPORT            WSAEPFNOSUPPORT
#define EAFNOSUPPORT            WSAEAFNOSUPPORT
#define EADDRINUSE              WSAEADDRINUSE
#define EADDRNOTAVAIL           WSAEADDRNOTAVAIL
#define ENETDOWN                WSAENETDOWN
#define ENETUNREACH             WSAENETUNREACH
#define ENETRESET               WSAENETRESET
#define ECONNABORTED            WSAECONNABORTED
#define ECONNRESET              WSAECONNRESET
#define ENOBUFS                 WSAENOBUFS
#define EISCONN                 WSAEISCONN
#define ENOTCONN                WSAENOTCONN
#define ESHUTDOWN               WSAESHUTDOWN
#define ETOOMANYREFS            WSAETOOMANYREFS
#define ETIMEDOUT               WSAETIMEDOUT
#define ECONNREFUSED            WSAECONNREFUSED
#define ELOOP                   WSAELOOP
#define ENAMETOOLONG            WSAENAMETOOLONG
#define EHOSTDOWN               WSAEHOSTDOWN
#define EHOSTUNREACH            WSAEHOSTUNREACH
#define ENOTEMPTY               WSAENOTEMPTY
#define EPROCLIM                WSAEPROCLIM
#define EUSERS                  WSAEUSERS
#define EDQUOT                  WSAEDQUOT
#define ESTALE                  WSAESTALE
#define EREMOTE                 WSAEREMOTE

typedef int socklen_t;

# else

# define INVALID_SOCKET -1
# define SOCKET_ERROR -1
# include <sys/types.h>
# include <sys/socket.h>
# include <sys/ioctl.h>
# include <netinet/in.h>
# include <netinet/tcp.h>
# include <arpa/inet.h>
# include <fcntl.h>
# include <errno.h>
# include <unistd.h>
# include <netdb.h>
# define closesocket close
# define ioctlsocket ioctl

# endif

#include "avmshell.h"
#include "SocketGlue.h"

namespace avmshell
{		
   //
   // Socket
   //

   // Helper function so we don't have to #ifdef WIN32 everywhere.
   static int GetLastNetworkingError()
   {
#ifdef WIN32
      return WSAGetLastError();
#else
      return errno;
#endif
   }


   Socket::Socket()
   {
      // Kick off windows sockets.
#ifdef WIN32
      static bool wsaInit = false;
      if(!wsaInit)
      {
         WSADATA data;
         WSAStartup(MAKEWORD(2, 2), &data);

         // TODO: More validation, what is this, amateur hour?
      }
#endif

      m_socket_ref = INVALID_SOCKET;
   }

   Socket::~Socket()
   {
      if (m_socket_ref != INVALID_SOCKET) {
         closesocket(m_socket_ref);
         m_socket_ref = INVALID_SOCKET;
      }
   }

   bool Socket::hasConnection()
   {
      return m_socket_ref != INVALID_SOCKET;
   }


   
   /**
   * Returns -1 for error, 0 for keep trying, 1 for success.
   */
   int Socket::connect (const char *host_name, int port)
   {
      // see if we've opened up a socket yet
      if (INVALID_SOCKET == m_socket_ref) 
      {
         // if not, we may still be resolving the address
         struct hostent *resolution = gethostbyname(host_name);
         if (resolution == NULL) 
         {
            if (GetLastNetworkingError() == TRY_AGAIN) 
            {
               // tell caller to hit us again in a little while
               return 0;
            }
            return -1;
         }

         // address finished resolving
         memset(&m_host, 0, sizeof(m_host));
         m_host.sin_family = resolution->h_addrtype;
         m_host.sin_port = htons((short) port);
         memcpy(&m_host.sin_addr.s_addr, resolution->h_addr, resolution->h_length);

         // if the address bits all went well, open the socket
         m_socket_ref = socket(AF_INET, SOCK_STREAM, 0);
         if (INVALID_SOCKET == m_socket_ref) 
            return -1;

         // flag it as non-blocking
# ifdef WIN32
         u_long iMode = 1;
         ioctlsocket(m_socket_ref, FIONBIO, &iMode);
# else
         int flags = fcntl(m_socket_ref, F_GETFL, 0);
         fcntl(m_socket_ref, F_SETFL, (flags > 0 ? flags : 0) | O_NONBLOCK);
# endif

         // and fall through to connect
      }

      if (-1 == ::connect(m_socket_ref, (struct sockaddr*) &m_host, sizeof(m_host))) 
      {
         switch(GetLastNetworkingError()) 
         {
            case EALREADY: case EINPROGRESS: case EWOULDBLOCK:
               // tell caller to try us again later
               return 0;

            case EISCONN:
               // this is good!
               break;

            default:
               // anything else is a real error
               disconnect();
               return -1;
         }
      }
      // success!
      return 1;
   }

   void Socket::disconnect ()
   {
      if (INVALID_SOCKET != m_socket_ref) 
      {
         closesocket(m_socket_ref);
         m_socket_ref = INVALID_SOCKET;
      }
   }

   int Socket::read (ByteArrayFile &bytes)
   {
      if (m_socket_ref == INVALID_SOCKET) 
         return -1;
      int tot_bytes = 0;

      while (true) 
      {
         int size = recv(m_socket_ref, (char *) m_buffer, SOCK_BUF_SZ, 0);
         if (size == 0)
            // size 0 from non-blocking socket means a closed connection
            return -2;

         if (size == -1) 
         {
            if (GetLastNetworkingError() != EWOULDBLOCK) 
               return -1;

            // "try again" in non-blocking just means there was nothing to read
            size = 0;
         }

         if (size > 0) 
         {
            bytes.Push(m_buffer, size);
            tot_bytes += size;
         }

         if (size < SOCK_BUF_SZ) 
         {
            // nothing more to read
            return tot_bytes;
         }
      }
   }

   int Socket::write (ByteArrayFile &bytes)
   {
      /*if (m_socket_ref < 0) 
      {
      return -1;
      }*/

      int avail = bytes.Available();
      if (avail == 0)
         return 0;

      int ptr = bytes.GetFilePointer();
      int size = send(m_socket_ref, (char *) (bytes.GetBuffer() + ptr), avail, 0);
      if (size == -1) 
      {
         if (GetLastNetworkingError() != EWOULDBLOCK) 
         {
            // TODO: throw an error
            return -1;
         }

         // no non-blocking writes are possible
         size = 0;
      }

      if (size > 0) 
         bytes.Seek(ptr + size);

      return size;
   }

   void Socket::ThrowMemoryError()
   {
      // todo throw out of memory exception
      // m_toplevel->memoryError->throwError(kOutOfMemoryError);
   }

   bool Socket::listen( int port )
   {
      // Get a socket.
      AvmAssertMsg(m_socket_ref == INVALID_SOCKET, "NetInterface::listen - cannot listen to two ports at once.");

      m_socket_ref = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
      if(m_socket_ref == INVALID_SOCKET)
      {
         //Logger::Error("NetInterface", "listen", "Could not create listen socket.");
         return false;
      }

      // Bind it.
      struct sockaddr_in sockAddr;
      sockAddr.sin_family = AF_INET;
      sockAddr.sin_port = htons((u_short)port);
      sockAddr.sin_addr.s_addr = INADDR_ANY;
      if(bind(m_socket_ref, (struct sockaddr *)&sockAddr, sizeof(sockAddr)) == -1)
      {
         //Logger::Error("NetInterface", "listen", "Could not bind socket to port %d.", port);
         closesocket(m_socket_ref);
         m_socket_ref = INVALID_SOCKET;
         return false;
      }

      // Cool - start listening.
      if(::listen(m_socket_ref, SOMAXCONN) == SOCKET_ERROR)
      {
         //Logger::Error("NetInterface", "listen", "Could not listen.");
         closesocket(m_socket_ref);
         m_socket_ref = INVALID_SOCKET;
         return false;
      }

      // Make the listen socket non-blocking, so we can poll.
      unsigned long v = 1;
      if(ioctlsocket(m_socket_ref, FIONBIO, &v) == SOCKET_ERROR)
      {
         //Logger::Error("NetInterface", "listen", "Could not switch listen socket to non-blocking mode.");
         closesocket(m_socket_ref);
         m_socket_ref = INVALID_SOCKET;
         return false;
      }

      // Wow, if we made it here then we're set.
      return true;
   }

   SOCKET Socket::accept()
   {
      // If there is any pending connection, accept it and return a new Socket.
      sockaddr addr;
      socklen_t addrlen = sizeof(addr);
      SOCKET acceptedSocket;
      if((acceptedSocket = ::accept(m_socket_ref, &addr, &addrlen)) != INVALID_SOCKET)
      {
         // Semi-hack - accepted sockets get Nagle's algorithm disabled so they
         // have better latency characteristics. This can cause problems if we
         // aren't tightly disciplined with our network IO, so beware...
         int flag = 1;
         if(setsockopt( acceptedSocket, IPPROTO_TCP, TCP_NODELAY, (char *)&flag, sizeof(flag) ) == -1)
         {
            AvmAssertMsg(false, "Could not disable Nagle's algorithm!");
         }

         return acceptedSocket;
      }

      return INVALID_SOCKET;
   }

   //
   // SocketObject
   //

   SocketObject::SocketObject(VTable *ivtable,
      ScriptObject *delegate)
      : ScriptObject(ivtable, delegate),
      m_socket()
   {
      c.set(&m_socket, sizeof(Socket));
   }

   int SocketObject::nb_connect (Stringp host, int port)
   {
      return m_socket.connect(host->toUTF8String()->c_str(), port);
   }

   void SocketObject::nb_disconnect ()
   {
      m_socket.disconnect();
   }

   int SocketObject::nb_write (ByteArrayObject *bytes)
   {
      return m_socket.write(bytes->GetByteArrayFile());
   }

   int SocketObject::nb_read (ByteArrayObject *bytes)
   {
      return m_socket.read(bytes->GetByteArrayFile());
   }

   bool SocketObject::listen( int port )
   {
      return m_socket.listen(port);
   }

   SocketObject * SocketObject::accept()
   {
      // Do the low-level activity first.
      SOCKET acceptedSocket = m_socket.accept();
      if(acceptedSocket == INVALID_SOCKET)
         return NULL;

      // We got a live one, allocate a new SocketObject, attach it to our received socket, and return it!
      
      // Get our current domain.
      DomainClass *domainClass = (DomainClass*)toplevel()->getBuiltinExtensionClass(NativeID::abcclass_avmplus_Domain);
      DomainObject *domainObject = domainClass->get_currentDomain();
      ClassClosure *socketClass = domainObject->getClass(core()->constantString("flash.net.Socket"));

      Atom args[] = { NULL, NULL, NULL };
      Atom ctorResult = socketClass->construct(2, args);
      AvmAssertMsg(ctorResult, "Somehow failed to construct flash.net.Socket!");
      SocketObject *newSock = (SocketObject*)AvmCore::atomToScriptObject(ctorResult);
      newSock->GetSocket().setSocket(acceptedSocket);
      return newSock;
   }

   //
   // SocketClass
   //

   SocketClass::SocketClass(VTable *vtable)
      : ClassClosure(vtable)
   {
      prototype = toplevel()->objectClass->construct();
   }

   ScriptObject* SocketClass::createInstance(VTable *ivtable,
      ScriptObject *prototype)
   {
      return new (core()->GetGC(), ivtable->getExtraSize()) SocketObject(ivtable, prototype);
   }
}	


