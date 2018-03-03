#include "RecvThread.h"
#include "cocos2d.h"
#include "Bridge.h"
#include "base64/base64.h"
#include "packet.h"
USING_NS_CC;

static void recvThreadFunc( void* ptr )
{
	RecvThread* self = ( RecvThread* )ptr;
	self->handleRecv();
}

RecvThread::RecvThread( ODSocket* socket ):
	m_socket( socket ),
	m_recvSize( 0 ),
	m_recvPos( 0 )
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
		char buff[ MAX_MSG_LEN ];
		
		int result = m_socket->Recv( buff , MAX_MSG_LEN );
		if (result <= 0)
		{
			CCLOG("server connect close");
			// 这里要有断线重连的机制
			Net::getInstance()->setNetworkStatus( NETWORK_CONNECT_LOST );
			Net::getInstance()->close();
			Bridge::getInstance()->addLuaEvent( RECONNECT );
		}
		else if ( ( m_recvSize + result ) >= MAX_DATA_LENGHT )
		{
			CCLOG( "Buffer Overflow Error!" );
		}
		else
		{
			m_recvPos = 0;
			while (result > 0)
			{
				char addBuff[MAX_DATA_LENGHT] = {0};
				strncpy(addBuff,buff,result-m_recvSize);
			}
			////上次的数据包刚刚好
			//if ( m_recvSize == 0 )
			//{
			//	memset( m_recvBuff , 0 , sizeof( m_recvBuff ) );
			//	int m_recvSize = GetWord(buff , m_recvPos);
			//	if (m_recvSize == result)
			//	{
			//		int tag = GetWord( buff , m_recvPos );
			//		char msg[ MAX_DATA_LENGHT ] = {0};
			//		GetString(buff , msg , m_recvPos);
			//		Bridge::getInstance()->addRecvProtoData( tag , msg );
			//		m_recvSize = 0;
			//	}
			//	//包太小
			//	else if (m_recvSize > result)
			//	{
			//		memmove(m_recvBuff, buff, result);
			//		m_recvSize = result - m_recvSize;
			//	}
			//	//包太大
			//	else
			//	{
			//		int tag = GetWord( buff , m_recvPos );
			//		char msg[ MAX_DATA_LENGHT ] = {0};
			//		GetString(buff , msg , m_recvPos);
			//		Bridge::getInstance()->addRecvProtoData( tag , msg );
			//		int offset = result - m_recvSize;
			//		memmove(m_recvBuff, buff+offset, result);
			//		m_recvSize = result - m_recvSize;
			//	}
			//}
			//else if (m_recvSize < 0)
			//{
			//	int addOffset = abs(m_recvSize);
			//	char addBuff[MAX_DATA_LENGHT] = {0};
			//	if (result == addOffset)
			//	{
			//		strncpy(addBuff,buff,result);
			//		char newBuff[MAX_DATA_LENGHT] = {0};
			//		sprintf( newBuff,"%s%s",m_recvBuff,newBuff );
			//		m_recvPos = 2;
			//		int tag = GetWord(newBuff,m_recvPos);
			//		char msg[MAX_DATA_LENGHT] = {0};
			//		GetString( newBuff , msg , m_recvPos );
			//		Bridge::getInstance()->addRecvProtoData(tag,msg);
			//		m_recvSize = 0;
			//	}
			//	else if ( result > addOffset )
			//	{
			//		strncpy(addBuff,buff,result);

			//	}
			//}
			//else
			//{
			//	if ( m_recvSize > 1 )
			//	{

			//	}
			//	else
			//	{

			//	}
			//}



			/*	buff[ result ] = '\0';
			std::string buffer = base64_decode( buff );
			Bridge::getInstance()->onReciveProto( buff );*/
		/*	memcpy(&m_recvBuff[ m_recvSize ], buff, result);
			m_recvSize += result;
			int msgSize;
			int tag;*/

			//while (m_recvSize > 0)
			//{
			//	m_recvPos = 0;

			//	msgSize = GetWord(m_recvBuff, m_recvPos);
			//	tag = static_cast<int>(GetWord(m_recvBuff, m_recvPos));
			//	CCLOG( "proto id is %d" , tag );
			//	//当目前m_recvBuff内数据长度小于数据包总长度时
			//	if (m_recvSize < msgSize) return;
			//	
			//	//数据包处理
			//	switch ( tag )
			//	{
			//	case -1:
			//		char msg[ 1024 ];
			//		GetString(m_recvBuff, msg, m_recvPos);
			//		Bridge::getInstance()->addRecvProtoData( msg );
			//	default:
			//		break;
			//	}
			//	memmove(&m_recvBuff[0], &m_recvBuff[msgSize], m_recvSize - msgSize);
			//	m_recvSize -= msgSize;
			//}
		}
	}
}

void RecvThread::analysisData()
{

}

void RecvThread::wakeUp()
{
	CCLOG("wake up Recv thread");
	m_recvCond.notify_one();
}