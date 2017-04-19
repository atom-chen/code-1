MsgBox = class("MsgBox", function()
	return cc.Layer:create()
end)

function MsgBox:create(args)
	local ret = MsgBox.new()
	ret:initView(args)
	return ret
end

function MsgBox:initView(args)

	local node = ComponentMgr:createNode("component/MsgBox.csb")
	self:addChild(node)
	LayerMgr:getTipsLayer():addChild(self)
	LayerMgr:setMarkTouch(true)
	args.txt = args.txt or ""
	args.title = args.title or "提  示"

	local function defaultMethod()
		local scale = cc.ScaleTo:create(0.3, 0)
		local action = cc.Sequence:create(scale, cc.CallFunc:create(function()
			self:removeFromParent(false)
			LayerMgr:setMarkTouch(false)
		end))
		self:runAction(action)
	end

	local btn_cancel = node:getChildByName("btn_cancel")
	ComponentMgr:addTouch(btn_cancel, function()
		if type(args.cancel) == "function" then
			args.cancel(args.cancelParam)
			defaultMethod()
		else
			defaultMethod()
		end
	end)

	local lab_msg = node:getChildByName("lab_msg")
	lab_msg:setString(args.txt)

	local lab_title = node:getChildByName("lab_title")
	lab_title:setString(args.title)

	local btn_sure = node:getChildByName("btn_sure")
	ComponentMgr:addTouch(btn_sure, function()
		if type(args.sure) == "function" then
			args.sure(args.sureParam)
			defaultMethod()
		else
			defaultMethod()
		end
	end)
end