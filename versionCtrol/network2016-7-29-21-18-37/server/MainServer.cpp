//TCP֮����˳��� 

#include <stdio.h> 
#include <WinSock2.h>
#include <WS2tcpip.h> 
#include <Windows.h>


#include <stdlib.h> 
#include <list>
#include <algorithm>
#include <iostream>
#pragma comment(lib,"ws2_32.lib")
#define DEFAULT_PORT 12345 //Ĭ�϶˿� 
#define DEFAULT_BUFFER 4095 //Ĭ�ϻ�������С 
//#define SERVERIP "127.0.0.1"
#define SERVERIP "192.168.10.113"

int iPort = DEFAULT_PORT; //�˿����� 
BOOL bInterface = TRUE;   //�Ƿ��������м���� 
BOOL bRecvOnly = FALSE;   //����״̬ 
char szAddress[128];   //�ͻ��˵�ַ 

std::list<SOCKET>allClient;

void usage()
{
	printf("usage: server [-p:x] [-i:IP] [-o]\n\n");
	exit(0); //�˳�����
}

std::string splitString(std::string data)
{
	std::string rs = "";
	if (data.find("#", 1) != std::string::npos)
	{
		int pos = data.find("#", 1);
		std::string name = data.substr(1, pos - 1);
		std::string info = data.substr(pos + 1, strlen(data.c_str()));
		rs = name + "˵��" + info;
		return rs;
	}
	return data;
}

DWORD WINAPI ClientThread(LPVOID lpParam) //Ϊ�ͻ��˷�����̺߳��� 
{
	SOCKET sock = (SOCKET)lpParam; //����socket�Ų���ֵ�󶨱���IP��ַ���˿ں� 
	char   szBuff[DEFAULT_BUFFER]; //������ 
	int   ret, //�жϵ��ú�����ķ���ֵ 
		nLeft, //�����ַ������� 
		idx; //�±� 

	while (1)
	{
		ret = recv(sock, szBuff, DEFAULT_BUFFER, 0);//ret�ǽ������ݺ󷵻صĳ��� 
		if (ret == 0)     //Ϊ0��ʾ���ܽ��� 
			break;
		else if (ret == SOCKET_ERROR)   //ΪSOCKET_ERROR���ճ��� 
		{
			int errCode = WSAGetLastError();
			printf("recv() failed: %d\n", errCode);
			/*if (errCode == 10054)
			{*/
				
				std::list<SOCKET>::iterator it = find(allClient.begin(), allClient.end(), sock);
				if (it != allClient.end())
				{
					allClient.erase(it);
				}
				printf("�ͻ��������Ͽ�����,�ͻ�������=%d", allClient.size());
			//}
			break;
		}
		szBuff[ret] = '\0';
		printf("�Է�: %s\n", szBuff); //������յ���������Ϣ 

		fflush(stdin);
		nLeft = sizeof(szBuff);
		std::string msg = szBuff;

		for (std::list<SOCKET>::iterator it = allClient.begin(); it != allClient.end(); ++it)
		{
			printf("send data to client\n");
			ret = send((SOCKET)(*it), msg.c_str(), strlen(msg.c_str()), 0);
			
			if (ret == SOCKET_ERROR)
			{
				printf("send() failed: %d\n", WSAGetLastError());
				//allClient.erase(it);
				continue;
			}
			else
			{
				
			}
		}
	}
	return 0;
}

