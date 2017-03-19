BasicPanel = class("BasicPanel")

---基础面板 
---isShowPanelBg:设置为true则为全屏背景
---isShowPanelBg:设置为数值，则为二级弹窗背景，且该数值为该背景的高度
---isTipBg:设置为true，表示显示tip样式弹窗
function BasicPanel:ctor(view, panelName, isShowPanelBg, parent, isTipBg)

    local parent = parent or view:getParent()
    
    self._bgContentHeight = 0
    if type(isShowPanelBg) == type(0) then --二级背景
        self._bgContentHeight = isShowPanelBg
        isShowPanelBg = true
    end
    self._panelName = panelName
    self._isShowPanelBg = isShowPanelBg
    self._isTipBg = isTipBg  --是否显示tip样式弹窗

    self._isInitUI = false
    
    self.view = view
    self.parent = parent
    
    self.tabControl = nil
    self.defaultTabPanelName = nil --默认的标签面板，如果外部没有强制跳转到某个标签，则跳转到这个

    self._listViewMap = {} --ListView集合，用来保存，做释放

    self._touchWidgetMap = {} --一个panel里面的触摸Widget，用来隐藏的时候进行屏蔽掉触摸事件，减少遍历

    self.isCheckFunction = true --是否检测方法的执行

    
    local srcMt =  getmetatable(self)  --实例的mt
    
    local mt = {}
    mt.__index = function(table, key)
        local value = rawget(table, key)
        if value == nil then
            value = srcMt[key]
        end
        local bvalue = BasicPanel[key]
        if bvalue == nil then  --这些方法是自定义的，一些是协议从外部调用的，需要判断这个Panel这个visible是否为true
            if type(value) == "function" and self.isCheckFunction == true then
                local isVisible = srcMt["isVisible"](self) 
                if isVisible ~= true and string.find(key,"OpenFun") == nil then  --tudo暂时就这样写
                    srcMt["emptyFunction"](self, srcMt.NAME, key) 
                    return srcMt["emptyFunction"]
                end
            end
        end
        return value
    end
    self._prePanel = nil
    setmetatable(self,mt)
   
end

function BasicPanel:emptyFunction(panelName, funName)
    logger:info("=======%s没展示，%s方法我不执行===========", panelName, funName)
end

--设置默认标签面板名称
function BasicPanel:setDefaultTabPanelName(panelName)
    self.defaultTabPanelName = panelName
end

--初始化UI，将其在show的时候才进行初始化
function BasicPanel:initUI(doLayoutHanlder)
    --self._panelName = self._panelName

    local function initHandler(skin)
        self._skin = skin
        if self._isShowPanelBg == true then
            local function onClosePanelHandler()
                self:onClosePanelHandler()
            end
            local children = self._skin:getRootNode():getChildren()
            for _,child in pairs(children) do
                local zorder = child:getLocalZOrder()
                if zorder == 0 then
                    child:setLocalZOrder(1)
                end
            end
            if self._bgContentHeight > 0 then

                self._uiPanelBg = UISecLvPanelBg.new(self._skin:getRootNode(), self, nil, self._isTipBg)
                self._uiPanelBg:setContentHeight(self._bgContentHeight)
                

            else
                self._uiPanelBg = UIPanelBg.new(self._skin:getRootNode(), onClosePanelHandler) -- 只有在这个条件下才有回调closeHanler关闭事件
            end
        end
    
        if self._isShowPanelBg == true then
            self._skin:setTouchEnabled(false)
        end

        if self._bgContentHeight > 0 then  --二次弹窗，以底为遮罩
            self._skin:setTouchEnabled(true)
        end
        
        self._isInitUI = true
    end
    
    self._skin = UISkin.new(self._panelName, initHandler, doLayoutHanlder, self:getModuleName())
    self._skin:setParent(self.parent)
    
end

function BasicPanel:startInitPanel()
    
    
    self:initPanel()
    self:registerEvents()

