
------全局动画工厂---
------用来生产全局的各种动画，
------比如战力飘字、升级、物品飘窗等动画
AnimationFactory = {}

--初始化
function AnimationFactory:init(gameState)
	self._gameState = gameState

	self._animationMap = {}
    self:initFactory()
end

function AnimationFactory:finalize()
    for _, animation in pairs(self._animationMap) do
        animation:finalize()
    end
    self._animationMap = {}
end

function AnimationFactory:initFactory()
    local parent = self._gameState:getLayer(GameLayer.popLayer)
    self._animationMap["BagFreshFly"] = BagFreshFly.new(parent)
    self._animationMap["CapactityAnimation"] = CapactityAnimation.new(parent)
    self._animationMap["GetGoodsEffect"] = GetGoodsEffect.new(parent)
    self._animationMap["GetPropAnimation"] = GetPropAnimation.new(parent)
    self._animationMap["LevelUpAnimation"] = LevelUpAnimation.new(parent)
    self._animationMap["GuideRewardEffect"] = GuideRewardEffect.new(parent)
end

--通过class播放动画 playAnimationByClass
function AnimationFactory:playAnimationByName(name, data)
    logger:error("@@@@@@@@@@@播放特效@@@@@@@@@@@@@@@@name:%s@@@@", name)
    local animation = self._animationMap[name]
    animation:setData(data)
    animation:setGameState(self._gameState)
    animation:play()
end


