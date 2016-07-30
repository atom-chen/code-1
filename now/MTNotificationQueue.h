#ifndef __MTNotificationQueue_h__
#define __MTNotificationQueue_h__

#include <iostream>
#include <vector>
#include "pthread\pthread.h"
#include "cocos2d.h"
USING_NS_CC;

class MTNotificationQueue : public Ref
{
	static MTNotificationQueue * mInstance;
	class CGarbo
	{
	public:
		~CGarbo()
		{
			if (MTNotificationQueue::mInstance)
				delete MTNotificationQueue::mInstance;
			mInstance = NULL;
		}
	};
	static CGarbo Garbo;
	typedef struct
	{
		std::string name;
		Ref* object;
	}NotificationArgs;

	MTNotificationQueue(void);
	std::vector<NotificationArgs> notifications;
public:
	static MTNotificationQueue* getInstance();
	void postNotifications(float dt);
	~MTNotificationQueue(void);
	void postNotification(const char* name, Ref* object);
};


#endif