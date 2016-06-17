LayerBase = class("LayerBase", function()
	return cc.Layer:create()
end)

LayerBase.name = nil
LayerBase.animation = false

function LayerBase:init()
end

function LayerBase:open()
end

function LayerBase:close()
end

function LayerBase:addLock()
	local lockLayer = ccui.Layout:create()
	lockLayer:setTouchEnabled(true)
    lockLayer:setContentSize(cc.size(960, 480))
    self:addChild(lockLayer)
end