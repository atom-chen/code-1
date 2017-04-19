#ifndef _SEND_THREAD_H_
#define _SEND_THREAD_H_

#include <thread>
#include <mutex>
#include <condition_variable>
#include <chrono>
#include <list>
#include <iostream>
#include "ODSocket.h"

class SendThread
{
public:
	SendThread( ODSocket* socket );
	~SendThread( void );

	void start();
	
	void stop();

	void addProto( std::string protoStr );

	void handleSend();

private:

	std::mutex m_threadMutex;

	std::condition_variable m_threadCond;

	std::thread m_thread;

	ODSocket* m_socket;

	std::list< std::string > m_protoDataList;

	int m_reTry;
};

#endif