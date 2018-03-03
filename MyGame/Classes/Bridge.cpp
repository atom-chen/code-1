#include "Bridge.h"
#include "CCLuaEngine.h"

Bridge* Bridge::m_Instance = nullptr;

Bridge::Bridge()
{

}

Bridge* Bridge::getInstance()
{
	if ( m_Instance == nullptr )
		m_Instance = new Bridge;
	return m_Instance;
}

void Bridge::destoryInstance()
{
	if ( m_Instance )
	{
		delete m_Instance;
		m_Instance = nullptr;
	}
}

void Bridge::update( float dt )
{
	handleProtoList();
	handleLuaEventList();
}

void Bridge::handleProtoList()
{
	m_protoMutex.lock();

	if ( !m_protoDataList.empty() )
	{
		int numHandle = 0;
		while( numHandle < 5 )
		{
			_ProtoData data = m_protoDataList.front();
			m_protoDataList.pop_front();
			onReciveProto( data.tag , data.body );
			++numHandle;
			if( m_protoDataList.empty() )
				break;
		}
	}

	m_protoMutex.unlock();
}

void Bridge::handleLuaEventList()
{
	m_eventMutex.lock();
	if ( !m_luaEventList.empty() )
	{
		while ( true )
		{
			std::string eventName = m_luaEventList.front();
			m_luaEventList.pop_front();
			onLuaEvent( eventName );
			if ( m_luaEventList.empty() )
				break;
		}
	}
	m_eventMutex.unlock();
}

void Bridge::addRecvProtoData( int tag , std::string protoData )
{
	m_addMutex.lock();
	_ProtoData pt;
	pt.tag = tag;
	pt.body = protoData;
	m_protoDataList.push_back( pt );
	m_addMutex.unlock();
}

void Bridge::addLuaEvent( std::string lua_event )
{
	m_luaeventMutex.lock();
	m_luaEventList.push_back( lua_event );
	m_luaeventMutex.unlock();
}

void Bridge::onReciveProto( int tag, std::string protoData )
{
	auto pL = LuaEngine::getInstance()->getLuaStack()->getLuaState();
	auto path = FileUtils::getInstance()->fullPathForFilename("NetWorkManager.lua");
	luaL_dofile(pL, path.c_str());
	lua_getglobal(pL, "onRecive");
	lua_pushinteger(pL , tag);
	lua_pushstring(pL, protoData.c_str());
	lua_call(pL, 2, 0);
}

void Bridge::onLuaEvent( std::string eventName )
{
	auto pL = LuaEngine::getInstance()->getLuaStack()->getLuaState();
	auto path = FileUtils::getInstance()->fullPathForFilename("NetWorkManager.lua");
	luaL_dofile(pL, path.c_str());
	lua_getglobal(pL, "onLuaEvent");
	lua_pushstring(pL, eventName.c_str());
	lua_call(pL, 1, 0);
}