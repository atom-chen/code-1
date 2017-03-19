UISysMessage = class("UISysMessage") --飘字

function UISysMessage:ctor(parent)
    local uiSkin = UISkin.new("UISysMessage")
    uiSkin:setParent(parent)
    uiSkin:setTouchEnabled(false)
    
    self.uiSkin = uiSkin
    
    self._sysMessageQueue = Queue.new()
    
    local mainPanel = uiSkin:getChildByName("mainPanel")
    for index=1, 1 do
        local sysMessage = mainPanel:getChildByName("SysMessage" .. index)
        sysMessage:setVisible(false)
        self._sysMessageQueue:push(sysMessage)
    end
    
    self._sysMessageDataQueue = Queue.new()
    
end

function UISysMessage:finalize()
    if  self._frameQueue ~= nil then
        self._frameQueue:finalize()
    end
    self._frameQueue = nil
    self.uiSkin:finalize()
end

function UISysMessage:show(content, color, font)
    local data = {content = content, color = color, font = font}
    
    local sysMessage = self._sysMessageQueue:pop()
    if sysMessage ~= nil then
        self:updateData(data, sysMessage)
    else
        self._sysMessageDataQueue:push(data)
    end
    
end

function UISysMessage:showQueueData()
    local isDataEmpty = self._sysMessageDataQueue:empty()
    local isSysEmpty =  self._sysMessageQueue:empty()
    if isDataEmpty ~= true and isSysEmpty ~= true then
        local data = self._sysMessageDataQueue:pop()
        local sysMessage =  self._sysMessageQueue:pop()
        self:updateData(data, sysMessage)
    end
end

function UISysMessage:updateData(data, sysMessage)
    local color = data.color
    local content = data.content
    local font = data.font
    
    color = color or ColorUtils.wordWhiteColor
    font = font or 20 
    
    local contentTxt = sysMessage:getChildByName("contentTxt")
--    contentTxt:setColor(color)
    contentTxt:setString(content or "")
    sysMessage:setVisible(true)
    
    local function callback()
        sysMessage:setVisible(false)
        self._sysMessageQueue:push(sysMessage) --归队
        self:showQueueData()
    end
    ComponentUtils:playAction("UISysMessage", "Message_amin1",callback)
    
--    sysMessage:setVisible(false)
--    sysMessage:setTouchEnabled(false)
--    local args = {}
--    args["sysMessage"] = sysMessage
--    self:pushEffectQueue(self, self.showAction, args)
    
end

function UISysMessage:showAction(args)

    local sysMessage = args["sysMessage"]
    local x, y = sysMessage:getPosition()
    sysMessage:setVisible(true)

    local function callback()
        sysMessage:setVisible(false)
        sysMessage:setPosition(x, y)
        self._sysMessageQueue:push(sysMessage) --归队

        self:showQueueData()
    end

    sysMessage:setOpacity(255)
    local move = cc.MoveTo:create(0.9, cc.p(x, y + 150))
    local alpha = cc.FadeTo:create(0.9, 100)
    local spawn = cc.Spawn:create(move, alpha)
    local action = cc.Sequence:create(cc.DelayTime:create(0.1) , spawn, cc.CallFunc:create(callback))
    sysMessage:runAction(action)
end

function UISysMessage:pushEffectQueue(obj, func, args)
    if self._frameQueue == nil then
        self._frameQueue = FrameQueue.new(0.5)
    end
    self._frameQueue:push({obj = obj, func =  func, args = args})
end










