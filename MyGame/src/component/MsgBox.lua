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

	args.txt = args.txt or ""
	args.title = args.title or "提  示"
	args.cancel = (type(args.cancel) == "function") and args.cancel or function()
		local scale = cc.ScaleTo:create(0.3, 0)
		local action = cc.Sequence:create(scale, cc.CallFunc:create(function()
			self:removeFromParent(false)
		end))
		self:runAction(action)
	end

	args.sure = (type(args.sure) == "function") and args.sure or function()
		local scale = cc.ScaleTo:create(0.3, 0)
		local action = cc.Sequence:create(scale, cc.CallFunc:create(function()
			self:removeFromParent(false)
		end))
		self:runAction(action)
	end

	local btn_cancel = node:getChildByName("btn_cancel")
	ComponentMgr:addTouch(btn_cancel, function()
		args.cancel(args.cancelParam)
	end)

	local lab_msg = node:getChildByName("lab_msg")
	lab_msg:setString(args.txt)

	local lab_title = node:getChildByName("lab_title")
	lab_title:setString(args.title)

	local btn_sure = node:getChildByName("btn_sure")
	btn_sure:setTitleText( args.sureBtnName or "确定" )
	ComponentMgr:addTouch(btn_sure, function()
		args.sure(args.sureParam)
		local scale = cc.ScaleTo:create(0.3, 0)
		local action = cc.Sequence:create(scale, cc.CallFunc:create(function()
			self:removeFromParent(false)
		end))
		self:runAction(action)
	end)
end