UIRewardWithAct = class("UIRewardWithAct")

UIRewardWithAct.INIT_Y = 495 -- 初始Y坐标
UIRewardWithAct.DIFF_X = 100 -- 间隔100
function UIRewardWithAct:ctor(parent, panel, isShow, callFunc)
    local layout = parent:getChildByName("mask")
    if layout == nil then
        layout = ccui.Layout:create()
        local winSize = cc.Director:getInstance():getWinSize()
        layout:setContentSize(winSize)
        layout:setPosition(cc.p(0, 0))
        layout:setBackGroundColor(cc.c3b(0, 0, 0))
        layout:setOpacity(104) -- 40%的透明度
        layout:setAnchorPoint(0, 0)
        layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
        layout:setName("mask")
        parent:addChild(layout)
        layout:setTouchEnabled(true)
    end
    self._layout = layout -- 遮罩层
    self._isShowBag = isShow
    -- 特效对象表
    self._ccbList = List.new()
    -- 图标对象表
    self._iconList = List.new()

end

function UIRewardWithAct:show(rewardData, targetPos)
    -- 清空表
    self._ccbList:clear() 
    self._iconList:clear()
    -- 图标个数
    self._itemCount = #rewardData 
    -- 加载特效但是不播放，占坑
    for i = 1 , self._itemCount do
        -- 先创建图标
        local sprite = cc.Sprite:create()
        sprite:setPosition( self:getShowPos(i, self._itemCount))

        self._layout:addChild(sprite)
        local icon = UIIcon.new(sprite, rewardData[i], true, self, _, true)
        icon:setScale(0.8) -- 配合特效的原始尺寸
        sprite:setVisible(false) -- 先隐藏
        self._iconList:pushBack(sprite)
        icon:setTouchEnabled(false) -- 不可点击
        local ccbLayer = self:addCcbInPos("rgb-huoquwupin", nil , sprite)
        ccbLayer:pause() -- 停住
        ccbLayer:setLocalZOrder(-1)
        self._ccbList:pushBack(ccbLayer)
    end
    -- 开始启动
    self:startAction(self._ccbList, self._iconList,self._itemCount, targetPos)
end

------
-- 返回一个特效
function UIRewardWithAct:addCcbInPos(name, pos , parent)
    local ccbLayer = UICCBLayer.new(name, parent, nil, nil, true) 
    ccbLayer:setPositionType(0)
    if pos then
        ccbLayer:setPosition(pos.x, pos.y)
    end

    return ccbLayer
end

------
-- 开始启动
function UIRewardWithAct:startAction(ccbList, iconList, itemCount, targetPos)
    local times = 0
    local function start()
        if times < itemCount then
            times = times + 1
            -- 开始动作并显示图标
            iconList:at(times):setVisible(true)
            ccbList:at(times):resume()
            iconList:at(times):stopAllActions()
            self:action(iconList:at(times), targetPos , times)
            TimerManager:addOnce(70, start, self) 

            AudioManager:playEffect("yx_item")
        else
            TimerManager:remove(start, self)
        end
    end
    start()
end

function UIRewardWithAct:action(sprite, targetPos, times)
    -- 第三阶段，调用删除
    local function step03(sprite, targetPos)
        local removeCall = cc.CallFunc:create(function()
            -- 是最后一个则调用finish
            if times == self._itemCount then
                self:finish(targetPos)
            end
        end)
        local seqAction = cc.Sequence:create( removeCall)
        sprite:runAction(seqAction)
    end
    -- 第二阶段，震动效果
    local function step02(sprite, targetPos)
        local action1 = cc.ScaleTo:create(0.06, 1.3)
        local action2 = cc.ScaleTo:create(0.06, 1)
        local action11 = cc.ScaleTo:create(0.04, 1.2)
        local action22 = cc.ScaleTo:create(0.04, 1)
        local action3 = cc.ScaleTo:create(0.02, 1.1)
        local action4 = cc.ScaleTo:create(0.02, 1)
        local action5 = cc.CallFunc:create(function()
            step03(sprite, targetPos) 
        end)
        local action6 = cc.Sequence:create(action1, action2,action11, action22, action3,action4, action5)
        sprite:runAction(action6)
    end
    -- 第一阶段，缩放渐显
    local function step01(sprite, targetPos)
        sprite:setScale(0.1)
        local action1 = cc.ScaleTo:create(0.1, 1)
        local action2 = cc.CallFunc:create(function()
            step02(sprite, targetPos) 
        end)
        local action3 = cc.Sequence:create(action1, action2)
        sprite:runAction(action3)
    end
    step01(sprite, targetPos)
