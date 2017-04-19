EffectNode = class("EffectNode")

function EffectNode:create(effectId, parent)
	local ret = EffectNode.new()
	ret:init(effectId, parent)
	return ret
end

function EffectNode:init(effectId, parent)
	local data = EffectManager:getDataById(effectId)
	if not data then
		print(effectId.."没有对应的数据可以读取")
		return
	end
	local FrameAnim = EffectManager:getFrameAnim(data)
	local uitype = data.uitype
	local startName = string.format(data.path, data.index)
	self.sprite = nil
	if uitype == 0 then
		self.sprite = cc.Sprite:create(startName)
	else
		self.sprite = cc.Sprite:createWithSpriteFrameName(startName)
	end
	self.sprite:runAction(FrameAnim)
	parent:addChild(self.sprite)
end

function EffectNode:setPosition(x, y)
	if y and (type(x) == "number" and type(y) == "number") then
		self.sprite:setPosition(x, y)
	elseif type(x) == "table" then
		self.sprite:setPosition(x)
	end
end

function EffectNode:setAnchorPoint(x, y)
	if y and (type(x) == "number" and type(y) == "number") then
		self.sprite:setAnchorPoint(x, y)
	elseif type(x) == "table" then
		self.sprite:setAnchorPoint(x)
	end
end