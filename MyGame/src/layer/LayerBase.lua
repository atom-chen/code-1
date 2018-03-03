LayerBase = class("LayerBase", function()
	return cc.Layer:create()
end)

LayerBase.name = nil
LayerBase.animation = false
LayerBase.config = LayerConfig.delay

function LayerBase:init()
	self._allRes = {}
	self._allTimerKey = {}
end

function LayerBase:open()
	for k,v in pairs(self._allTimerKey) do
		TimerManager.addTimer( v.time , v.callfunc , true , v.data , v.key )
	end
end

function LayerBase:close()
	for k,v in pairs(self._allTimerKey) do
		TimerManager.removeTimerWithToken( v.key )
	end
end

function LayerBase:addLock()
	local lockLayer = ccui.Layout:create()
	lockLayer:setTouchEnabled(true)
    lockLayer:setContentSize(cc.size(960, 480))
    self:addChild(lockLayer)
end

--加载资源都用这个函数
function LayerBase:loadRes(plist)
	CommonResMgr:getInstance():loadRes(plist)
	self._allRes[plist] = true
end

function LayerBase:destory()
	for k,v in pairs(self._allRes) do
		CommonResMgr:getInstance():removeRes(k)
	end
	self._allRes = {}
	--因为destory是调用了close才会触发的，所以不用再次清空定时器
	self._allTimerKey = {}
end

--循环的定时器
function LayerBase:addTimer( time , key , callfunc , data )
	if self._allTimerKey[key] ~= nil then
		return
	end
	self._allTimerKey[key] = {key = key , callfunc = callfunc , time = time , data = data}
	TimerManager.addTimer( time , callfunc , true , data , key )
end