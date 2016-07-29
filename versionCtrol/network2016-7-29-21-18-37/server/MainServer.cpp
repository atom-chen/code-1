//TCP之服务端程序 

#include <stdio.h> 
#include <WinSock2.h>
#include <WS2tcpip.h> 
#include <Windows.h>


#include <stdlib.h> 
#include <list>
#include <algorithm>
#include <iostream>
#pragma comment(lib,"ws2_32.lib")
#define DEFAULT_PORT 12345 //默认端口 
#define DEFAULT_BUFFER 4095 //默认缓冲区大小 
//#define SERVERIP "127.0.0.1"
#define SERVERIP "192.168.10.113"

int iPort = DEFAULT_PORT; //端口设置 
BOOL bInterface = TRUE;   //是否面向所有计算机 
BOOL bRecvOnly = FALSE;   //接收状态 
char szAddress[128];   //客户端地址 

std::list<SOCKET>allClient;

void usage()
{
	printf("usage: server [-p:x] [-i:IP] [-o]\n\n");
	exit(0); //退出进程
}

std::string splitString(std::string data)
{
	std::string rs = "";
	if (data.find("#", 1) != std::string::npos)
	{
		int pos = data.find("#", 1);
		std::string name = data.substr(1, pos - 1);
		std::string info = data.substr(pos + 1, strlen(data.c_str()));
		rs = name + "说：" + info;
		return rs;
	}
	return data;
}

DWORD WINAPI ClientThread(LPVOID lpParam) //为客户端服务的线程函数 
{
	SOCKET sock = (SOCKET)lpParam; //建立socket号并赋值绑定本机IP地址及端口号 
	char   szBuff[DEFAULT_BUFFER]; //缓冲区 
	int   ret, //判断调用函数后的返回值 
		nLeft, //计算字符串长度 
		idx; //下标 

	while (1)
	{
		ret = recv(sock, szBuff, DEFAULT_BUFFER, 0);//ret是接收数据后返回的长度 
		if (ret == 0)     //为0表示不能接收 
			break;
		else if (ret == SOCKET_ERROR)   //为SOCKET_ERROR接收出错 
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
				printf("客户端主动断开连接,客户端数量=%d", allClient.size());
			//}
			break;
		}
		szBuff[ret] = '\0';
		printf("对方: %s\n", szBuff); //输出接收到的数据信息 

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
	WSADATA wsd; //版本信息结构 
	//注不管是用于监听的还是用于具体服务的socket号其IP及端口是一样的~ 
	SOCKET sListen, sClient; //用于对客户提供具体服务的socket号 //用于监听的socket号 
	int   iAddrSize; //地址长度变量 
	HANDLE hThread; //对客户服务线程句柄 
	DWORD   dwThreadID; //线程ID 
	struct sockaddr_in local, //本地地址IP地址及端口 
		client; //客户地址 
	//ValidateArgs(argc,argv); //好象是限定可接受连接访问的客户机IP地址 
	//(1)加载DLL 
	if (WSAStartup(MAKEWORD(2, 2), &wsd) != 0) //不为0表示加载DLL失败 
	{
		printf("加载DLL失败!");
		return 1;
	}
	//(2)创建socket号 
	sListen = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
	if (sListen == SOCKET_ERROR)
	{
		printf("socket号创建失败: %d\n", WSAGetLastError());
		return 1;
	}

	//注册本地地址IP\端口及网络 
	local.sin_family = AF_INET; //说明是Internet网的通信 
	local.sin_port = htons(iPort);   //保证字节顺序 
	if (bInterface)//根据bInterface来决定是服务所有的计算机还是服务专门的计算机~ 
	{
		//将网络地址字节转化为短整型数值地址,如unsigned long addr=inet_addr("192.1.8.84") 
		local.sin_addr.s_addr = inet_addr(SERVERIP);
		if (local.sin_addr.s_addr == INADDR_NONE)
			usage(); //如果输入地址格式错误,则退出程序 
	}
	else
	{
		//INADDR_ANY数值表示服务对象是所有的计算机 
		local.sin_addr.s_addr = htonl(INADDR_ANY);//保证字节顺序 
	}

	//将注册好的套接字地址与套接字绑定起来(socket号必须于本地地址绑定!) 
	if (bind(sListen, (struct sockaddr *)&local, sizeof(local)) == SOCKET_ERROR)
	{ //如果绑定出错 
		printf("bind() failed: %d\n", WSAGetLastError());
		return 1;
	}

	//初始化工作做好,开始进入"监听" 
	listen(sListen, 5);
	//到这里,服务端建立了一个监听socket号,并与本地地址绑定,开始监听规定的端口信息 


	while (1)
	{
		printf("\n开始监听...\n");
		iAddrSize = sizeof(client); //客户地址长度 
		//注意:这里的client确实是客户地址数据结构,但是使用accept()函数的时候, 
		//此数据结构未初始化,即通过调用accept()函数,来使此地址结构获取来自客户的地址信息 
		//accept()返回的是一个和本地地址(即服务器地址)绑定的socket号,隐藏完成了创建及绑定过程
			sClient = accept(sListen, (struct sockaddr *)&client, &iAddrSize);
		//我卡,接受才是一个循环过程啊... 
		if (sClient == INVALID_SOCKET) //接受连接发生错误时,返回INVALID_SOCKET 
		{
			printf("accept()接受连接失败: %d\n", WSAGetLastError());
			break;
		}
		printf("连接上了客户端...\n来自IP:%s 端口:%d\n",inet_ntoa(client.sin_addr), ntohs(client.sin_port));
		allClient.push_back(sClient);
		printf("现有客户端数量，%d", allClient.size());
		//inet_ntoa()函数将网络地址转换为一个用带点字符串标志的网络地址 
		//ntohs()函数将网络端口格式转换为十进制格式端口 
		//由于流程到这里,肯定已经建立连接,所以开始启动服务线程提供服务 
		//线程的建立信息包括线程函数地址,客户机地址 
		//每个客户端创建一个线程
		hThread = CreateThread(NULL, 0, ClientThread,(LPVOID)sClient, 0, &dwThreadID);
		if (hThread == NULL) //如果线程创建失败 
		{
			printf("创建线程失败: %d\n", WSAGetLastError());
			break;
		}
		CloseHandle(hThread); //创建并运行线程后,马上关闭线程句柄  
	}
	closesocket(sListen); //关闭监听socket号 
	WSACleanup();   //撤消DLL 
	return 0;
}