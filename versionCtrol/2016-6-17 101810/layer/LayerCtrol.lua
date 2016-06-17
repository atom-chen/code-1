LayerCtrol = class("LayerCtrol")

local instance = nil

LayerCtrol.win_dic = nil

function LayerCtrol:ctor()
	self.allWindows = {}
	self.win_dic = Dictionary:create()
end

function LayerCtrol:getInstance()
	if not instance then
		instance = LayerCtrol.new()
	end
	return instance
end

function LayerCtrol:open(winName)
	local openWin = self.win_dic:objectForKey(winName)
	if not openWin then
		openWin = self:createWindwos(winName)
	end
	if openWin.isOpen then
		print("warn---->窗体处于打开状态，不能重复打开")
		return
	end
	self.win_dic:setObject(openWin, winName)
	openWin:setScale(0)
	if openWin.animation then
		local action = cc.Sequence:create(cc.EaseBackOut:create(cc.ScaleTo:create(0.2, 1)), cc.CallFunc:create(function()
			openWin:open()
		end))
		openWin:runAction(action)
	else
		openWin:setScale(1)
		openWin:open()
	end
	openWin.isOpen = true
	LayerMgr:getWinLayer():addChild(openWin)
end

function LayerCtrol:createWindwos(winName, params)
	local openWin = nil
	if winName == CmdName.LoginView then
		require "LoginView"
		openWin = LoginView:create(params)
	elseif winName == CmdName.UpdateView then
		require "UpdateView"
		openWin = UpdateView:create(params)
	end
	openWin.name = winName
	openWin:addLock()
	openWin:init()
	return openWin
end

function LayerCtrol:close(winName)
	local closeWin = self.win_dic:objectForKey(winName)
	if not closeWin then
		print(winName.."没有对应的窗体")
		return
	end
	if not closeWin.isOpen then
		print(winName.."窗体没打开")
		return
	end
	closeWin.isOpen = false
	if closeWin.animation then
		local action = cc.Sequence:create(cc.EaseBackOut:create(cc.ScaleTo:create(0.2, 0)), cc.CallFunc:create(function()
			if closeWin.destory then
				self.win_dic:removeWithKey(winName)
			end
			closeWin:close()
			closeWin:removeFromParent(true)
		end))
		closeWin:runAction(action)
	else
		if closeWin.destory then
			self.win_dic:removeWithKey(winName)
		end
		closeWin:close()
		closeWin:removeFromParent(true)
	end
	
end

function LayerCtrol:destory()
	self.win_dic:clean()
end