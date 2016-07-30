#include <winsock2.h>     
#include <stdio.h>   
#include <list>

#define PORT  12345     

#define MSGSIZE  1024     

#pragma comment(lib, "ws2_32.lib")     

int g_iTotalConn1 = 0;


/*
	一个简单的服务端，整个服务端只有1个子线程。因为里面加入了select来获取活跃的客户端，所以不需要每一个客户端都开1个线程
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
		printf("new client connect success，port is：%d，now have %d client is connecting\n", ntohs(client.sin_port), g_iTotalConn1);
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
		FD_ZERO(&fdread);   //1清空队列  
		for (std::list<SOCKET>::iterator cit = allClient.begin(); cit != allClient.end(); ++cit)
		{
			//把连接的所有客户端放进去
			FD_SET(*cit, &fdread);
		}

	/*	for (std::list<customClient>::iterator cit = connectClient.begin(); cit != connectClient.end(); ++cit)
		{
			FD_SET(cit->_client, &fdread);
		}*/


		// We only care read event     
		//select最后一个参数重要~~~传NULL进去，就会变成一个阻塞的函数
		// select(0, &fdread, NULL, NULL, 0);  也是阻塞函数
		//select(0, &fdread, NULL, NULL, &tv);   在tv时间内阻塞，超时就返回0
		//查找活跃连接
		ret = select(0, &fdread, NULL, NULL, &tv);   //3查询满足要求的套接字，不满足要求，出队  
		if (ret == 0)
		{
			//超时返回0或者无活跃用户
			continue;
		}
		char szMessage[MSGSIZE];
		for (int i = 0; i < fdread.fd_count; i++)
		{
			//判断是不是在集合中
			if (FD_ISSET(fdread.fd_array[i], &fdread))
			{
				//接受客户端消息
				result = recv(fdread.fd_array[i], szMessage, MSGSIZE, 0);
				//返回0或者一些错误code断开连接  在list中删除client
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
					//给所有客户端发消息
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