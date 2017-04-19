#ifndef _NET_H_
#define _NET_H_

#include <iostream>
#include <mutex>
#include "ODSocket.h"

//δ��ʼ��
#define NETWORK_UNINIT 0
//����״̬
#define NETWORK_INITED 1
//��ʼ����
#define NETWORK_BEGIN_CONNECT 2
//�Ѿ�����
#define NETWORK_CONNECTED 3
//ʧȥ����
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
	 * ��������״̬
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