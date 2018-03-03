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
	openWin.isOpen = true
	self.win_dic:setObject(openWin, winName)
	openWin:setScale(0)
	if openWin.animation then
		local action = cc.Sequence:create(cc.EaseBackOut:create(cc.ScaleTo:create(0.2, 1)), cc.CallFunc:create(function(sender)
			sender.super.open(sender)
			openWin:open()
		end))
		openWin:runAction(action)
	else
		openWin:setScale(1)
		openWin.super.open(openWin)
		openWin:open()
	end
	
	--打开的时候，判断是否删掉定时器
	if openWin.config == LayerConfig.delay then
		TimerManager.removeTimerWithToken(winName)
	end
	LayerMgr:getWinLayer():addChild(openWin)
end

function LayerCtrol:createWindwos(winName, params)
	require(winName)
	--因为继承了cc.layer  所以子类和baselayer就算都没有create函数会自动调用到cclayer里面的create函数
	local lua_str = "return " .. winName .. ":create()"
	local openWin = loadstring(lua_str)()
	openWin.name = winName
	openWin:addLock()
	--调用基类，进行必要参数的初始化
	openWin.super.init(openWin)
	openWin:init(params)
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
	closeWin.super.close(closeWin)
	closeWin.isOpen = false
	if closeWin.animation then
		local action = cc.Sequence:create(cc.EaseBackOut:create(cc.ScaleTo:create(0.2, 0)), cc.CallFunc:create(function(sender)
			self:closeEvent(sender)
		end))
		closeWin:runAction(action)
	else
		self:closeEvent(closeWin)
	end
end

function LayerCtrol:closeEvent(win)
	local config = win.config or LayerConfig.delay
	if config == LayerConfig.destory then
		self.win_dic:removeWithKey(win.name)
		win:destory()
		win:removeFromParent()
	elseif config == LayerConfig.delay then
		TimerManager.addTimer(LayerConfig.delayTime, function(layer)
			if layer.isOpen then
				return
			end
			self.win_dic:removeWithKey(layer.name)
			layer:destory()
			layer:removeFromParent()
		end, false, win)
	else
		win:close()
	end
end

function LayerCtrol:destory()
	self.win_dic:clean()
end

function LayerCtrol:destoryByName(name)
	if not self.win_dic:objectForKey(name) then
		return
	end
	local closeWin = self.win_dic:objectForKey(name)
	self.win_dic:removeWithKey(name)
	closeWin:close()
	closeWin:destory()
	closeWin:removeFromParent()
end