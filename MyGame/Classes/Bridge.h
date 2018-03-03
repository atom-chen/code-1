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

struct _ProtoData
{
	int tag;
	std::string body;
};

class Bridge
{
	static Bridge* m_Instance;
	Bridge();
	std::list< _ProtoData > m_protoDataList;
	std::list< std::string > m_luaEventList;
	std::mutex m_protoMutex;
	std::mutex m_addMutex;
	std::mutex m_luaeventMutex;
	std::mutex m_eventMutex;
	void handleProtoList();
	void onReciveProto( int tag , std::string protoData );
	void handleLuaEventList();
	void onLuaEvent( std::string eventName );
public:
	void addRecvProtoData( int tag , std::string protoData );
	static Bridge* getInstance();
	static void destoryInstance();
	void update( float dt );
	void addLuaEvent( std::string lua_event );
};

#endif