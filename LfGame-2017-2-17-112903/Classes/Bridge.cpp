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
}

void Bridge::handleProtoList()
{
	m_protoMutex.lock();

	if ( !m_protoDataList.empty() )
	{
		int numHandle = 0;
		while( numHandle < 5 )
		{
			std::string data = m_protoDataList.front();
			m_protoDataList.pop_front();
			CCLOG("~~~~%s", data.c_str());
			onReciveProto( data );
			++numHandle;
			if( m_protoDataList.empty() )
				break;
		}
	}

	m_protoMutex.unlock();
}

void Bridge::addRecvProtoData( std::string protoData )
{
	m_addMutex.lock();
	m_protoDataList.push_back( protoData );
	m_addMutex.unlock();
}

void Bridge::onReciveProto( std::string protoData )
{
	auto pL = LuaEngine::getInstance()->getLuaStack()->getLuaState();
	auto path = FileUtils::getInstance()->fullPathForFilename("NetWorkManager.lua");
	luaL_dofile(pL, path.c_str());
	lua_getglobal(pL, "onRecive");
	lua_pushstring(pL, protoData.c_str());
	lua_call(pL, 1, 0);
}