LoginView = class("LoginView", LayerBase)


function LoginView:create()
	local ret = LoginView.new()
	return ret
end

function LoginView:init()



	local spr = tSpr:create("ui/1.jpg")
	spr:setAnchorPoint(0,0.5)
	spr:setPosition(100,320)
	self:addChild(spr)


	-- local listenner = cc.EventListenerTouchOneByOne:create()
	-- listenner:registerScriptHandler(function(touch, event)    
 --   		print("onTouch")    
 --   		return true    
	-- end, cc.Handler.EVENT_TOUCH_BEGAN )  
  
	-- listenner:registerScriptHandler(function(touch, event)  
 --   		print("onTouchMoved")    
	-- end, cc.Handler.EVENT_TOUCH_MOVED )    

	-- listenner:registerScriptHandler(function(touch, event)    
 --   		print("onTouched")    
	-- end, cc.Handler.EVENT_TOUCH_ENDED )
	-- local eventDispatcher = spr:getEventDispatcher()
	-- eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, spr)


	-- eventDispatcher:addEventListenerWithFixedPriority(listenner, -128)

	-- spr:setScaleX(300/size.width)

	-- local action = cc.RepeatForever:create(cc.RotateBy:create(0.1, 60))

	-- local param = {{img = "Star.png"},
	-- 			   {txt = "12345678910", data = {"1"}},
	-- 			   {txt = "99", data = {"1"}},
	-- 			   {txt = "bcdefghijklnmopqrstuvwxyz", data = "3"},
	-- 			   {txt = "~!@#*$%^&*()_+"},
	-- 			   {img = "Star.png", data = 4},
	-- 				{txt = "555555555", data = "5"},{txt = "99"},
	-- 			   {txt = "bcdefghijklnmopqrstuvwxyz"},{txt = "~!@#*$%^&*()_+"},
	-- 			   {img = "Star.png"},{txt = "12345678910", data = "par2am"},{txt = "99"},
	-- 			   {txt = "bcdefghijklnmopqrstuvwxyz"},{txt = "~!@#*$%^&*()_+"},
	-- 			   {img = "Star.png"}}
	-- local richLabel = ComponentMgr:getRichText(param, 300, self.testCall, self)
	-- -- local richLabel = RichText:create()
	-- richLabel:setAnchorPoint(0,0.5)
	-- -- richLabel:init(param, 300, nil, nil, nil, nil, nil)
	-- richLabel:setPosition(100, 320)
	-- self:addChild(richLabel) 
	
	local testUpdate = require "testUpdate"
	for k,v in pairs(testUpdate) do
		print(k,v)
	end

	print("-=-----------------------")
	require "hehe"
	-- local sw = require "testUpdate"
	-- for k,v in pairs(sw) do
	-- 	print(k,v)
	-- end
	-- local path = cc.FileUtils:getInstance():getWritablePath().."pkag"
	-- Custom:initDownloadDir(path)
	-- local x = cc.Sprite:create("Star.png")
	-- x:setPosition(10,320)
	-- self:addChild(x)

	-- local x1 = cc.Sprite:create("Star.png")
	-- x1:setPosition(950,320)
	-- self:addChild(x1)
    -- Utils.createFile(self.path)
	-- local param = {{txt='恭喜',color='#eed6aa'},{txt='NAME',color='#30c7ff',isUnderLine=1},{txt='成为VIP1,获得了大量的特权',color='#eed6aa'}}
	-- local rich = ComponentMgr:getRichLabel(param, 400)
	-- rich:setAnchorPoint(cc.p(0.5, 0.5))
	-- rich:setPosition(480, 320)
	-- print(rich:getContentSize().width)
	-- self:addChild(rich)
	-- -- local ss = cc.Sprite:create("login_bg.png")
	-- -- ss:setPosition(480, 320)
	-- -- self:addChild(ss)
	-- -- print(device.platform)
	-- -- local dic = Dictionary:create()
	-- local spr = ccui.ImageView:create()
	-- local result = 3
	-- local angle = 360-(result - 1)*30

	-- self.Stop = false
	-- local allAngle = 0
	-- local needData = 0
	-- local speed = 400

	-- local function rotateSpr()
	-- 	if self.Stop then
	-- 		allAngle = allAngle%360
	-- 		if allAngle >= angle then
	-- 			needData = 360 - allAngle + angle 
	-- 		else
	-- 			needData = angle - allAngle
	-- 		end
	-- 		allAngle = 0
	-- 		local allQ =  math.random(3, 4)*360 + needData
	-- 		-- local allQ =  1*360 + needData
	-- 		-- local act = cc.EaseExponentialOut:create(cc.RotateBy:create(allQ/speed, allQ))
	-- 		-- local act = cc.EaseSineOut:create(cc.RotateBy:create(allQ/speed, allQ))
	-- 		local act = cc.EaseSineInOut:create(cc.RotateBy:create(allQ/speed, allQ))
	-- 		local wa = cc.Sequence:create(act, cc.CallFunc:create(function()
	-- 			print(os.time() - self.wwq)
	-- 		end))
	-- 		-- EaseSineInOut
	-- 		-- EaseSineOut
	-- 		spr:runAction(wa)
	-- 		self.wwq = os.time()

	-- 		self.Stop = false
	-- 		return
	-- 	end
	-- 	allAngle = allAngle + 0.5
	-- 	local action = cc.Sequence:create(cc.RotateBy:create(0.1, 0.5) ,cc.CallFunc:create(rotateSpr))
	-- 	spr:runAction(action)
	-- end
	-- spr:runAction(cc.CallFunc:create(rotateSpr))
	-- spr:runAction(cc.EaseSineOut:create(cc.RotateBy:create(2, 180)))

	-- local spr1 = ccui.ImageView:create()
	-- -- local spr2 = ccui.ImageView:create()
	-- -- -- dic:setObject(spr1, "spr1")

	-- spr1:loadTexture("Star.png")
	-- spr1:setPosition(80, 100)
	-- self:addChild(spr1)

	-- spr2:loadTexture("bg_14.png", 1)
	-- spr2:setPosition(300, 100)
	-- self:addChild(spr2)

	-- -- local edit = ComponentMgr:getEditBox(1, self, cc.size(600, 80))
	-- -- edit:setPosition(600, 300)
	-- -- edit:setFontSize(30)
	-- spr:loadTexture("bg_14.png", 1)
	-- ComponentMgr:addTouch(spr, function()
	-- -- 	-- Notifier.dispatch(CmdName.MsgBox, {})

	-- -- 	-- spr1:removeFromParent(false)
	-- 	LayerCtrol:getInstance():open("test")
	-- end)
	-- spr:setPosition(300, 300)
	-- self:addChild(spr)
	
	-- ComponentMgr:addTouch(spr1, function()
		-- spr:stopAllActions()
		-- self.Stop = true
		-- allQ = 1080
		-- print(allQ)
		
	-- 	LayerCtrol:getInstance():close("test")
	-- 	-- spr1:removeFromParent(false)
	-- -- 	-- print(spr1)
	-- -- 	-- local sp = dic:objectForKey("spr1")
	-- -- 	-- if sp then
	-- -- 	-- 	sp:setPosition(300, 600)
	-- -- 	-- 	self:addChild(sp)
	-- -- 	-- end
	-- end)
	-- self.sw = ccui.Text:create()
	-- TimerManager.addTimer(1000, function()
		-- self:testAutoRelease()
	-- end, false, nil, "as")

	
end

function LoginView:testAutoRelease()
	print("hehe")
	self.sw:setString("haha")
end

function LoginView:testCall(args)
	print("测试回调",args)
end

function LoginView:testCall1(args)
	print("测试回调",args)
end

function LoginView:open()
end


tSpr = class("tSpr", function(name)
	return cc.Sprite:create(name)
end)

function tSpr:create(name)
	local ret = tSpr.new(name)
	ret:init()
	return ret
end

function tSpr:init()
	local size = self:getContentSize()
	local listenner = cc.EventListenerTouchOneByOne:create()
	listenner:registerScriptHandler(function(touch, event)    
   		local target = event:getCurrentTarget()
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
   		local rect = cc.rect(0, 0, size.width, size.height)
   		if cc.rectContainsPoint(rect, locationInNode) then
            return true
        end
        return false
	end, cc.Handler.EVENT_TOUCH_BEGAN )  
  
	listenner:registerScriptHandler(function(touch, event)  
   		print("onTouchMoved")    
	end, cc.Handler.EVENT_TOUCH_MOVED )    

	listenner:registerScriptHandler(function(touch, event)    
   		print("onTouched")    
	end, cc.Handler.EVENT_TOUCH_ENDED )
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)
end