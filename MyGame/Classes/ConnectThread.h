#ifndef _CONNECT_THREAD_H_
#define _CONNECT_THREAD_H_

#include <thread>
#include <mutex>
#include <iostream>
#include "ODSocket.h"
#include <condition_variable>

#define IP "127.0.0.1"
#define PORT 12345

class ConnectThread
{
public:
	ConnectThread( ODSocket* socket , std::string server_ip = IP , int server_port = PORT );
	~ConnectThread( void );

	void start();

	void handleConnect();
	void reConnect();
private:
	ODSocket* m_socket;
	std::thread m_thread;
	std::string m_ip;
	int m_port;
	std::mutex m_threadMutex;

	std::condition_variable m_threadCond;
};

#endif