UIMessageBox = class("UIMessageBox") --对话框

function UIMessageBox:ctor(parent)
    self._localZOrder = 1000
    self._parent = parent

end

function UIMessageBox:finalize()
    if self._uiSkin ~= nil then
        self._uiSkin:finalize()
    end
end

function UIMessageBox:show(content, okCallback, canCelcallback, okBtnName,canelBtnName)
    if self._isOpen == true then
        return
    end
    
    okBtnName = okBtnName or TextWords:getTextWord(100)
    canelBtnName = canelBtnName or TextWords:getTextWord(101)
    self._isOpen = true 
    
--    self:delayShow(content, okCallback, canCelcallback,okBtnName,canelBtnName)
    TimerManager:addOnce(30, self.delayShow, self, content, okCallback, canCelcallback,okBtnName,canelBtnName)
end

function UIMessageBox:delayShow(content, okCallback, canCelcallback,okBtnName,canelBtnName)
    local uiSkin = UISkin.new("UIMessageBox")
    uiSkin:setParent(self._parent)
    
    self._uiSkin = uiSkin
    uiSkin:setLocalZOrder(self._localZOrder)

    --[[
    new一个二级背景,将messageBox的全部子节点clone到二级背景下，
    再删除messageBox的全部子节点    
    ]]
    --begin-------------------------------------------------------------------
    local secLvBg = UISecLvPanelBg.new(self._uiSkin:getRootNode(), self)
    secLvBg:setContentHeight(250)
    secLvBg:setTitle(TextWords:getTextWord(122))
    self._secLvBg = secLvBg
    secLvBg:hideCloseBtn(false)
    secLvBg:setLocalZOrder(self._localZOrder)

    local oldPanel = uiSkin:getChildByName("messagePanel")
    local mainPanel = secLvBg:getMainPanel()
    local panel = oldPanel:clone()
    panel:setName("panel")
    panel:setLocalZOrder(self._localZOrder)
    mainPanel:addChild(panel)
    oldPanel:setVisible(false)
    oldPanel:removeFromParent()
    --end-------------------------------------------------------------------
    

    panel = mainPanel:getChildByName("panel")    

    local contentTxt = panel:getChildByName("contentTxt")
    local cancelBtn = panel:getChildByName("cancelBtn")
    local okBtn = panel:getChildByName("okBtn")
    local middOkBtn = panel:getChildByName("middOkBtn")

    -- local contentTxt = uiSkin:getChildByName("panel/contentTxt")
    -- local cancelBtn = uiSkin:getChildByName("panel/cancelBtn")
    -- local okBtn = uiSkin:getChildByName("panel/okBtn")
    -- local middOkBtn = uiSkin:getChildByName("panel/middOkBtn")




    local isShow = true
    local noShow = false
    if okCallback == nil then
        isShow = false
        noShow = true
    end
    okBtn:setVisible(isShow)
    cancelBtn:setVisible(isShow)
    middOkBtn:setVisible(noShow)

    if self._panel ~= nil then
        self._panel["boxOkBtn"] = okBtn
    end
    local newInfoStr = StringUtils:getStringAddBackEnter(content ,20)

    contentTxt:setString(newInfoStr)
    
    okBtn:setTitleText(okBtnName)
    cancelBtn:setTitleText(canelBtnName)
    
    local function onOkClick(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self._isOpen = false
            AudioManager:playEffect("Button")
            if okCallback ~= nil then
                okCallback()
            end
            TimerManager:addOnce(30, self.delayRemove, self)
        end
    end
    self.okBtn = okBtn
    okBtn.touchCallback = onOkClick
    okBtn:setTouchEnabled(true)
    okBtn:addTouchEventListener(onOkClick)

    middOkBtn.touchCallback = onOkClick
    middOkBtn:setTouchEnabled(true)
    middOkBtn:addTouchEventListener(onOkClick)
    
    local function onCelcallClick(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self._isOpen = false
            AudioManager:playEffect("Button")
            if canCelcallback ~= nil then
                canCelcallback()
            end
            TimerManager:addOnce(30, self.delayRemove, self)
        end
    end
    cancelBtn:setTouchEnabled(true)
    cancelBtn:addTouchEventListener(onCelcallClick)
    
end

function UIMessageBox:getOkBtn()
    local okBtn = self._okBtn
    return okBtn
end

function UIMessageBox:setLocalZOrder(order)
    self._localZOrder = order
end

function UIMessageBox:delayRemove()
    self:finalize()
end

function UIMessageBox:setPanel(panel)
    self._panel = panel
end














