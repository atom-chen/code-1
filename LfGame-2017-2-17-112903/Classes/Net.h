#ifndef _NET_H_
#define _NET_H_

#include <iostream>
#include <mutex>
#include "ODSocket.h"

//未初始化
#define NETWORK_UNINIT 0
//开启状态
#define NETWORK_INITED 1
//开始连接
#define NETWORK_BEGIN_CONNECT 2
//已经连接
#define NETWORK_CONNECTED 3
//失去连接
#define NETWORK_CONNECT_LOST 4

#define MAX_MSG_LEN 1024

class SendThread;
class ConnectThread;
class RecvThread;

class Net
{
	static Net* m_pNet;

	Net();

	ODSocket* m_socket;

	SendThread* m_pSend;

	ConnectThread* m_pConnect;

	RecvThread* m_pRecv;

	int m_status;

	bool m_NetWorkIsInit;

	std::mutex m_wakeMutex;

public:

	~Net();

	static Net* getInstance();

	static void destoryIntancs();

	bool initNetWork( std::string server_ip = "127.0.0.1" , int server_port = 12345 );

	void close();

	void sendProto( std::string protoData );

	/**
	 * 设置网络状态
	 */
	void setNetworkStatus(int status);

	inline int getNetworkStatus()
	{
		return m_status;
	}

	void startConnect();

	void wakeUpRecv();
};

#endif