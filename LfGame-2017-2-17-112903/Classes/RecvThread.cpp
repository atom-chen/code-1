#include "RecvThread.h"
#include "cocos2d.h"
#include "Bridge.h"
#include "base64/base64.h"
USING_NS_CC;

static void recvThreadFunc( void* ptr )
{
	RecvThread* self = ( RecvThread* )ptr;
	self->handleRecv();
}

RecvThread::RecvThread( ODSocket* socket ):
	m_socket( socket )
{
	
}

RecvThread::~RecvThread()
{

}

void RecvThread::start()
{
	m_recvThread = std::thread( recvThreadFunc , this );
	m_recvThread.detach();
}

void RecvThread::handleRecv()
{
	while (true)
	{
		std::unique_lock< std::mutex > ul( m_threadMutex );
		int status = Net::getInstance()->getNetworkStatus();
		CCLOG( "~~~~~~~~~~~~~~%d" , status );
		//网络没连接，线程先进入等待唤醒状态
		while ( status != NETWORK_CONNECTED )
		{
			CCLOG( "not net work , Recv thread is waiting" );
			m_recvCond.wait( ul );
		}
		char buff[ MAX_MSG_LEN ] = { 0 };
		
		int result = m_socket->Recv( buff , MAX_MSG_LEN );
		if (result <= 0)
		{
			CCLOG("server connect close");
			Net::getInstance()->setNetworkStatus( NETWORK_CONNECT_LOST );
			Net::getInstance()->close();
		}
		else
		{
			buff[ result ] = '\0';
			std::string buffer = base64_decode( buff );
			Bridge::getInstance()->addRecvProtoData( buffer );
		}
	}
}

void RecvThread::wakeUp()
{
	CCLOG("wake up Recv thread");
	m_recvCond.notify_one();
}