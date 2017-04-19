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
		//��ѭ������Э��
		//������ʱ���߳̽���ȴ����ѵ�״̬
		while ( m_protoDataList.empty() )
		{
			m_threadCond.wait( ul );
		}

		std::string protoData = m_protoDataList.front();
		int ret = m_socket->Send( protoData.c_str() , strlen( protoData.c_str() ) );
		//����ʧ�ܣ�����3��
		if ( ret == SOCKET_ERROR )
		{
			if ( m_reTry < MAX_TIMES )
			{
				m_reTry++;
				//����500����
				std::this_thread::sleep_for( std::chrono::milliseconds(500) );
			}
			else
			{
				CCLOG( "send proto fail, thread wait" );
				//����Э��ʧ�ܣ�����������߳̽���ȴ�����״̬
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
	//�������ݣ��������������ݣ��߳�Ҫ��ʼ����
	CCLOG( "send thread start work" );
	std::unique_lock< std::mutex > ul(m_threadMutex);
	m_protoDataList.push_back( protoStr );
	m_threadCond.notify_one();
}