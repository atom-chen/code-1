LoginView = class("LoginView", LayerBase)

LoginView.animation = true

function LoginView:ctor()
	LoginView.super.ctor(self)
end

function LoginView:create()
	local ret = LoginView.new()
	return ret
end

function LoginView:init()
	local bgImg = ccui.ImageView:create("bg/index_bg.jpg")
	bgImg:setPosition(display.cx, display.cy)
	self:addChild(bgImg)
	bgImg:setName("111")

	local bgImg1 = ccui.ImageView:create("bg/index_bg.jpg")
	bgImg1:setPosition(display.cx, display.cy)
	self:addChild(bgImg1)
	bgImg1:setName("2")


	self:addTouch(bgImg1, bgImg1)
	self:addTouch(bgImg, bgImg)

end

function LoginView:addTouch(panel, obj)
	if obj.listenner == nil then
		obj.listenner = cc.EventListenerTouchOneByOne:create()
		obj.listenner:setSwallowTouches(false)

		obj.listenner:registerScriptHandler(function(touch, event)   
			print("~~~",panel:getName()) 
	        return true   
	    end, cc.Handler.EVENT_TOUCH_BEGAN )

		obj.listenner:registerScriptHandler(function(touch, event)
			
	    end, cc.Handler.EVENT_TOUCH_MOVED )

	    obj.listenner:registerScriptHandler(function(touch, event)
	    end, cc.Handler.EVENT_TOUCH_ENDED ) 

	    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	    eventDispatcher:addEventListenerWithSceneGraphPriority(obj.listenner, panel)
	end
end