--    self:hide()
end

function BasicPanel:finalize()
    if self._isInitUI ~= true then
        return
    end

    self._isInitUI = false

    for _, listView in pairs(self._listViewMap) do
        ComponentUtils:finalizeExpandListView(listView)
    end
    if self._uiPanelBg ~= nil then
        self._uiPanelBg:finalize()
    end
    self._skin:finalize()
    self._skin = nil

    -- 应该把self下面的Key值都置空，防止一些ui引用还有进行逻辑，导致闪退
    for key, _ in pairs(self) do
        self[key] = nil
    end
end

function BasicPanel:initPanel()
    if self._uiPanelBg ~= nil then
        self._uiPanelBg:setIsShowName(false)
    end
end

function BasicPanel:registerEvents()

end

--tab标签切换时回调
function BasicPanel:onTabChangeEvent(tabControl, downWidget)
    if downWidget == nil then
        tabControl:resetTabBgSize()
    else
        tabControl:setDownOffset(downWidget)
    end
end

function BasicPanel:getPanel(name)
    return self.view:getPanel(name)
end

function BasicPanel:getParent()
    return self.parent
end

function BasicPanel:setTouchEnabled(bool)
    self._skin:setTouchEnabled(bool)
end

function BasicPanel:setEnabled(bool)
    self._skin:setEnabled(bool)
end

function BasicPanel:addChild(child)
    self._skin:addChild(child)
end

function BasicPanel:addChildToView(child)
    self.parent:addChild(child)
end

function BasicPanel:removeChild(child)
    self._skin:removeChild(child)
end

function BasicPanel:isInitUI()
    return self._isInitUI
end
--------------
function BasicPanel:getChildByName(name)
    return self._skin:getChildByName(name)
end
function BasicPanel:getSkin()
    return self._skin
end


function BasicPanel:show(data,panelName)
    
    self:addBlurSprite() -- 添加模糊精灵
    -- 调整非1层级
    if self._bgContentHeight > 0 then
        if self._skin ~= nil then
            local skinZOrder = self._skin:getLocalZOrder()
            if skinZOrder == 0 then
                self._skin:setLocalZOrder(1)
            end
        end
    end

    local isDelayShow = false
    if self._isInitUI ~= true then
        local function doLayout(skin)
            self._skin = skin
            self:doLayout()
        end

        self:initUI(doLayout)
        self:startInitPanel()
        
        isDelayShow = true
    end

    self._skin:setVisible(true)

    
    if self._uiPanelBg ~= nil then
        self._uiPanelBg:setVisible(true )
    end
    
    if self.expandTableView ~= nil then
        self.expandTableView:setVisible(true)
    end
--    if isDelayShow == true then
--        TimerManager:addOnce(60, self.delayShowPanel, self, data,panelName)
--    else
        self:delayShowPanel(data,panelName)
--    end

    if self._bgContentHeight > 0 then
        self:showAction()
    end
end

function BasicPanel:showAction(callback)
    self._skin:stopAllActions()
    local size = self._skin:getContentSize()
    local scale =  NodeUtils:getAdaptiveScale()
    -- 半透明背景坐标偏移的微调
    local tmp = math.abs(scale - 1)/6
    scale = math.abs(scale - tmp)
    
    self._skin:setPosition(size.width/2 * scale, size.height/2)
    self._skin:setAnchorPoint(cc.p(0.5,0.5))

    local function localcallback()
        if callback then
            callback()
        end
        
    end
    local function showBlurBg()
        
    end
    ----------------------------------
    self._skin:setScale(0)
    local action1 = cc.ScaleTo:create(GameConfig.TwoLevelShells.SHOW_TIME_01, GameConfig.TwoLevelShells.SCALE_01, GameConfig.TwoLevelShells.SCALE_01)
    local action2 = cc.ScaleTo:create(GameConfig.TwoLevelShells.SHOW_TIME_01, 1, 1)
    local action22 = cc.CallFunc:create( showBlurBg)
    action2 = cc.Sequence:create(action22, action2) 
    local action3 = cc.ScaleTo:create(GameConfig.TwoLevelShells.SHOW_TIME_02, GameConfig.TwoLevelShells.SCALE_02, GameConfig.TwoLevelShells.SCALE_02)
    local action4 = cc.ScaleTo:create(GameConfig.TwoLevelShells.SHOW_TIME_02, 1, 1)
    local action5 = cc.CallFunc:create(localcallback)
    local action6 = cc.Sequence:create( action1, action2, action3,action4, action5)
    self._skin:runAction(action6)
