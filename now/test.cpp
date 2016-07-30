#include <winsock2.h>     
#include <stdio.h>   
#include <list>

#define PORT  12345     

#define MSGSIZE  1024     

#pragma comment(lib, "ws2_32.lib")     

int g_iTotalConn1 = 0;


/*
	һ���򵥵ķ���ˣ����������ֻ��1�����̡߳���Ϊ���������select����ȡ��Ծ�Ŀͻ��ˣ����Բ���Ҫÿһ���ͻ��˶���1���߳�
*/

struct customClient
{
	SOCKET _client;
	bool isAlive = true;
};

std::list<SOCKET>allClient;

DWORD WINAPI WorkerThread(LPVOID lpParam);
int CALLBACK ConditionFunc(LPWSABUF lpCallerId, LPWSABUF lpCallerData, LPQOS lpSQOS, LPQOS lpGQOS, LPWSABUF lpCalleeId, LPWSABUF lpCalleeData, GROUP FAR * g, DWORD dwCallbackData);

int main(int argc, char* argv[])
{
	allClient.clear();
	WSADATA wsaData;
	SOCKET sListen, sClient;
	SOCKADDR_IN local, client;
	int iAddrSize = sizeof(SOCKADDR_IN);
	DWORD dwThreadId;
	// Initialize windows socket library     
	WSAStartup(0x0202, &wsaData);
	// Create listening socket     
	sListen = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	// Bind     

	local.sin_family = AF_INET;
	local.sin_addr.S_un.S_addr = htonl(INADDR_ANY);
	local.sin_port = htons(PORT);
	bind(sListen, (sockaddr*)&local, sizeof(SOCKADDR_IN));

	// Listen     

	listen(sListen, 5);

	// Create worker thread     

	CreateThread(NULL, 0, WorkerThread, NULL, 0, &dwThreadId);
	printf("waiting for client connect...\n");
	while (TRUE)
	{
		sClient = WSAAccept(sListen, (sockaddr*)&client, &iAddrSize, ConditionFunc, 0);
		if (sClient == INVALID_SOCKET)
			continue;
		g_iTotalConn1++;
		allClient.push_back(sClient);
		printf("new client connect success��port is��%d��now have %d client is connecting\n", ntohs(client.sin_port), g_iTotalConn1);
	}
	return 0;
}

DWORD WINAPI WorkerThread(LPVOID lpParam)
{
	int i;
	fd_set fdread;
	int ret;
	int result = 0;
	struct timeval tv = { 1, 0 };
	
	while (TRUE)
	{
		FD_ZERO(&fdread);   //1��ն���  
		for (std::list<SOCKET>::iterator cit = allClient.begin(); cit != allClient.end(); ++cit)
		{
			//�����ӵ����пͻ��˷Ž�ȥ
			FD_SET(*cit, &fdread);
		}

	/*	for (std::list<customClient>::iterator cit = connectClient.begin(); cit != connectClient.end(); ++cit)
		{
			FD_SET(cit->_client, &fdread);
		}*/


		// We only care read event     
		//select���һ��������Ҫ~~~��NULL��ȥ���ͻ���һ�������ĺ���
		// select(0, &fdread, NULL, NULL, 0);  Ҳ����������
		//select(0, &fdread, NULL, NULL, &tv);   ��tvʱ������������ʱ�ͷ���0
		//���һ�Ծ����
		ret = select(0, &fdread, NULL, NULL, &tv);   //3��ѯ����Ҫ����׽��֣�������Ҫ�󣬳���  
		if (ret == 0)
		{
			//��ʱ����0�����޻�Ծ�û�
			continue;
		}
		char szMessage[MSGSIZE];
		for (int i = 0; i < fdread.fd_count; i++)
		{
			//�ж��ǲ����ڼ�����
			if (FD_ISSET(fdread.fd_array[i], &fdread))
			{
				//���ܿͻ�����Ϣ
				result = recv(fdread.fd_array[i], szMessage, MSGSIZE, 0);
				//����0����һЩ����code�Ͽ�����  ��list��ɾ��client
				if (result == 0 || (result == SOCKET_ERROR && WSAGetLastError() == WSAECONNRESET))
				{
					printf("client socket %d closed.\n", fdread.fd_array[i]);
					std::list<SOCKET>::iterator it = find(allClient.begin(), allClient.end(), fdread.fd_array[i]);
					if (it != allClient.end())
					{
						allClient.erase(it);
					}
					closesocket(fdread.fd_array[i]);
					FD_CLR(fdread.fd_array[i], &fdread);
					g_iTotalConn1--;
				}
				else
				{
					//�����пͻ��˷���Ϣ
					szMessage[result] = '\0';
					for (std::list<SOCKET>::iterator it = allClient.begin(); it != allClient.end(); ++it)
					{
						send(*it, szMessage, strlen(szMessage), 0);
					}
				}
			}
		}
	}
}

int CALLBACK ConditionFunc(LPWSABUF lpCallerId, LPWSABUF lpCallerData, LPQOS lpSQOS, LPQOS lpGQOS, LPWSABUF lpCalleeId, LPWSABUF lpCalleeData, GROUP FAR * g, DWORD dwCallbackData)
{
	if (g_iTotalConn1 < FD_SETSIZE)
		return CF_ACCEPT;
	else
		return CF_REJECT;
}

void killClient()
{

}