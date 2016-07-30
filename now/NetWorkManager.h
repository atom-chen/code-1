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

class HelperNode;

class NetWorkManager
{
public:
	~NetWorkManager();
	static NetWorkManager* getInstance();

	void connectFunc();

	void sendData(std::string data);

	void recvFunc();

	void init();

	void reConnect();

	void setHelper(HelperNode* node);

	void sendMessage(Ref* pSender);

private:
	static NetWorkManager* m_pInstance;
	NetWorkManager();
	bool isConnect;
	ODSocket m_socket;
	std::string m_serverIp;
	int m_serverPort;
	void initData();
	int m_connectCount;
	HelperNode* m_helperNode;

private:
	class CCGarbo // 它的唯一工作就是在析构函数中删除CSingleton的实例 
	{
	public:
		~CCGarbo()
		{
			if (NetWorkManager::m_pInstance)
				delete NetWorkManager::m_pInstance;
			m_pInstance = NULL;
		}
	};
	static CCGarbo m_Garbo;
};

#define NETWORKHANDLE (NetWorkManager::getInstance())

#endif