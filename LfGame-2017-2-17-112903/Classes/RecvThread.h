#ifndef _RECV_THREAD_H_
#define _RECV_THREAD_H_

#include <thread>
#include <mutex>
#include <condition_variable>
#include "ODSocket.h"
#include <iostream>
#include "Net.h"
using namespace std;

class RecvThread
{
public:
	RecvThread( ODSocket* socket );
	~RecvThread( void );

	void start();

	void handleRecv();

	void wakeUp();
private:
	std::mutex m_threadMutex;

	std::thread m_recvThread;

	ODSocket* m_socket;

	std::condition_variable m_recvCond;
};

#endif