end


-- itemCount 总个数
function UIRewardWithAct:getShowPos(i, itemCount, stepCount)
    local initY = UIRewardWithAct.INIT_Y -- 初始Y坐标
    local diffX = UIRewardWithAct.DIFF_X -- 间隔100

    stepCount = stepCount or 5 -- 每行个数
    local winSize = cc.Director:getInstance():getWinSize()

     -- 真实位置index
    local function getIp(index, stepCount)
        index = index%stepCount
        if index == 0 then
            index = stepCount
        end
        return index
    end
    
    -- 是不是最后一行
    local function getReamin(i, stepCount, itemCount) 
        local remain = itemCount - ( math.ceil(i/stepCount) - 1) * stepCount
        if remain <= stepCount then
            return remain
        else
            return false
        end
    end

    -- 算出中心点
    local function getPosX(index, stepCount, itemCount)
        local curCount = index
        local midPosX = winSize.width/2
        -- 获取真实位置index
        index = getIp(index, stepCount)
        -- 最后一行不足5个的时候做特殊处理
        local remain = getReamin(curCount, stepCount, itemCount) 
        if remain then
            stepCount = remain
        end
        -- 计算中间位置index
        local midIndex = (stepCount + 1)/2 
        -- 差量 = 真实位置index - 中点位置index
        local diffI = index - midIndex
        local posX = diffI*diffX + midPosX
        return posX
    end

    local posX = getPosX(i, stepCount, itemCount)
    local posY = initY - ( math.ceil(i/stepCount) - 1) * diffX
    return cc.p(posX, posY)
end

function UIRewardWithAct:finish(targetPos)
    local function stepFinish(sprite, targetPos, count)
        local delayAction = cc.DelayTime:create(0.5) -- 所有定住多久
        local moveTo00 = cc.MoveTo:create(0.3, self._layout:convertToNodeSpace(targetPos) )
        --print("move的目标为： "..targetPos.x.."||".. targetPos.y)
        local scaleAction = cc.ScaleTo:create(0.3, 0)

        local playAudio = cc.CallFunc:create( function()
                AudioManager:playEffect("TouchMarket")
            end
        )
        -- 组合缩放和移动
        local moveAndScale = cc.Spawn:create(moveTo00,scaleAction)
        local removeCall = cc.CallFunc:create(function()
            -- 加背包特效
            if self._isShowBag then
                local ccbLayer = self:addCcbInPos("rgb-huoquwuping-beibao", targetPos , self._layout)
                ccbLayer:setLocalZOrder(100)
            end
            -- 加载到最后一个
            if count == self._itemCount then
                local function delayRemove()
                    self._layout:removeFromParent() -- 直接全部清除
                    self.actionQueue:actionComplete()
                end
                TimerManager:addOnce(100, delayRemove, self)
            end
        end)
        local seqAction = cc.Sequence:create(delayAction, playAudio, moveAndScale, removeCall)
        sprite:runAction(seqAction)
    end

    local count = 0
    local function finish()
        if count < self._iconList:size() then
            count = count + 1
            stepFinish(self._iconList:at(count), targetPos, count)
            TimerManager:addOnce(70, finish, self)
        else
            TimerManager:remove(start, self)
        end
    end

    finish()
end
