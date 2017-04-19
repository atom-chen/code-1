LayerBase = class("LayerBase", function()
	return cc.Layer:create()
end)

LayerBase.name = nil
LayerBase.animation = false

function LayerBase:ctor()
	self._allRes = {}
end

function LayerBase:init()
end

function LayerBase:open()
end

function LayerBase:close()
end

function LayerBase:addLock()
	local lockLayer = ccui.Layout:create()
	lockLayer:setTouchEnabled(true)
    lockLayer:setContentSize(cc.size(960, 640))
    self:addChild(lockLayer)
end

function LayerBase:loadRes(path)
	self._allRes = self._allRes or {}
	self._allRes[path] = true
	CommonResMgr:getInstance():loadRes(path)
end

function LayerBase:destroy()
	self._allRes = self._allRes or {}
	for k,v in pairs(self._allRes) do
		CommonResMgr:getInstance():removeRes(k)
	end
	self._allRes = {}
end