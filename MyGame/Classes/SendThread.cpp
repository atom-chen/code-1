#include "SendThread.h"
#include "cocos2d.h"
#include "packet.h"
#include "Net.h"
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

		sendData protoData = m_protoDataList.front();

		int packetPos;
		char packet[ MAX_MSG_LEN ];

		packetPos = 2;
		PutWord( packet , protoData.id , packetPos );
		PutString( packet, (char*)protoData.body.c_str(), packetPos );
		PutSize(packet,packetPos);
		CCLOG( "proto len is %d" , packetPos );
		int ret = m_socket->Send( packet , packetPos );
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
			CCLOG( "send to server data is %s" , protoData.body.c_str() );
			m_reTry = 0;
			m_protoDataList.erase( m_protoDataList.begin() );
		}
	}
}

void SendThread::addProto( std::string protoStr , int protoId )
{
	//插入数据，容器绝对有内容，线程要开始工作
	CCLOG( "send thread start" );
	std::unique_lock< std::mutex > ul(m_threadMutex);
	sendData dt;
	dt.body = protoStr;
	dt.id = protoId;
	m_protoDataList.push_back( dt );
	m_threadCond.notify_one();
}