end


function BasicPanel:hideAction(callback)
    local function localcallback()
        if callback then
            callback()
        end
    end

    local function removeBlurBg()
        local blurSprite = self.parent:getChildByName("blur_sprite")
        if blurSprite then
            blurSprite:removeFromParent()
        end
    end

    local actionRemove = cc.CallFunc:create( removeBlurBg)

    local action1 = cc.ScaleTo:create(GameConfig.TwoLevelShells.CLOSE_TIME, GameConfig.TwoLevelShells.CLOSE_SCALE, GameConfig.TwoLevelShells.CLOSE_SCALE)
    
    
    action1 = cc.Sequence:create(actionRemove, action1) 
    local actionCallback = cc.CallFunc:create(localcallback)

    local action6 = cc.Sequence:create( action1, actionCallback)
    self._skin:runAction(action6)


end

function BasicPanel:delayShowPanel(data,panelName)
    self.view:showPanel(self._panelName)
    self:onShowHandler(data)

    if panelName ~= nil then
        local prePanel = self:getPanel(panelName)
        if prePanel:isInitUI() == true then
            self._prePanel = prePanel
            prePanel:hide()
        end
    end
end

-- UITabControl在切换panel时，关闭当前panel时会调用此接口，最后才调用hide()
-- 默认为空，什么也不做
-- 若有需要：此接口具体内容在模块的panel自定义即可
function BasicPanel:hideCallBack()
    -- body
end

-- UITabControl在切换panel时，判定当前panel:isVisible()==true时会调用此接口
function BasicPanel:hideVisibleCallBack()
    -- body
end

function BasicPanel:hide()
    if self._isInitUI ~= true then
        return
    end
    local function callback()
        self.view:hidePanel(self._panelName)
        self:onHideHandler()
        
        self._skin:setVisible(false)
        if self._uiPanelBg ~= nil then
            self._uiPanelBg:setVisible(false)
        end
        
        if self.expandTableView ~= nil then
            self.expandTableView:setVisible(false)
        end
    end
    if self._bgContentHeight > 0 then
        self:hideAction(callback)
    else
        callback()
    end
end

function BasicPanel:setBgImg3Full()
    self._uiPanelBg:setBgImg3Full()
end

function BasicPanel:setBgImg3Tab()
    self._uiPanelBg:setBgImg3Tab()
end

function BasicPanel:setBgType(type)
    self._uiPanelBg:setBgType(type)
end

--自适应方法调用
function BasicPanel:doLayout()
end

--打开时的处理
function BasicPanel:onShowHandler(data)
end

--模块动画结束后的逻辑处理
function BasicPanel:onAfterActionHandler(data)
end

function BasicPanel:onHideHandler()
end

--无限滚屏，打开的时候需要重新开启定时器
function BasicPanel:bgShow()
    if self._uiPanelBg ~= nil and type(self._uiPanelBg["show"]) == "function" then
        self._uiPanelBg:show()
    end 
end

--无限滚屏，停止背景的移动
function BasicPanel:stopBgMove()
    if self._uiPanelBg ~= nil then
        self._uiPanelBg:stopBgMove()
    end
end

