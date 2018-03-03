/*
 * define file about portable socket class. 
 * description:this sock is suit both windows and linux
 * design:odison
 * e-mail:odison@126.com>
 * 
 */

#ifndef _ODSOCKET_H_
#define _ODSOCKET_H_

#ifdef WIN32
	#include <Winsock2.h>
	typedef int				socklen_t;
	#pragma comment(lib,"ws2_32.lib")
#else
    #include "cocos2d.h"
	#include <sys/socket.h>
	#include <netinet/in.h>
	#include <netdb.h>
	#include <fcntl.h>
	#include <unistd.h>
	#include <sys/stat.h>
	#include <sys/types.h>
	#include <arpa/inet.h>
	typedef int				SOCKET;
	#define INVALID_SOCKET	-1
	#define SOCKET_ERROR	-1
#endif

#define SOCKET_INIT_SUCCESS 0
#define SOCKET_INIT_FAIL -1

#define SOCKET_CONNECT_FAIL -1
#define SOCKET_CONNECT_SUCCESS 0
#define SOCKET_CONNECT_TIMEOUT 1


class ODSocket {

public:
	ODSocket(SOCKET sock = INVALID_SOCKET);
	~ODSocket();

	// Create socket object for snd/recv data
	bool Create(int af, int type, int protocol = 0);

	// Connect socket
	bool Connect(const char* ip, unsigned short port);
	//#region server
	// Bind socket
	bool Bind(unsigned short port);

	// Listen socket
	bool Listen(int backlog = 5); 

	// Accept socket
	bool Accept(ODSocket& s, char* fromip = NULL);
	//#endregion
	
	// Send socket
	int Send(const char* buf, int len, int flags = 0);

	// Recv socket
	int Recv(char* buf, int len, int flags = 0);
	
	// Close socket
	int Close();

	// Get errno
	int GetError();
	
	//#pragma region just for win32
	// Init winsock DLL 
	static int Init();	
	// Clean winsock DLL
	static int Clean();
	//#pragma endregion

	// Domain parse
	static bool DnsParse(const char* domain, char* ip);

	ODSocket& operator = (SOCKET s);

	operator SOCKET ();

	SOCKET getSocket() const
	{
		return m_sock;
	}

protected:
	SOCKET m_sock;

};

#endif
