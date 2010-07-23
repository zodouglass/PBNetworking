//
// $Id: $

#ifndef SOCKETGLUE_INCLUDED
#define SOCKETGLUE_INCLUDED

#include "ByteArrayGlue.h"

namespace avmshell
{

# ifdef WIN32
# include <winsock2.h>
# else
# include <netinet/in.h>
# include <netinet/tcp.h>
# include <sys/socket.h>
# define SOCKET int
# endif

# define SOCK_BUF_SZ 0x1000

   class Socket
   {
   public:
      Socket();
      ~Socket();

      int connect (const char *host_name, int port);
      void disconnect ();
      int read (ByteArrayFile &bytes);
      int write (ByteArrayFile &bytes);

      bool listen(int port);
      SOCKET accept();
      bool hasConnection();

      void setSocket(SOCKET s)
      {
         m_socket_ref = s;
      }

   protected:
      SOCKET m_socket_ref;

      U8 m_buffer[SOCK_BUF_SZ];
      sockaddr_in m_host;
      void ThrowMemoryError();
   };

   class SocketObject : public ScriptObject
   {
   public:
      SocketObject(VTable *ivtable, ScriptObject *delegate);

      int nb_connect (Stringp host, int port);
      void nb_disconnect ();
      int nb_read (ByteArrayObject *bytes);
      int nb_write (ByteArrayObject *bytes);

      bool hasConnection()
      {
         return m_socket.hasConnection();
      }

      bool listen(int port);
      SocketObject *accept();

      Socket& GetSocket() { return m_socket; }

   private:
      MMgc::Cleaner c;
      Socket m_socket;
   };

   //
   // SocketClass
   //

   class SocketClass : public ClassClosure
   {
   public:
      SocketClass(VTable *vtable);

      ScriptObject *createInstance(VTable *ivtable, ScriptObject *delegate);

      DECLARE_NATIVE_MAP(SocketClass)
   };
}

#endif /* SOCKETGLUE_INCLUDED */
