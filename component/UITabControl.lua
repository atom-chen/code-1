--[[
下：60
上：760
]]

UITabControl = class("UITabControl")

--changConditionFunc 切换标签的判断函数，return false则不能切换
function UITabControl:ctor(panel, changConditionFunc)
    local uiSkin = UISkin.new("UITab")
--    local bgImg = uiSkin:getChildByName("bgImg")
--    NodeUtils:adaptive(bgImg)
    local parent = panel:getParent()
    uiSkin:setParent(parent)
    
    panel:setTabControl(self)
    
    local function defaultChangeFunc(panelName)
        return true
    end
    
    self._changConditionFunc = changConditionFunc or defaultChangeFunc
    
    
    uiSkin:setTouchEnabled(false)
    self._uiSkin = uiSkin
    
    self._panel = panel
    self._tabItemList = {}
    self._tabItemIndexMap = {}
    
    self._index = 0
    self._tabsPanel = uiSkin:getChildByName("tabsPanel")
    -- self._tabItem1 = uiSkin:getChildByName("tabsPanel/tabItem")
    self._tabItem1 = self._tabsPanel:getChildByName("tabItem")
    self._tabItemParent = self._tabItem1:getParent()
    
    self.marge = 1
    self.width = self._tabItem1:getContentSize().width
    self.y = self._tabItem1:getPositionY()
    
    panel:setBgImg3Tab()
    
    local tabBg = uiSkin:getChildByName("tabBg")
    NodeUtils:adaptive(tabBg)
    
    self._tabBg = tabBg
    self._defaultSize = tabBg:getContentSize() --默认尺寸
    self._defaultPos = cc.p(tabBg:getPosition())

    
    -- 标签自适应
    NodeUtils:adaptiveTabs(self._tabsPanel, true)

end

--重置tab背景大小
function UITabControl:resetTabBgSize()
    self._tabBg:setContentSize(self._defaultSize)
    local scale = NodeUtils:getAdaptiveScale()
    self._tabBg:setPosition(self._defaultPos.x / scale, self._defaultPos.y )
    self:setDownLineStatus(false)
end

--设置背景的相对于下面的偏移量
function UITabControl:setDownOffset(downWidget)
    local scale = NodeUtils:getAdaptiveScale()
    
    local size = downWidget:getContentSize()
    local newSize = cc.size(self._defaultSize.width, self._defaultSize.height - size.height / scale)
    self._tabBg:setContentSize(newSize)
    
    
    self._tabBg:setPosition(self._defaultPos.x / scale, self._defaultPos.y + size.height / scale / 2 / scale)
    self:setDownLineStatus(true)
end

function UITabControl:setDownLineStatus(status)
    local tabBg = self._uiSkin:getChildByName("tabBg")
    local Image_1 = tabBg:getChildByName("Image_1")
    Image_1:setVisible(status)
end
----------------
--添加标签面板
function UITabControl:addTabPanel(name, content)
    self._index = self._index + 1
    self:insertTabItem(self._index, name, content)
end

function UITabControl:getCurPanelName()
    local data = self._tabItemList[self._curTabSelectIndex]
    return data.panelName
end

----------------------------------------------------------------------
function UITabControl:insertTabItem(index, name, content)
    self._tabItemIndexMap[name] = index
    local item = self["_tabItem" .. index]
    if item == nil then
        local newItem = self._tabItem1:clone()
        local preItem = self["_tabItem" .. (index - 1)]
        newItem:setPositionX(preItem:getPositionX() + self.width + self.marge)
        self._tabItemParent:addChild(newItem)
        
        self["_tabItem" .. index] = newItem
        item = newItem
    end
    
    local tabBtn1 = item:getChildByName("tabBtn1" )
    local tabBtn2 = item:getChildByName("tabBtn2" )
    local Image_tip = item:getChildByName("Image_tip" )
    -- local count = item:getChildByName("count" )
    tabBtn1.index = index
    tabBtn2.index = index
    Image_tip:setVisible(false)
    
    self:registerTabItemEvent(item)
    
    self:setTabContent(item, content)
    self._tabItemList[index] = {item = item, panelName = name}
end

function UITabControl:setItemCount(index,isShow,Count)
    if self._tabItemList[index] == nil then
        return
    end
    local Image_tip = self._tabItemList[index].item:getChildByName("Image_tip" )
    local count = Image_tip:getChildByName("count" )
    if isShow == true then
        Image_tip:setVisible(true)
        count:setString(tostring(Count))
        if Count == 0 then
            Image_tip:setVisible(false)
        end
    else
        Image_tip:setVisible(false)
    end
end

--这个只是用来设置选择的标签名称，设置默认Panel
function UITabControl:setTabSelectByName(name)
    local index = self._tabItemIndexMap[name]
    if index == nil then
        return false
    end

    self._panel:setDefaultTabPanelName(name)
    -- self:setTabSelect(index)
    
    return true
