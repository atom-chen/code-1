NetWorkMgr = class("NetWorkMgr")

--C++层的网络管理器
local instance = NetWorkManager:getInstance()

--初始化网络
function NetWorkMgr:initNetWork()
	instance:init()
end

--重连网络
function NetWorkManager:reConnet()
	instance:reConnect()
end

--发数据给服务器
function NetWorkManager:send(data)
	instance:sendData(data)
end