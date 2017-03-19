-----------------------
--[[
通用二级弹窗背景控件

参数
panel:    点击弹窗关闭按钮时会关闭panel,默认值nil  
extra：   自定义关闭按钮的回调函数,默认值nil  
isTipBg ：true表示显示UITip弹窗的背景,默认值nil  

示例：
if extra ~= nil then
    self._closeBtnType = extra["closeBtnType"]  -- 0=隐藏panel 1=隐藏uiskin
    self._closeCallback = extra["callBack"]     -- 关闭按钮的回调
    self._obj = extra["obj"]       
end

接口：
UISecLvPanelBg:setTitle(title, isImg, color)    设置弹窗标题接口， isImg=true标题为图片
UISecLvPanelBg:setContentHeight(height)         设置弹窗高度接口
UISecLvPanelBg:hideCloseBtn(isShow)             设置弹窗关闭按钮可见性接口
UISecLvPanelBg:setBackGroundColorOpacity(opacity) 设置全屏遮罩透明度
]]

-------------------
UISecLvPanelBg = class("UISecLvPanelBg")

function UISecLvPanelBg:ctor(parent, panel, extra, isTipBg)
    local uiSkin = UISkin.new("UISecLvPanelBg")
    uiSkin:setParent(parent)
    uiSkin:setName("UISecLvPanelBg")
    self._panel = panel
    self._uiSkin = uiSkin


    self._mainPanel = uiSkin:getChildByName("mainPanel")
    self._frameTop = uiSkin:getChildByName("mainPanel/frameTop")
    self._frameMiddle = uiSkin:getChildByName("mainPanel/frameMiddle")
    self._frameBottom = uiSkin:getChildByName("mainPanel/frameBottom")
    
    self._nameTxt = self._frameTop:getChildByName("nameTxt")
    self._titleImg = self._frameTop:getChildByName("titleImg")

    self._mainPanel:setTouchEnabled(false)
    uiSkin:setTouchEnabled(false)

    
    local allFrames = {}
    allFrames[1] = self._frameTop
    allFrames[2] = self._frameMiddle
    allFrames[3] = self._frameBottom
    self._isTipBg = isTipBg or false
    
    self:setAliasTexParameters(self._isTipBg,allFrames)

    self._tileWidget = UITileWidget.new(self._frameMiddle)


    if extra ~= nil then
        self._closeBtnType = extra["closeBtnType"]  -- 0=隐藏panel 1=隐藏uiskin
        self._closeCallback = extra["callBack"]     -- 关闭按钮的回调
        self._obj = extra["obj"]       
    end

    self:registerEvents()
end

function UISecLvPanelBg:finalize()
    self._uiSkin:finalize()
end

function UISecLvPanelBg:setVisible(visible)
    self._uiSkin:setVisible(visible)
end

function UISecLvPanelBg:setIsShowName(isShow,content, isImg)
    if isShow == true then
        self._nameTxt:setVisible(true)
        self:setTitle(content, isImg)
    else
        self._nameTxt:setVisible(false)
        self._titleImg:setVisible(false)
    end
end

function UISecLvPanelBg:getCloseBtn()
    return self._frameTop:getChildByName("closeBtn")
end

function UISecLvPanelBg:setAliasTexParameters(isTipBg,allFrames)
    -- body
    local urlTab = {}
    -- 二级弹窗资源
    urlTab[1] = {   
        "images/guiScale9/Frame_top.png",
        "images/guiScale9/Frame_middle.png",
        "images/guiScale9/Frame_bottom.png",
    }
    --UItip弹窗资源
    urlTab[2] = {   
        "images/guiScale9/Frame_tip_top.png",
        "images/guiScale9/Frame_tip_middle.png",
        "images/guiScale9/Frame_tip_down.png",
    }
        
    local curUrlTab
    if isTipBg then
        curUrlTab = urlTab[2]
        self:setTitle("")           --tip弹窗标题为空
        self:hideCloseBtn(false)    --tip弹窗隐藏关闭按钮
    else
        curUrlTab = urlTab[1]
    end

    local texture
    for k,url in pairs(curUrlTab) do
        print("锯齿....set",k,url)
        texture = TextureManager:getUITexture(url)
        texture:setAliasTexParameters()
        TextureManager:updateImageView(allFrames[k],url)
    end