function BasicPanel:addBgByUrl(url)
    local bg = TextureManager:createImageViewFile(url)
    self._skin:addChild(bg)
end

---------------列表渲染-------------------------
--listView 列表Widget
--infos 渲染的数据列表
--obj 回调Object
--rendercall 渲染的回调方法
--isFrame 当为数字时，表示初始化的时候，一次先渲染几条数据，后续逐帧渲染
--isInitAll 是否初始化就初始化全部
--cusMargin 自定义列表项间隔 px
function BasicPanel:renderListView(listView, infos, obj, rendercall, isFrame, isInitAll, cusMargin)
    self._listViewMap[listView] = listView
    listView.fromPanel = self
    ComponentUtils:renderListView(listView, infos, obj, rendercall, isFrame, isInitAll, cusMargin)
end

----添加触摸事件
--invalDelay 下一次可触发的间隔时间，单位毫秒
function BasicPanel:addTouchEventListener(widget, endedcallback, begancallback, obj, invalDelay, movecallback,bgFlicker, isNotPlaySound)
    obj = obj or self
    self._touchWidgetMap[widget] = widget
    ComponentUtils:addTouchEventListener(widget, endedcallback, begancallback, obj, invalDelay, movecallback,bgFlicker, isNotPlaySound)
end


-------创建UIMovieClip
------effectName 效果名
------delay 间隔时间
function BasicPanel:createUIMovieClip(effectName, delay)
    local movieChip = UIMovieClip.new(effectName, delay)
    movieChip:setModuleName(self:getModuleName())
    return movieChip
end


---@param ccbname ccbi名字
---@param parent  父容器
---@param owner   回调方法表
---@param completeFunc 完成回调方法,如果不为nil，则表示播放一次，辅助字段，默认为nil，
--                   如果为function，则该ccbi资源需要增加一个complete的callback,美术处理(处理方式，详见上面的注意)
--                   最终执行completeFunc回调，且默认会删除掉该实例资源
--@param isPlayOnce 是否播放一次，如果为true，则在complete回调的时候，同时删除掉资源
function BasicPanel:createUICCBLayer(ccbname, parent, owner, completeFunc, isPlayOnce)
    local moduleName = self:getModuleName()
    local ccb = UICCBLayer.new(ccbname, parent, owner, completeFunc, isPlayOnce, moduleName)
    return ccb
end

function BasicPanel:getProxy(name)
    return self.view:getProxy(name)
end

function BasicPanel:getModuleName()
    return self.view:getModuleName()
end

-------------------------------
function BasicPanel:onClosePanelHandler()
    if self._prePanel ~= nil then
        self._prePanel:show()
    end
end

function BasicPanel:onRefreshHandler()
end

-------------------------------------
function BasicPanel:dispatchEvent(event, data)
    self.view:dispatchEvent(event, data)
end

function BasicPanel:getTextWord(id)
    return TextWords:getTextWord(id)
end

function BasicPanel:showSysMessage(content, color, font)
    self.view:showSysMessage(content, color, font)
end

function BasicPanel:showMessageBox(content, okCallback, canCelcallback,okBtnName,canelBtnName)
    return self.view:showMessageBox(content, okCallback, canCelcallback,okBtnName,canelBtnName)
end

function BasicPanel:getLayer(uiLayerName)
    return self.view:getLayer(uiLayerName)
end

function BasicPanel:setTitle(isShow,content, isImg, exContent)
    self._uiPanelBg:setIsShowName(isShow,content, isImg, exContent)
end

function BasicPanel:setHtmlStr(htmlStr)
    self._uiPanelBg:setHtmlStr(htmlStr)
end

function BasicPanel:setLocalData(key, value, isGloble)
    self.view:setLocalData(key, value, isGloble)
end

function BasicPanel:getLocalData(key, isGloble)
    local ret = self.view:getLocalData(key, isGloble)
    return ret
end

function BasicPanel:getPanelRoot()
    return self._skin.root
