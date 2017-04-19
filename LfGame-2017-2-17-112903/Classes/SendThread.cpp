#include "SendThread.h"
#include "cocos2d.h"
USING_NS_CC;

static void sendThreadFunc( void* ptr )
{
	SendThread* send = ( SendThread* )ptr;
	send->handleSend();
}

SendThread::SendThread( ODSocket* socket ):
	m_socket( socket ),
	m_protoDataList( 0 ),
	m_reTry( 0 )
{

}

SendThread::~SendThread( void )
{

}

void SendThread::start()
{
	m_thread = std::thread( sendThreadFunc , this );
	m_thread.detach();
}

void SendThread::handleSend()
{
	const static int MAX_TIMES = 3;
	while ( true )
	{
		std::unique_lock<std::mutex> ul( m_threadMutex );
		//死循环发送协议
		//容器空时候，线程进入等待唤醒的状态
		while ( m_protoDataList.empty() )
		{
			m_threadCond.wait( ul );
		}

		std::string protoData = m_protoDataList.front();
		int ret = m_socket->Send( protoData.c_str() , strlen( protoData.c_str() ) );
		//发送失败，重试3次
		if ( ret == SOCKET_ERROR )
		{
			if ( m_reTry < MAX_TIMES )
			{
				m_reTry++;
				//休眠500毫秒
				std::this_thread::sleep_for( std::chrono::milliseconds(500) );
			}
			else
			{
				CCLOG( "send proto fail, thread wait" );
				//发送协议失败，清空容器，线程进入等待唤醒状态
				m_reTry = 0;
				m_protoDataList.clear();
				m_threadCond.wait( ul );
			}
		}
		else
		{
			CCLOG( "send to server data is %s" , protoData.c_str() );
			m_reTry = 0;
			m_protoDataList.erase( m_protoDataList.begin() );
		}
	}
}

void SendThread::addProto( std::string protoStr )
{
	//插入数据，容器绝对有内容，线程要开始工作
	CCLOG( "send thread start work" );
	std::unique_lock< std::mutex > ul(m_threadMutex);
	m_protoDataList.push_back( protoStr );
	m_threadCond.notify_one();
}