end

---[[
--设置背景高度，frameMiddle进行克隆平铺
---]]

function UISecLvPanelBg:setContentHeight(height)
    local sizeTop = self._frameTop:getContentSize()
    local sizeMiddle = self._frameMiddle:getContentSize()
    local sizeBottom = self._frameBottom:getContentSize()
    
    local tileHeight = height - sizeTop.height - sizeBottom.height
    self._tileWidget:setContentHeight(tileHeight)
    
    local tileY = self._tileWidget:getPositionY()
    
    self._frameTop:setPositionY(tileY + tileHeight / 2 + sizeTop.height / 2 )
    self._frameBottom:setPositionY(tileY - tileHeight / 2 - sizeBottom.height / 2)
    
    -- self:updateOtherPos()    
end

function UISecLvPanelBg:updateOtherPos()
    -- body
    local topX,topY = self._frameTop:getPosition()
    local sizeTop = self._frameTop:getContentSize()

    local closeBtn = self._frameTop:getChildByName("closeBtn")
    local closeSize = closeBtn:getContentSize()
    local nameSize = self._nameTxt:getContentSize()
    local nameImgSize = self._titleImg:getContentSize()
    closeBtn:setPositionX(topX + sizeTop.width/2 - closeSize.width)
    
    -- local visSize = cc.Director:getInstance():getVisibleSize()
    -- local winSize = cc.Director:getInstance():getWinSize()
    -- self._nameTxt:setPositionX(winSize.width/2 - nameSize.width/2)
    -- self._titleImg:setPositionX(topX - nameImgSize.width/2)

end

function UISecLvPanelBg:setTitle(title, isImg, color)
    
    local color = color or ColorUtils.wordOrangeColor
    self._nameTxt:setColor(color)
    self._nameTxt:setFontSize(24)
    
    self._nameTxt:setString(title)
    self._nameTxt:setVisible(true)
    self._titleImg:setVisible(false)
    if isImg == true then
        local url = string.format("images/titleIcon/%s.png", title)
        TextureManager:updateImageView(self._titleImg,url)
        self._titleImg:setVisible(true)
        self._nameTxt:setVisible(false)
    end
end

------------------------
function UISecLvPanelBg:registerEvents()
    local closeBtn = self._frameTop:getChildByName("closeBtn")
    closeBtn.type = self._closeBtnType or 0
    self:hideCloseBtn(true)
    ComponentUtils:addTouchEventListener(closeBtn, self.onCloseTouch, nil, self)
end

function UISecLvPanelBg:onCloseTouch(sender)
    if sender.type == 0 then
        self._panel:hide()
    else
        self._uiSkin:setVisible(false)
        self._closeCallback(self._obj)
    end
end

function UISecLvPanelBg:setBackGroundColorOpacity(opacity)
    opacity = opacity or 120
    self._uiSkin:setBackGroundColorOpacity(opacity)
end

function UISecLvPanelBg:hideCloseBtn(isShow)
    local closeBtn = self._frameTop:getChildByName("closeBtn")
    closeBtn:setVisible(isShow)
end

function UISecLvPanelBg:setLocalZOrder( order )
    -- body
    self._uiSkin:setLocalZOrder(order)
end

------
-- 获取此界面的MainPanel
function UISecLvPanelBg:getMainPanel()
    return self._mainPanel
end

function UISecLvPanelBg:setTouchEnabled(isTrue)
    -- body
    self._uiSkin:setTouchEnabled(isTrue)
end
