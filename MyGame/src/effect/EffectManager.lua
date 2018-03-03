require "effect_data"
EffectManager = class("EffectManager")

local instance = nil

local cache = cc.SpriteFrameCache:getInstance()

function EffectManager:ctor()
end

function EffectManager:getInstance()
	if not instance then
		instance = EffectManager.new()
	end
	return instance
end

function EffectManager:getDataById(id)
	local baseData = Common:getInstance():getExcelData("effect_data")
	local data = Common:getInstance():getChildData(baseData, "anim_info")
	return data[id]
end

function EffectManager:getFrameAnim(data)
	local anim = nil
	if data.uitype == 0 then
		anim = self:createWithLocal(data)
	else
		anim = self:createAnimWithCache(data)
	end
	return anim
end

function EffectManager:createAnimWithCache(data)
	local animFrames = {}
	local idx = data.index
	while true do
		local name = string.format(data.path, idx)
		local frameSprite = cache:createWithSpriteFrameName(name)
		if not frameSprite then
			break
		end
		table.insert(animFrames, frameSprite)
		idx = idx + 1
	end
	local animation = cc.Animation:createWithSpriteFrames(animFrames)
	animation:setDelayPerUnit(data.time/1000)
	animation:setLoops(data.loop)
	return cc.Animate:create(animation)
end

function EffectManager:createWithLocal(data)
	local animation = cc.Animation:create()
	local idx = data.index
	while true do
		local name = string.format(data.path, idx)
		local isHas = CommonResMgr:getInstance():getFilePath(name)
		if not isHas then
			break
		end
		animation:addSpriteFrameWithFile(name)
		idx = idx + 1
	end
    animation:setDelayPerUnit(data.time/1000)
	animation:setLoops(data.loop)

    return cc.Animate:create(animation)
end