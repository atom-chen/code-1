TestView = class("TestView", LayerBase)
TestView.animation = true

function TestView:create()
	local ret = TestView.new()
	return ret
end

function TestView:init()
	-- local dic = Dictionary:create()
	-- local spr = ccui.ImageView:create()
	local spr1 = ccui.ImageView:create()
	-- local spr2 = ccui.ImageView:create()
	-- dic:setObject(spr1, "spr1")

	spr1:loadTexture("bg_14.png", 1)
	spr1:setPosition(480, 320)
	self:addChild(spr1)

	-- spr2:loadTexture("bg_14.png", 1)
	-- spr2:setPosition(300, 100)
	-- self:addChild(spr2)

	
	-- spr:loadTexture("bg_14.png", 1)
	ComponentMgr:addTouch(spr1, function()
		-- spr1:removeFromParent(false)
		LayerCtrol:getInstance():close(self.name)
	end)
	-- spr:setPosition(300, 300)
	-- self:addChild(spr)

	-- ComponentMgr:addTouch(spr2, function()
	-- 	-- spr1:removeFromParent(false)
	-- 	-- print(spr1)
	-- 	local sp = dic:objectForKey("spr1")
	-- 	if sp then
	-- 		sp:setPosition(300, 600)
	-- 		self:addChild(sp)
	-- 	end
	-- end)

end

function TestView:open()
	print("open")
end