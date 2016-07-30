#include "MTNotificationQueue.h"
#include "CCLuaEngine.h"
#include "../cocos/deprecated/CCNotificationCenter.h"

//pthread_mutex_t sharedNotificationQueueLock;

//class LifeManager_PThreadMutex
//{
//	pthread_mutex_t* mutex;
//
//public:
//	LifeManager_PThreadMutex(pthread_mutex_t* mut) : mutex(mut)
//	{
//		pthread_mutex_init(mutex, NULL);
//	}
//
//	~LifeManager_PThreadMutex()
//	{
//		pthread_mutex_destroy(mutex);
//	}
//
//}__LifeManager_sharedNotificationQueueLock(&sharedNotificationQueueLock);
//
//
//
//class LifeCircleMutexLocker
//{
//	pthread_mutex_t* mutex;
//
//public:
//
//	LifeCircleMutexLocker(pthread_mutex_t* aMutex) : mutex(aMutex)
//	{
//		//上锁 
//		pthread_mutex_lock(mutex);
//	}
//
//	~LifeCircleMutexLocker()
//	{
//		//解锁 
//		pthread_mutex_unlock(mutex);
//	}
//};
//
//#define LifeCircleMutexLock(mutex) LifeCircleMutexLocker __locker__(mutex) 



MTNotificationQueue* MTNotificationQueue::mInstance = NULL;

MTNotificationQueue::CGarbo MTNotificationQueue::Garbo;

MTNotificationQueue::MTNotificationQueue(void)
{
	NotificationCenter::getInstance()->addObserver(this, CC_CALLFUNCO_SELECTOR(MTNotificationQueue::sendMessage), "recv", NULL);
	NotificationCenter::getInstance()->addObserver(this, CC_CALLFUNCO_SELECTOR(MTNotificationQueue::updateView), "update", NULL);
}

MTNotificationQueue::~MTNotificationQueue(void)
{
	NotificationCenter::getInstance()->removeAllObservers(this);
}

MTNotificationQueue* MTNotificationQueue::getInstance()
{
	if (!mInstance)
	{
		mInstance = new MTNotificationQueue();
	}

	return mInstance;
}

//消息队列的处理  
void MTNotificationQueue::postNotifications(float dt)
{
	//LifeCircleMutexLock(&sharedNotificationQueueLock);
	std::unique_lock<std::mutex> lck (g_mutex);
	for (uint16_t i = 0; i < notifications.size(); i++) 
	{
		NotificationArgs &arg = notifications[i];
		//发送一个消息   
		NotificationCenter::getInstance()->postNotification(arg.name.c_str(), arg.object);
	}
	notifications.clear();
}


//单个消息加入  
void MTNotificationQueue::postNotification(const char* name, Ref* object)
{
	//LifeCircleMutexLock(&sharedNotificationQueueLock);
	std::unique_lock<std::mutex> lck (g_mutex);
	NotificationArgs arg;
	arg.name = name;

	if (object != NULL)
		arg.object = object;   //object->copy();  
	else
		arg.object = NULL;

	notifications.push_back(arg);
}

void MTNotificationQueue::sendMessage(Ref* pSender)
{
	auto pL = LuaEngine::getInstance()->getLuaStack()->getLuaState();
	auto path = FileUtils::getInstance()->fullPathForFilename("Helper.lua");
	luaL_dofile(pL, path.c_str());
	lua_getglobal(pL, "showTips");
	lua_pushstring(pL, "reConnect");
	lua_call(pL, 1, 0);
}

void MTNotificationQueue::updateView(Ref* pSender)
{
	auto args = (Node*)pSender;
	auto pL = LuaEngine::getInstance()->getLuaStack()->getLuaState();
	auto path = FileUtils::getInstance()->fullPathForFilename("Helper.lua");
	luaL_dofile(pL, path.c_str());
	lua_getglobal(pL, "updateChatView");
	lua_pushstring(pL, args->getName().c_str());
	lua_call(pL, 1, 0);
	args->release();
}