#ifndef _SEND_THREAD_H_
#define _SEND_THREAD_H_

#include <thread>
#include <mutex>
#include <condition_variable>
#include <chrono>
#include <list>
#include <iostream>
#include "ODSocket.h"

struct sendData
{
	std::string body;
	int id;
};

class SendThread
{
public:
	SendThread( ODSocket* socket );
	~SendThread( void );

	void start();
	
	void stop();

	void addProto( std::string protoStr , int protoId );

	void handleSend();

private:

	std::mutex m_threadMutex;

	std::condition_variable m_threadCond;

	std::thread m_thread;

	ODSocket* m_socket;

	std::list< sendData > m_protoDataList;

	int m_reTry;
};

#endif