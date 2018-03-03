#include "ConnectThread.h"
#include "cocos2d.h"
#include "Net.h"
#include "Bridge.h"
USING_NS_CC;

static void ConnectThreadFunc( void* ptr )
{
	ConnectThread* self = ( ConnectThread* )ptr;
	self->handleConnect();
}

ConnectThread::ConnectThread( ODSocket* socket , std::string server_ip /* = IP  */, int server_port /* = PORT */ ):
	m_socket( socket ),
	m_ip( server_ip ),
	m_port( server_port )
{
}

ConnectThread::~ConnectThread()
{

}

void ConnectThread::start()
{
	m_thread = std::thread( &ConnectThread::handleConnect , this );
	m_thread.detach();
}

//这个函数执行完，线程就自动销毁了
void ConnectThread::handleConnect()
{
	bool ret = m_socket->Connect( m_ip.c_str() , m_port );
	if ( !ret )
	{
		CCLOG( "connect server fail %d" , m_socket->GetError() );
		Bridge::getInstance()->addLuaEvent( RECONNECT );
	}
	else
	{
		CCLOG( "connect server success" );
		Net::getInstance()->setNetworkStatus( NETWORK_CONNECTED );
		Net::getInstance()->wakeUpRecv();
	}
}
void ConnectThread::reConnect()
{
}