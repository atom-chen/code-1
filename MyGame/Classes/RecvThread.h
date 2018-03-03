#ifndef _RECV_THREAD_H_
#define _RECV_THREAD_H_

#include <thread>
#include <mutex>
#include <condition_variable>
#include "ODSocket.h"
#include <iostream>
#include "Net.h"
using namespace std;

#define MAX_DATA_LENGHT 1024

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

	int m_recvPos;

	int m_recvSize;

	char m_recvBuff[MAX_DATA_LENGHT];

	void analysisData();
};

#endif