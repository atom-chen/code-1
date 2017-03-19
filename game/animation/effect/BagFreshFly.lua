
--一个物品，一个物品慢慢飘
BagFreshFly = class("BagFreshFly", BaseAnimation)

function BagFreshFly:finalize()
	BagFreshFly.super.finalize(self)
end

function BagFreshFly:play()
	
    local dir = 0
	local index = 0 
    for _,v in pairs(self.data.rewards) do
        local power = v.power
        local info = RewardDefine.type[power]
        --if power ~= GamePowerConfig.Resource then
        if power == GamePowerConfig.Soldier 
            or power == GamePowerConfig.General 
            or power == GamePowerConfig.Hero
            or power == GamePowerConfig.Item
            or power == GamePowerConfig.Ordnance
            or power == GamePowerConfig.HeroTreasure
            or power == GamePowerConfig.HeroTreasureFragment
            or power == GamePowerConfig.Resource  
            or power == GamePowerConfig.OrdnanceFragment then
            if v.num > 0  then
                --经验或者资源，不走这里的动画
--                if not (v.typeid == PlayerPowerDefine.POWER_exp) then
                    local function delayGetRewardAction()
                        self:getRewardAction(v, index + dir) 
                    end
                    EffectQueueManager:addEffect(EffectQueueType.GET_REWARD, delayGetRewardAction, false)
--                end

                index = index + 1
            end
        else
            -- info = info..",数量为："..v.num
            -- self:showSysMessage(info)
        end
    end

end

function BagFreshFly:getRewardAction(reward, index)
	local text = ccui.Text:create()
    local str = string.format("+%d", reward.num)
    text:setString(str)
    text:setFontSize(RewardActionConfig.FONT_SIZE)
    text:setColor(ColorUtils.wordGreenColor)
    text:setAnchorPoint(cc.p(0, 0.5))
    text:setPosition(RewardActionConfig.DISTANCE, 0)
    local node = cc.Node:create()
    node:addChild(text)
    local rewardIcon
    local energyImg
    if reward.typeid == PlayerPowerDefine.POWER_energy and reward.power == GamePowerConfig.Resource then --当时好友祝福的时候不走UIIcon 自己创建图片
        energyImg = TextureManager:createImageView("images/gui/bg_energy.png")
        energyImg:setAnchorPoint(cc.p(0, 0.5))
        energyImg:setPosition(cc.p(FightingActionCapConfig.energy_X - 30, FightingActionCapConfig.energy_Y))
        text:setPosition(RewardActionConfig.TL_X, 0)
        node:addChild(energyImg)  
    else
        local data = {}
        data.power = reward.power
        data.num = 1
        data.typeid = reward.typeid 
        rewardIcon = UIIcon.new(node, data , true)
        rewardIcon:setTouchEnabled(false)
        rewardIcon:setScale(RewardActionConfig.ICON_SCALE)
        
        local movieChip = UIMovieClip.new("baoshi_white", 0.06)
        movieChip:setParent(node)
        movieChip:play(false)
    end
    local layer =  self.parent
    layer:addChild(node)
    if index % 2 == 0 then
        node:setPosition(RewardActionConfig.LEFT_POSITION_X, RewardActionConfig.LEFT_POSITION_Y)
    else
        node:setPosition(RewardActionConfig.RIGHT_POSITION_X, RewardActionConfig.RIGHT_POSITION_Y)
    end
    node:setVisible(false)
    
    local function callback()
    	EffectQueueManager:completeEffect()
        --TODO 这里需要判断已经播放完了
    end
    self:showGetRewardActionQueue(node, callback)
end

function BagFreshFly:showGetRewardActionQueue(node, readyCallback)
    local function callback()
        node:setVisible(true)
        self:showGetRewardAction(node)
        readyCallback()
    end
    
    AudioManager:playEffect("yx_item")
    
    local noAction = cc.MoveBy:create(RewardActionConfig.INTERVAL_TIME, cc.p(0, 0))
    node:runAction(cc.Sequence:create(noAction, cc.CallFunc:create(callback)))
end

function BagFreshFly:showGetRewardAction(node)
    local function callback()
        node:removeFromParent()
    end
    local x, y = node:getPosition()

    local action = cc.MoveTo:create(RewardActionConfig.FLY_TIME, cc.p(x, y + RewardActionConfig.FLY_HIGHT))
    node:runAction(cc.Sequence:create(action, cc.CallFunc:create(callback)))
end
