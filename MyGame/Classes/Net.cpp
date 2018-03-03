#include "cocos2d.h"
#include "SendThread.h"
#include "RecvThread.h"
#include "ConnectThread.h"
#include "Net.h"
#include "Bridge.h"
#include "base64/base64.h"
USING_NS_CC;

Net* Net::m_pNet = nullptr;

Net::Net():
	m_socket( nullptr ),
	m_pSend( nullptr ),
	m_pConnect( nullptr ),
	m_status( NETWORK_UNINIT ),
	m_NetWorkIsInit( false ),
	m_pRecv( nullptr )
{

}

Net::~Net()
{
	if ( m_pSend )
	{
		delete m_pSend;
		m_pSend = nullptr;
	}

	if ( m_socket )
	{
		delete m_socket;
		m_socket = nullptr;
	}

	if ( m_pConnect )
	{
		delete m_pConnect;
		m_pConnect = nullptr;
	}

	if ( m_pRecv )
	{
		delete m_pRecv;
		m_pRecv = nullptr;
	}
}

void Net::destoryIntancs()
{
	if ( m_pNet )
	{
		delete m_pNet;
		m_pNet = nullptr;
	}
}

Net* Net::getInstance()
{
	if ( !m_pNet )
	{
		m_pNet = new Net;
	}
	return m_pNet;
}

bool Net::initNetWork( std::string server_ip /* = "127.0.0.1"  */, int server_port /* = 12345 */ )
{
	if ( m_NetWorkIsInit )
	{
		return true;
	}

	Director::getInstance()->getScheduler()->scheduleUpdate( Bridge::getInstance() , 1 , false );

	m_socket = new ODSocket;

	CCLOG("start init socket");
	int result = m_socket->Init();
#if ( CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 ) 
	if ( result == SOCKET_INIT_FAIL )
		return false;
#endif
	CCLOG("[network] init network success");

	setNetworkStatus(NETWORK_INITED);

	m_NetWorkIsInit = true;

	m_pSend = new SendThread( m_socket );
	m_pSend->start();

	m_pConnect = new ConnectThread( m_socket , server_ip , server_port );
	startConnect();

	return true;
}

void Net::startConnect()
{
	if ( !m_NetWorkIsInit )
	{
		return;
	}

	if ( m_status == NETWORK_CONNECTED || m_status == NETWORK_BEGIN_CONNECT ) 
		return;

	setNetworkStatus(NETWORK_BEGIN_CONNECT);

	m_socket->Create( AF_INET, SOCK_STREAM );
	CCLOG( "client start connect" );
	m_pConnect->start();
}

void Net::setNetworkStatus( int status )
{
	m_status = status;
}

void Net::close()
{
	m_NetWorkIsInit = false;
	//m_socket->Clean();
	m_socket->Close();
}

void Net::sendProto( std::string protoData , int protoId )
{
	CCLOG( "status == %d" , m_status );
	if (m_status != NETWORK_CONNECTED)
		return;
	//std::string encodeStr = base64_encode(reinterpret_cast<const unsigned char*>(protoData.c_str()) , strlen(protoData.c_str()));
	//m_pSend->addProto(encodeStr);
	m_pSend->addProto(protoData , protoId);
}

void Net::wakeUpRecv()
{
	m_wakeMutex.lock();
	//连上了服务器再开始接收数据的线程
	if (nullptr != m_pRecv)
	{
		m_pRecv->wakeUp();
	}
	else
	{
		m_pRecv = new RecvThread( m_socket );
		m_pRecv->start();
	}
	m_wakeMutex.unlock();
}

void Net::reConnect()
{
	setNetworkStatus(NETWORK_INITED);
	int result = m_socket->Init();
	
#ifdef WIN32
	if ( result == SOCKET_INIT_FAIL )
		CCLOG( "socket init fail" );
		return;
#endif
	CCLOG( "reconnect" );
	m_NetWorkIsInit = true;
	this->startConnect();
}