end

--切换至选择的标签
function UITabControl:changeTabSelectByName(name)
    local index = self._tabItemIndexMap[name]
    if index == nil then
        return false
    end

    local flag = self:setTabSelect(index)
    
    return flag
end

function UITabControl:updateTabName(panelName, content)
    local index = self._tabItemIndexMap[panelName]
    local data = self._tabItemList[index]
    self:setTabContent(data.item, content)
end

function UITabControl:getTabNameByIndex(index)
    local data = self._tabItemList[index]
    return data.panelName
end

function UITabControl:setTabSelect(index)
    
    if self._curTabSelectIndex == index then
        return false
    end
    
    -- -- 切换标签前先走回调
    if self._changConditionFunc ~= nil then
        local panelName = self:getTabNameByIndex(index)
        local oldPanelName
        if self._oldTabSelectIndex ~= nil then
            local oldData = self._tabItemList[self._oldTabSelectIndex]
            oldPanelName = oldData.panelName
        end
        if self._changConditionFunc(self._panel, panelName, oldPanelName) ~= true then --条件未满足，不可切换
            print("--条件未满足，不可切换到标签",panelName)
            return false
        end
    end
    
    if self._oldTabSelectIndex ~= nil then
        local oldData = self._tabItemList[self._oldTabSelectIndex]
        self:setTabState(oldData.item, false)
        local panel = self._panel:getPanel(oldData.panelName)
        if panel:isVisible() == true then
            panel:hideVisibleCallBack()
        end
        panel:hideCallBack()
        panel:hide()
    end
    
    local data = self._tabItemList[index]
    self:setTabState(data.item, true)
    local panel = self._panel:getPanel(data.panelName)
    panel:show()
    panel:setTouchEnabled(false)
    panel:onTabChangeEvent(self)
    
    self._curTabSelectIndex = index
    self._oldTabSelectIndex = index

    return true
end

-- 手动重置上次标签index
function UITabControl:setOldSelectIndex( index )
    -- body
    if self._oldTabSelectIndex ~= nil then
        local oldData = self._tabItemList[self._oldTabSelectIndex]
        self:setTabState(oldData.item, false)
        local panel = self._panel:getPanel(oldData.panelName)
        panel:hide()
    end

    self._oldTabSelectIndex = index
end

---------2----true为选择  false为不选择---1
function UITabControl:setTabState(tabItem, state)
    local tabBtn1 = tabItem:getChildByName("tabBtn1")
    local tabBtn2 = tabItem:getChildByName("tabBtn2")
    if state == true then
        tabBtn1:setVisible(false)
        tabBtn2:setVisible(true)
    else
        tabBtn1:setVisible(true)
        tabBtn2:setVisible(false)
    end
end

function UITabControl:setTabContent(item, content)
    for index=1, 2 do
        local tabBtn = item:getChildByName("tabBtn" .. index)
        tabBtn:setTitleText(content)
    end
end

function UITabControl:registerTabItemEvent(item)
    local tabBtn1 = item:getChildByName("tabBtn1" )
    local tabBtn2 = item:getChildByName("tabBtn2" )
    
    self._panel["tabBtn" .. tabBtn1.index] = tabBtn1
    
    tabBtn2:setVisible(false)
    ComponentUtils:addTouchEventListener(tabBtn1,self.onChangeTabTouch, nil, self, 50)
    ComponentUtils:addTouchEventListener(tabBtn2,self.onChangeTabTouch, nil, self, 50)
end

function UITabControl:onChangeTabTouch(sender)
    local index = sender.index
    
    if self._curTabSelectIndex ~= index then
        self:setTabSelect(index)
    end
end

function UITabControl:getTabsPanel()
    -- return self._uiSkin:getChildByName("tabsPanel")
    return self._tabsPanel
end

function UITabControl:setLocalZOrder(zOrder)
    self._uiSkin:setLocalZOrder(zOrder)
end

function UITabControl:getLocalZOrder()
    return self._uiSkin:getLocalZOrder()
end

-- 根据标签的索引设置标签的可见性
function UITabControl:setTabVisibleByIndex(index,isShow)
    if self._tabItemList[index] then
        local item = rawget(self._tabItemList[index],"item")
        if item then
            item:setVisible(isShow)
        end
    end
end

-- 根据标签的索引设置标签的图片
function UITabControl:setTabTexturesByIndex(index,normal,selected)
    if self._tabItemList[index] then
        local item = rawget(self._tabItemList[index],"item")
        if item then
            local tabBtn1 = item:getChildByName("tabBtn1" )
            local tabBtn2 = item:getChildByName("tabBtn2" )
            TextureManager:updateButtonNormal(tabBtn1,normal)
            TextureManager:updateButtonPressed(tabBtn1,selected)
            TextureManager:updateButtonNormal(tabBtn2,selected)
            TextureManager:updateButtonPressed(tabBtn2,normal)
        end
    end
end