end

function BasicPanel:update(dt)

end

function BasicPanel:isVisible()
    if self._isInitUI ~= true then
        return false
    end
    return self._skin:isVisible()
end

function BasicPanel:isModuleVisible()
    return self.view:isVisible()
end

--模块是否在动画中
function BasicPanel:isModuleRunAction()
    return self.view:isModuleRunAction()
end

function BasicPanel:getModulePanel(moduleName, panelName)
    return self.view:getModulePanel(moduleName, panelName)
end

function BasicPanel:setParentZOrder(order)
    self.parent:setLocalZOrder(order)
end

function BasicPanel:setLocalZOrder(order)
    self._skin:setLocalZOrder(order)
end

function BasicPanel:setLocalData(key, value, isGloble)
    LocalDBManager:setValueForKey(key, value, isGloble)
end

function BasicPanel:getLocalData(key, isGloble)
    local ret = LocalDBManager:getValueForKey(key, isGloble)
    return ret
end

function BasicPanel:initListView(listview)
    local item = listview:getItem(0)
    listview:setItemModel(item)
    item:setVisible(false)
    --listview.isInit = true
end

function BasicPanel:setVisible(visible)
    self._skin:setVisible(visible)
end

function BasicPanel:setCloseBtnStatus(isShow)
    local closeBtn = self._uiPanelBg:getCloseBtn()
    closeBtn:setVisible(isShow)
end

function BasicPanel:getCloseBtn()
    return self._uiPanelBg:getCloseBtn()
end

function BasicPanel:topAdaptivePanel()
    return self._uiPanelBg:topAdaptivePanel()
end

function BasicPanel:getBgTopY()
    local y = 0
    if self._uiPanelBg ~= nil then
        y = self._uiPanelBg:getBgTopY()
    end
    return y
end

----------------------
function BasicPanel:setTabControl(tabControl)
    self.tabControl = tabControl
end

function BasicPanel:getTabsPanel()
    local mainPanelName = self.view:getMainPanelName()
    if self._panelName ~= mainPanelName then
        local mainPanel = self:getPanel(mainPanelName)
        return mainPanel.tabControl:getTabsPanel()
    end
end

--切换标签
function BasicPanel:changeTabSelectByName(panelName)
    local flag = false
    if self.tabControl ~= nil then
        flag = self.tabControl:changeTabSelectByName(panelName)
    end
    return flag
end

--切换至，默认的标签中去
function BasicPanel:changeDefaultTabPanel()
    if self.defaultTabPanelName == nil then
        return
    end
    local panel = self:getPanel(self.defaultTabPanelName)
    if panel:isVisible() then
        panel:show()
    else
        local flag = self:changeTabSelectByName(self.defaultTabPanelName)
        if panel ~= nil and flag == false then
            panel:show()
        end
    end
end

---------------action---------------------
--
function BasicPanel:playAction(name, callback)
    ComponentUtils:playAction(self._panelName,name,callback)
end

function BasicPanel:stopAction(name)
    ComponentUtils:stopAction(self._panelName,name)
end

function BasicPanel:setBgPanelZorder(level)
    self._uiPanelBg:setLocalZOrder(level)
end

function BasicPanel:setNewbgImg3(downWidget, isShowDownLine)
    local downWidget = downWidget
    local function call()
        self._uiPanelBg:setNewbgImg3(downWidget, isShowDownLine)
    end
    TimerManager:addOnce(30, call, self)
end

function BasicPanel:adjustBootomBg(downWidget, upWidget,isHideBg,isShowDownLine)
    -- self._uiPanelBg:adjustBootomBg(downWidget, upWidget)
    local downWidget = downWidget
    local function call()
        self._uiPanelBg:adjustBootomBg(downWidget, upWidget,isHideBg,isShowDownLine)
    end
    TimerManager:addOnce(30, call, self)
end

