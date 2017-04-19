LayerMgr = class("LayerMgr")

LayerMgr.mainLayer = nil

LayerMgr.winLayer = nil

LayerMgr.msgLayer = nil

LayerMgr.tipsLayer = nil

LayerMgr.markLayer = nil

function LayerMgr:initAllLayer(parent)
	self.mainLayer = cc.Layer:create()
	parent:addChild(self.mainLayer)

	self.winLayer = cc.Layer:create()
	parent:addChild(self.winLayer)

	self.msgLayer = cc.Layer:create()
	parent:addChild(self.msgLayer)

	self.tipsLayer = cc.Layer:create()
	parent:addChild(self.tipsLayer)

	self.markLayer = ccui.Layout:create()
	self.markLayer:setTouchEnabled(false)
	local size = cc.Director:getInstance():getWinSize()
	self.markLayer:setContentSize(size)
	parent:addChild(self.markLayer)
end

function LayerMgr:getMainLayer()
	return self.mainLayer
end

function LayerMgr:getWinLayer()
	return self.winLayer
end

function LayerMgr:getMsgLayer()
	return self.msgLayer
end

function LayerMgr:getTipsLayer()
	return self.tipsLayer
end

function LayerMgr:setMarkTouch(touch)
	self.markLayer:setTouchEnabled(touch)
end