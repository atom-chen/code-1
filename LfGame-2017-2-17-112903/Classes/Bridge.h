/*
	收到协议，通知lua
*/
#ifndef _BRIDGE_H_
#define _BRIDGE_H_

#include <vector>
#include <map>
#include <mutex>
#include <cstdarg>
#include "cocos2d.h"
USING_NS_CC;

class Bridge
{
	static Bridge* m_Instance;
	Bridge();
	std::list< std::string > m_protoDataList;
	std::mutex m_protoMutex;
	std::mutex m_addMutex;
	void handleProtoList();
	void onReciveProto( std::string protoData );
public:
	void addRecvProtoData( std::string protoData );
	static Bridge* getInstance();
	static void destoryInstance();
	void update( float dt );
};

#endif