int main(int argc, char **argv)
{
	WSADATA wsd; //�汾��Ϣ�ṹ 
	//ע�����������ڼ����Ļ������ھ�������socket�Ū���IP���˿���һ����~ 
	SOCKET sListen, sClient; //���ڶԿͻ��ṩ��������socket�� //���ڼ�����socket�� 
	int   iAddrSize; //��ַ���ȱ��� 
	HANDLE hThread; //�Կͻ������߳̾�� 
	DWORD   dwThreadID; //�߳�ID 
	struct sockaddr_in local, //���ص�ַ��IP��ַ���˿� 
		client; //�ͻ���ַ 
	//ValidateArgs(argc,argv); //�������޶��ɽ������ӷ��ʵĿͻ���IP��ַ 
	//(1)����DLL 
	if (WSAStartup(MAKEWORD(2, 2), &wsd) != 0) //��Ϊ0��ʾ����DLLʧ�� 
	{
		printf("����DLLʧ��!");
		return 1;
	}
	//(2)����socket�� 
	sListen = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
	if (sListen == SOCKET_ERROR)
	{
		printf("socket�Ŵ���ʧ��: %d\n", WSAGetLastError());
		return 1;
	}

	//ע�᱾�ص�ַIP\�˿ڼ����� 
	local.sin_family = AF_INET; //˵����Internet����ͨ�� 
	local.sin_port = htons(iPort);   //��֤�ֽ�˳�� 
	if (bInterface)//����bInterface�������Ƿ������еļ�������Ƿ���ר�ŵļ����~ 
	{
		//�������ַ�ֽ�ת��Ϊ��������ֵ��ַ,��unsigned long addr=inet_addr("192.1.8.84") 
		local.sin_addr.s_addr = inet_addr(SERVERIP);
		if (local.sin_addr.s_addr == INADDR_NONE)
			usage(); //��������ַ��ʽ����,���˳����� 
	}
	else
	{
		//INADDR_ANY��ֵ��ʾ������������еļ���� 
		local.sin_addr.s_addr = htonl(INADDR_ANY);//��֤�ֽ�˳�� 
	}

	//��ע��õ��׽��ֵ�ַ���׽��ְ�����(socket�ű����ڱ��ص�ַ��!) 
	if (bind(sListen, (struct sockaddr *)&local, sizeof(local)) == SOCKET_ERROR)
	{ //����󶨳��� 
		printf("bind() failed: %d\n", WSAGetLastError());
		return 1;
	}

	//��ʼ����������,��ʼ����"����" 
	listen(sListen, 5);
	//������,����˽�����һ������socket��,���뱾�ص�ַ��,��ʼ�����涨�Ķ˿���Ϣ 


	while (1)
	{
		printf("\n��ʼ����...\n");
		iAddrSize = sizeof(client); //�ͻ���ַ���� 
		//ע��:�����clientȷʵ�ǿͻ���ַ���ݽṹ,����ʹ��accept()������ʱ��, 
		//�����ݽṹδ��ʼ��,��ͨ������accept()����,��ʹ�˵�ַ�ṹ��ȡ���Կͻ��ĵ�ַ��Ϣ 
		//accept()���ص���һ���ͱ��ص�ַ(����������ַ)�󶨵�socket��,��������˴������󶨹���
			sClient = accept(sListen, (struct sockaddr *)&client, &iAddrSize);
		//�ҿ�,���ܲ���һ��ѭ�����̰�... 
		if (sClient == INVALID_SOCKET) //�������ӷ�������ʱ,����INVALID_SOCKET 
		{
			printf("accept()��������ʧ��: %d\n", WSAGetLastError());
			break;
		}
		printf("�������˿ͻ���...\n����IP:%s �˿�:%d\n",inet_ntoa(client.sin_addr), ntohs(client.sin_port));
		allClient.push_back(sClient);
		printf("���пͻ���������%d", allClient.size());
		//inet_ntoa()�����������ַת��Ϊһ���ô����ַ�����־�������ַ 
		//ntohs()����������˿ڸ�ʽת��Ϊʮ���Ƹ�ʽ�˿� 
		//�������̵�����,�϶��Ѿ���������,���Կ�ʼ���������߳��ṩ���� 
		//�̵߳Ľ�����Ϣ�����̺߳�����ַ,�ͻ�����ַ 
		//ÿ���ͻ��˴���һ���߳�
		hThread = CreateThread(NULL, 0, ClientThread,(LPVOID)sClient, 0, &dwThreadID);
		if (hThread == NULL) //����̴߳���ʧ�� 
		{
			printf("�����߳�ʧ��: %d\n", WSAGetLastError());
			break;
		}
		CloseHandle(hThread); //�����������̺߳�,���Ϲر��߳̾��  
	}
	closesocket(sListen); //�رռ���socket�� 
	WSACleanup();   //����DLL 
	return 0;
}