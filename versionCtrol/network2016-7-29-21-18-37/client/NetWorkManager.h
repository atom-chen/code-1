#ifndef __NetWorkManager__h__
#define __NetWorkManager__h__

#include <iostream>
#include "ODSocket.h"
#include "cocos2d.h"
#include <thread>
USING_NS_CC;

#define IP "127.0.0.1"
#define PORT 12345
#define MSGLEN 512

class NetWorkManager
{
public:
	~NetWorkManager();
	static NetWorkManager* getInstance();

	void connectFunc();

	void sendData(std::string data);

	void recvFunc();

	void init();

private:
	static NetWorkManager* m_pInstance;
	NetWorkManager();
	bool isConnect;
	ODSocket m_socket;
	std::string m_serverIp;
	int m_serverPort;
	void initData();
};

#define NETWORKHANDLE (NetWorkManager::getInstance())

#endif