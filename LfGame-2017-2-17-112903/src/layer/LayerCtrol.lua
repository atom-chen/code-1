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

	TimerManager.removeTimerWithToken(winName)

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

	local function destory(params)
		params.isOpen = false
		if params.animation then
			local action = cc.Sequence:create(cc.EaseBackOut:create(cc.ScaleTo:create(0.2, 0)), cc.CallFunc:create(function()
				self.win_dic:removeWithKey(winName)
				params:close()
				params:destory()
				params:removeFromParent(true)
			end))
			params:runAction(action)
		else
			self.win_dic:removeWithKey(winName)
			params:close()
			params:destory()
			params:removeFromParent(true)
		end
	end

	--默认关闭立马释放
	local closeType = closeWin.closeType or LayerConfig.Died
	if closeType == LayerConfig.Died then
		destory(closeWin)
	elseif closeType == LayerConfig.Delay then
		TimerManager.addTimer(LayerConfig.DelayTime, function(param)
			if param.isOpen then
				return
			end
			destory(param)
		end, false, closeWin, winName)
	end
	
end

function LayerCtrol:destory()
	self.win_dic:clean()
end