function BasicPanel:setNewbgImg(param)
    local param = param
    local function call()
        self._uiPanelBg:setNewbgImg(param)
    end
    TimerManager:addOnce(30, call, self)
end

-- function BasicPanel:setBgScale()
--     -- body
--     local scale = NodeUtils:getAdaptiveScale()
--     self._uiPanelBg:setScale(scale)
-- end


------
-- 获取层名字
-- @param  
-- @return self._panelName [str] 层名
function BasicPanel:getSelfName()
    return self._panelName
end

function BasicPanel:onPanelSpecialShow()  --弹出的panel，层级需要提高
    local root = self:getPanelRoot()
    root:retain()
    root:removeFromParent()
    local gd = self:getParent():getParent()
    gd:addChild(root)
    root:release()
    root:setVisible(true)
    root:setLocalZOrder(10)
end

--设置全局的遮罩层
function BasicPanel:setMask(visible)
    self.view:setMask(visible)
end

function BasicPanel:setModuleVisible(module, visible)
    self.view:setModuleVisible(module, visible)
end

function BasicPanel:resetInitState()
    self.view:resetInitState()
end

-------------------------------------------------------------------------------
-- 模块的panel入场动画  start
-- 例如副本弹出布阵UI
-- self._runShowPanelAction = nil 时调用showPanelAction()
-------------------------------------------------------------------------------
-- 整个panel向右滑动的入场动画(跟module向右滑动入场效果一样)
function BasicPanel:showPanelAction()
    self._runShowPanelAction = true --正在动画中
    local dir = -1

    if  self._skin.srcX == nil then
        local srcX , srcY = self._skin:getPosition()
        self._skin.srcX = srcX
        self._skin.srcY = srcY
    end

    local x, y = self._skin.srcX, self._skin.srcY
    local scale = NodeUtils:getAdaptiveScale()
    self._skin:setPosition(x + 640 * dir, y)

    local function callback()
        self._runShowPanelAction = false  --动画播放完毕
        self:panelActionCallback()        --动画播放完毕回调
    end

    local function delayRunAction()
        local delayTime = 0.25
        local move = cc.MoveTo:create(0.2, cc.p(x,y))
        local afterAction = cc.Sequence:create(cc.DelayTime:create(delayTime),  cc.CallFunc:create(callback))
        local spawn = cc.Spawn:create(move, afterAction)
        self._skin:runAction(spawn)
    end
    delayRunAction()
end

function BasicPanel:isRunShowPanelAction()
    return self._runShowPanelAction
end

function BasicPanel:panelActionCallback()
end
-------------------------------------------------------------------------------
-- 模块的panel入场动画  end
------------------------------------------------------------------------------

-- 添加模糊精灵
function BasicPanel:addBlurSprite()
    if self._bgContentHeight > 0 then

        local blurSprite = self.parent:getChildByName("blur_sprite")
        if blurSprite then
            blurSprite:removeFromParent()
        end

        local winSize = cc.Director:getInstance():getWinSize()
        local renderTexture = NodeUtils:screenshot()
        local photoTexture = renderTexture:getSprite():getTexture()
        local blurSprite = cc.Sprite:createWithTexture(photoTexture)
        blurSprite:setPosition(winSize.width/2, winSize.height/2)
        blurSprite:visit()
        NodeUtils:nodeBlur(blurSprite)


        local render_texture1 = cc.RenderTexture:create(winSize.width, winSize.height)
        render_texture1:begin()
        blurSprite:visit() -- 获取
        render_texture1:endToLua()
        local photo_texture1 = render_texture1:getSprite():getTexture()
        local sprite_photo1 = cc.Sprite:createWithTexture(photo_texture1)
        

        blurSprite:removeFromParent()
        sprite_photo1:visit()
        self:addChildToView(sprite_photo1)
        sprite_photo1:setName("blur_sprite")
        sprite_photo1:setPosition(winSize.width/2, winSize.height/2)
    end

end
