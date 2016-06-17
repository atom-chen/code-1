Alert = class("Alert", function()
	return cc.Layer:create()
end)

function Alert:create(args)
	local ret = Alert.new()
	ret:initView(args)
	return ret
end

function Alert:initView(args)
	if LayerMgr:getTipsLayer():getChildByTag(10000) then
		LayerMgr:getTipsLayer():removeChildByTag(10000)
	end
	self:stopAllActions()
	self:setScale(1)
	local node = ComponentMgr:createNode("component/Alert.csb")
	node:setAnchorPoint(0.5, 0.5)
	node:setPosition(display.cx, display.cy)
	self:setTag(10000)
	self:addChild(node)
	LayerMgr:getTipsLayer():addChild(self)

	self:setScale(1.1)
	self:show()
	-- self:delay()

	local img9bg = node:getChildByName("img_bg")

	local labTxt = node:getChildByName("lab_msg")
    labTxt:setString(args)
    labTxt:setColor(cc.c3b(251,241,160))

    img9bg:setContentSize(cc.size( labTxt:getContentSize().width + 50, labTxt:getContentSize().height + 20 ))

end

function Alert:show()
	local action = cc.Sequence:create(cc.DelayTime:create(0.1), cc.EaseElasticOut:create(cc.ScaleTo:create(0.2, 1)), cc.DelayTime:create(1), cc.ScaleTo:create(0.3, 0),
        cc.CallFunc:create(function()
            self:removeFromParent(true)
        end))
    self:runAction(action)
end