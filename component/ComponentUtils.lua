ComponentUtils = {}

-- 添加输入框
function ComponentUtils:addEditeBox2(inputPanel, maxLength, placeHolder, isShowBox, returnCallback, bgurl)
    maxLength = maxLength or 10
    placeHolder = placeHolder or "请输入"
    bgurl = bgurl or "images/guiScale9/input.png"
    local size = inputPanel:getContentSize()
    local resFilename, rect = TextureManager:getTextureFile(bgurl)
    local editBox = cc.EditBox:create(size, cc.Scale9Sprite:create(resFilename, rect))
    editBox:setAnchorPoint(cc.p(0,0))
    --editBox:setPosition(10,10)
    editBox:setFontSize(20)
    editBox:setMaxLength(maxLength)
    editBox:setPlaceHolder(placeHolder)
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    inputPanel:addChild(editBox)
    
    if isShowBox ~= nil and isShowBox == false then
        editBox:setVisible(false)   --隐藏输入框
    else
        editBox:setVisible(true)   --显示输入框
    end
    
    if editBox.openKeyboard ~= nil then
        editBox:setEnabled(false)
    end
    local function onOpenKeyBorld(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if editBox.openKeyboard ~= nil then
                editBox:openKeyboard()
            end
        end
    end
    inputPanel:addTouchEventListener(onOpenKeyBorld)
    inputPanel:setTouchEnabled(true)

    self:editBoxFilterWorld(editBox, returnCallback)
    
    return editBox
end

-- 添加输入框
--todo逻辑不对  isFilterWorld 如果为false， returnCallback 参数便无效
function ComponentUtils:addEditeBox(inputPanel, maxLength, placeHolder, returnCallback, isFilterWorld, bgurl)
    maxLength = maxLength or 10
    placeHolder = placeHolder or "请输入"
    bgurl = bgurl or "images/guiScale9/input.png"
    -- bgurl = bgurl or "images/gui/Windows.png"
    local size = inputPanel:getContentSize()
    local resFilename, rect = TextureManager:getTextureFile(bgurl)
    local editBox = cc.EditBox:create(size, cc.Scale9Sprite:create(resFilename, rect))
    editBox:setAnchorPoint(cc.p(0,0))
    --editBox:setPosition(10,10)
    editBox:setFontSize(20)
    editBox:setMaxLength(maxLength)
    editBox:setPlaceHolder(placeHolder)
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    inputPanel:addChild(editBox)
    editBox:setName("editBox")
    if editBox.openKeyboard ~= nil then
        editBox:setEnabled(false)
    end
    local function onOpenKeyBorld(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if editBox.openKeyboard ~= nil then
                editBox:openKeyboard()
            end
        end
    end
    inputPanel:addTouchEventListener(onOpenKeyBorld)
    inputPanel:setTouchEnabled(true)

    if isFilterWorld ~= false then
        self:editBoxFilterWorld(editBox, returnCallback)
    end
    
    return editBox
end

--输入框过滤词
function ComponentUtils:editBoxFilterWorld(editBox, returnCallback)
    local function handler(event)
        if event == "return" then  
            local content =  editBox:getText()  
            content = FilterWordManager:wordFilter(content)
            editBox:setText( content ) 
            if returnCallback ~= nil then
                returnCallback()
            end
        end  
    end

    editBox:registerScriptEditBoxHandler(handler)
end

--@param widget 监听触摸事件的控件
--@param endedcallback 触摸结束回调，回到参数：obj, sender, value(额外值，目前只有新手用到), dir(触摸滑动方向) 0无滑动 1右滑动 -1左滑动
--@param begancallback 触摸开始回调
--@param obj
--@param invalDelay 下一次可触发的间隔时间，单位毫秒
--@param movecallback 移动回调, movePos控件的实时位置转本地坐标系传回去
--@param bgFlicker 点击是否闪烁 默认nil
--@param isNotPlaySound 是否不播放点击音效
function ComponentUtils:addTouchEventListener(widget, endedcallback, begancallback, obj, invalDelay, movecallback, bgFlicker, isNotPlaySound)
    if widget == nil or endedcallback == nil then
        logger:error("=====addTouchEventListener======widget=null==:%s=", debug.traceback())
        return
    end

    -- widget.tmpSetBright = widget.setBright
    -- widget.setBright = function(node , bright)
    --     NodeUtils:setEnable(node, bright)
    -- end
    
    isNotPlaySound = isNotPlaySound or false

    obj = obj or self
    local isDelay = true
    
    if self._endedcallbackMap == nil then
        self._endedcallbackMap = {}
    end

    if self._begancallbackMap == nil then
        self._begancallbackMap = {}
    end

    local widgetParent = widget:getParent()

    local beginPos = cc.p(0, 0)
    local dir = 0
    
    --TODO 一个endedCallback的间隔时间， 而不是一个widget的回调时间
    
    local function onTouchHandler(sender, eventType, value, notPlaySound)
        local resultValue = nil
        if eventType == ccui.TouchEventType.ended then
            -- print("~~~~~~~TouchEventType.ended~~~~~~~~~", self._endedcallbackMap[endedcallback])
            if self._endedcallbackMap[endedcallback] ~= nil then
                return
            end
            
            local endPos = sender:getTouchEndPosition()
            local lenx =  (beginPos.x - endPos.x) * (beginPos.x - endPos.x)
            local leny =  (beginPos.y - endPos.y) * (beginPos.y - endPos.y)
            local len = math.sqrt(lenx + leny)
    
            if len < 10 then --偏移量小的时候
                dir = 0
            else
                dir = endPos.x - beginPos.x > 0 and 1 or -1 
            end

            local function callback()
                if bgFlicker ~= nil then
                    widget:setColor(cc.c3b(255,255,255))
                    resultValue = endedcallback(obj, sender, value, dir)
                end
                self._endedcallbackMap[endedcallback] = nil
            end
            
            if bgFlicker ~= nil then
                local bgFlickerAction = cc.TintTo:create(0.1, GlobalConfig.hitBuildColor[1],GlobalConfig.hitBuildColor[2],GlobalConfig.hitBuildColor[3])
                local bgFlickerAction2 = cc.TintTo:create(0.1,255,255,255)   
                local action = cc.Sequence:create(bgFlickerAction, bgFlickerAction2)
                widget:runAction(action)
            end
            
            self._endedcallbackMap[endedcallback] = true
            
            if isNotPlaySound == false and notPlaySound ~= true then
                AudioManager:playEffect("Button")
            end
            
            local isAuto = false
            if type(invalDelay) ~= type(1) then
                invalDelay = 410
                isAuto = true
            end
            
            local curSendNetNum = GameConfig.curSendNetNum
            GameConfig.lastTouchTime = os.time()
            if endedcallback ~= nil then
                -- 有闪烁效果，先不执行callback
                if bgFlicker == nil then
                    resultValue = endedcallback(obj, sender, value, dir)
                end

                local nextSendNetNum = GameConfig.curSendNetNum
                local dtNum = nextSendNetNum - curSendNetNum
                if dtNum > 0 then
                else
                    if isAuto == true then
                        invalDelay = 100
                    end
                end
            end
            TimerManager:addOnce(invalDelay,callback, self) 
        elseif eventType == ccui.TouchEventType.moved then
            if movecallback ~= nil then
                local movePos = widget:getTouchMovePosition()
                if widgetParent ~= nil then
                    movePos = widgetParent:convertToNodeSpace(movePos)
                end
                widget.isMove = movecallback(obj, sender, movePos)
            end
        elseif eventType == ccui.TouchEventType.canceled then
            GameConfig.lastTouchTime = os.time()
            if widget.cancelCallback ~= nil then
                widget.cancelCallback(obj)
            end
        elseif eventType == ccui.TouchEventType.began then
            GameConfig.lastTouchTime = -1 --began不触摸事件
            beginPos = sender:getTouchBeganPosition()
            widget.isMove = nil
             
            if begancallback ~= nil then
                -- print("~~~~~~~~~~~~~~~~", self._begancallbackMap[begancallback])
                if self._begancallbackMap[begancallback] ~= nil then
                    return
                end

                local function callback22()
                    self._begancallbackMap[begancallback] = nil
                end
                invalDelay = invalDelay  or 100

                if begancallback ~= nil then
                    begancallback(obj, sender)
                end

                self._begancallbackMap[begancallback] = true

                TimerManager:addOnce(invalDelay,callback22, self) 
            end
        end
        return resultValue
    end
    
    widget.setCancelCallback = function(widget, callback)
        widget.cancelCallback = callback
    end

    widget:addTouchEventListener(onTouchHandler)
    widget:setTouchEnabled(true)
    widget.touchCallback = onTouchHandler
end

--条状进度条
function ComponentUtils:addProgressbar(loaderBar, url, delay)
    local delay = delay or 0.2
    local posx, posy = loaderBar:getPosition()
    local zOrder = loaderBar:getLocalZOrder()
    local parent = loaderBar:getParent()
    -- local size = loaderBar:getContentSize()
    local color = loaderBar:getColor()
    local opacity = loaderBar:getOpacity()

    local sprite = TextureManager:createSprite(url)
    local dir = loaderBar:getDirection()
    local ratePos = nil
    local midPoint = nil
    if dir == ccui.LoadingBarDirection.LEFT then
        -- 右向左进度条
        ratePos = cc.p(1, 0)
        midPoint = cc.p(0, 0)
--        print("···LoadingBarDirection.LEFT....") 
    else
        -- 左向右进度条
        ratePos = cc.p(1, 0) --TODO 位置验证
        midPoint = cc.p(1, 0)
--        print("···LoadingBarDirection.RIGHT...")
        sprite:setFlippedY(true)   --设置是否进行垂直翻转
    end
    
    loaderBar:setOpacity(0)
    parent:removeChild(loaderBar, true)

    local progressTimer = cc.ProgressTimer:create(sprite)
    progressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progressTimer:setMidpoint(midPoint)  --相当于设置锚点
    progressTimer:setBarChangeRate(ratePos)
    progressTimer:setPercentage(100)
    progressTimer:setPosition(posx, posy)
    progressTimer:setLocalZOrder(zOrder)
    parent:addChild(progressTimer)

    progressTimer:setColor(color)
    progressTimer:setOpacity(opacity)
    
    progressTimer.setPercent = function(obj, percent)
        local progressFrom = progressTimer:getPercentage()
        local to = cc.ProgressFromTo:create(delay, progressFrom, percent)
        progressTimer:runAction(to)
    end
    return progressTimer
end

--环状进度条
function ComponentUtils:addProgressbar2(loaderBar, url, percent, delay)
    local percent = percent or 0
    local delay = delay or nil
    local posx, posy = loaderBar:getPosition()
    local zOrder = loaderBar:getLocalZOrder()
    local parent = loaderBar:getParent()
    -- local color = loaderBar:getColor()
    -- local opacity = loaderBar:getOpacity()

    parent:removeChild(loaderBar, true)
    
    local ratePos = cc.p(1, 0)
    local midPoint = cc.p(0.5, 0.5)
    
    local sprite = TextureManager:createSprite(url)
    local progressTimer = cc.ProgressTimer:create(sprite)
    progressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    progressTimer:setMidpoint(midPoint)  --相当于设置锚点
    progressTimer:setBarChangeRate(ratePos)
    progressTimer:setPercentage(percent)
    progressTimer:setPosition(posx, posy)
    progressTimer:setLocalZOrder(zOrder)
    parent:addChild(progressTimer)

    -- progressTimer:setColor(color)
    -- progressTimer:setOpacity(opacity)
    
    progressTimer.setPercent = function(obj, percent)
        if delay == nil or delay == 0 then
            progressTimer:setPercentage(percent)
        else
            -- 进度条初始化动画
            local progressFrom = progressTimer:getPercentage()
            local to = cc.ProgressFromTo:create(delay, progressFrom, percent)
            progressTimer:runAction(to)
        end
    end
    
    return progressTimer
end

function ComponentUtils:insertListViewModel(model)
    if self._listViewModelList == nil then
        self._listViewModelList = {}
    end
    
    table.insert(self._listViewModelList, model)
end


function ComponentUtils:finalize()
    if self._listViewModelList ~= nil then
        for _, model in pairs(self._listViewModelList ) do
            model:release()
        end
    end

    -- if self._zhanliNum then
    --     self._zhanliNum:removeFromParent()
    --     self._zhanliNum = nil
    -- end
    
    self._listViewModelList = nil
    self:finalizeListViewItemPool()
    
    ComponentUtils:finalizeAction()
    
    self._endedcallbackMap = {}
    self._begancallbackMap = {}
end

--按分类渲染ListView
--tableInfos   type -> info
function ComponentUtils:renderTableListView(listView, typePanel, tableInfos, titleInfos, obj, rendercall)
    
    
    local infos = {}
    for type, infoList in pairs(tableInfos) do
        -- table.insert(infos, {type = type, listTypetitle = true})
        local titleInfo = clone(titleInfos[type])
        titleInfo.listTypetitle = true
        table.insert(infos, titleInfo)
        for _, info in pairs(infoList) do
            info.listTypetitle = false
            table.insert(infos,  clone(info) )
        end
    end
    
    for _, info in pairs(infos) do
        rawset(info,"isUpdate", true)
    end
    if listView.expandListView ~= nil then
        listView.expandListView:finalize() 
        listView.expandListView = nil
        listView.isInit = nil
--        listView:removeAllItems()
        local item = listView:getItem(0)
        while item ~= nil do
            -- ComponentUtils:pushListViewItemPool(listView,item,item.isCustom)
            listView:removeItem(0)
            item = listView:getItem(0)
        end
    end
    
    listView.infos = infos
    if listView.isInit ~= true then
        if listView.itemModel == nil then
            local item = listView:getItem(0)
            listView:setBounceEnabled(false)
            item:retain()
            listView:removeItem(0)
            listView.scrScale = item:getScale()

            self:insertListViewModel(item)

            listView.itemModel = item
            listView:setItemModel(item)
            item:setVisible(false)
            
            local jumpToTop = listView.jumpToTop
            
            local function delayJumpToTop()
                jumpToTop(listView)
            end
            
            listView.jumpToTop = function()
                delayJumpToTop()
                -- TimerManager:addOnce(30, delayJumpToTop,listView)
            end
        end
        
        listView.isInit = true

        local function updateData(xtile, ytile,delay)
            local infos = listView.infos
            local info = infos[ytile + 1]

            if info ~= nil then
                local isUpdate = rawget(info,"isUpdate")
                if isUpdate == false then --不用执行更新
                    return
                end

                local item = listView:getItem(ytile)
                if item == nil then
                    item = nil --ComponentUtils:popListViewItemPool(listView, info.listTypetitle)
                    if item == nil then
                        if info.listTypetitle == true then
                            local panel = typePanel:clone()
                            listView:pushBackCustomItem(panel)
                        else
                            listView:pushBackDefaultItem()
                        end
                    else
                        listView:pushBackCustomItem(item)
                    end
                    
                    item = listView:getItem(ytile)
                    item.isCustom = info.listTypetitle == true
                    item.listTypetitle = info.listTypetitle
                end
                
                --逻辑不会执行到
                if item.listTypetitle ~= info.listTypetitle then
                    --TODO 在Android上有问题
                    listView:removeItem(ytile)
                    local newItem = nil
                    if info.listTypetitle == true then
                        newItem = typePanel:clone()
                        newItem.isItemModel = false
                    else
                        newItem = listView.itemModel:clone()
                        newItem.isItemModel = true
                    end

                    listView:insertCustomItem(newItem, ytile)
                    
                    item = listView:getItem(ytile)
--                    logger:error("=====listTypetitle==diff=========")
--                    item = newItem
                end
                
--                print_r(info)
                item:setScale(listView.scrScale)
                item:setVisible(true)
                rawset(info,"isUpdate", false) --数据更新过了
                rendercall(obj, item, info, ytile)
                item.index = ytile
            end
        end
        listView.updateData = updateData
        local size = listView.itemModel:getContentSize()
        local expandListView = UIExpandListView.new(listView, size.width, size.height)
        expandListView:initListViewData(infos, nil, nil)

        listView.expandListView = expandListView
    else
        listView.expandListView:updateListViewData(infos)
    end


    local index = #infos
    --不会执行到的
    while listView:getItem(index) ~= nil do
        if #listView:getItems() == 1 then  --留一个
            local item = listView:getItem(0)
            item:setVisible(false)
            break
        end
        listView:removeItem(index)
    end 
    
end

--释放掉缓存数据
function ComponentUtils:finalizeListViewItemPool()
    local function release(itemPool)
        itemPool = itemPool or {}
        for _, item in pairs(itemPool) do
        	item:release()
        end
    end
    local listViewPool = self.listViewPool or {}
    for _, listView in pairs(listViewPool) do
        release(listView.itemPool)
        release(listView.itemCustomPool)
    end
end

function ComponentUtils:addListViewPool(listView)
    if self.listViewPool == nil then
        self.listViewPool = {}
    end
    table.insert(self.listViewPool,listView)
end

--获取池里面的个数
function ComponentUtils:getListViewItemPoolNum(listView)
    if listView.itemPool == nil then 
        return 0
    end
    return #listView.itemPool
end

--把要删除的Item入池
function ComponentUtils:pushListViewItemPool(listView, item, isCustom)
    if listView.itemPool == nil then
        listView.itemPool = {}
        self:addListViewPool(listView)
    end
    
    local itemPool = listView.itemPool
    if isCustom == true then
        if listView.itemCustomPool == nil then
            listView.itemCustomPool = {}
        end
        itemPool = listView.itemCustomPool
    end
    if item.isInPool == nil then
        item:retain()
        item.isInPool = true
    end
    table.insert(itemPool, item)
end

function ComponentUtils:popListViewItemPool(listView, isCustom)
    if listView.itemPool == nil then
        return nil
    end
    local itemPool = listView.itemPool
    if isCustom == true then
        if listView.itemCustomPool == nil then
            return nil
        end
        itemPool = listView.itemCustomPool
    end
    
    local item = table.remove(itemPool, 1)
    return item
end

-- 聊天预加载列表项条目 num=预加载的数目
function ComponentUtils:preLordChatItem(list,num)
    if list == nil or num == nil then
        return
    end
    
    local function renderPreLord(i)
        -- local list = self._worldListView
        local item = ComponentUtils:popListViewItemPool(list)
        if item ~= nil then
            list:pushBackCustomItem(item)
            -- print("-- 聊天预加载列表项条目",i)
        else
            list:pushBackDefaultItem()
            -- print("-- 聊天预加载列表项条目 尾插入",i)

            local item = list:getItem(i)
            if item == nil then
                item = list:getItem(0)
                item = item:clone()
            end
            ComponentUtils:pushListViewItemPool(list, item, false)
        end
    end
    for i=1,num do
        renderPreLord(i)
    end

end

---------------列表渲染-------------------------
--listView 列表Widget
--infos 渲染的数据列表
--obj 回调Object
--rendercall 渲染的回调方法
--isFrame 当为数字时，表示初始化的时候，一次先渲染几条数据，后续逐帧渲染
--isInitAll 是否初始化就初始化全部
--cusMargin 自定义列表项间隔 px
function ComponentUtils:renderListView(listView, infos, obj, rendercall, isFrame, isInitAll, cusMargin)

--    isFrame = false
    for _, info in pairs(infos) do
        rawset(info,"isUpdate", true)
    end
    listView.infos = infos
    if listView.isInit ~= true then
        local item = listView:getItem(0)
        listView:setBounceEnabled(false) 
        
        item:retain()
        listView:removeItem(0)
        listView.scrScale = item:getScale()

        -- 自定义列表间隔
        local margin = listView:getItemsMargin()
        if cusMargin then
                listView:setItemsMargin(cusMargin)
        else
            if margin < 6 then
                listView:setItemsMargin(6)
            end
        end
        
        self:insertListViewModel(item)
--        listView:getParent():addChild(item)
--        item:release()
        
        listView:setItemModel(item)
        listView.itemModel = item
        item:setVisible(false)
        listView.isInit = true
        
        local jumpToTop = listView.jumpToTop
        local function delayJumpToTop()
            jumpToTop(listView)
        end
        listView.jumpToTop = function()
            TimerManager:addOnce(30, delayJumpToTop,listView)
        end
        
        local function updateData(xtile, ytile,delay)
            local infos = listView.infos
            local info = infos[ytile + 1]
            
            if info ~= nil then
                local isUpdate = rawget(info,"isUpdate")
                if isUpdate == false then --不用执行更新
                    return
                end
                
                local item = listView:getItem(ytile)
                if item == nil then
                    item = nil --ComponentUtils:popListViewItemPool(listView)
                    if item ~= nil then
                        listView:pushBackCustomItem(item)
                    else
                        listView:pushBackDefaultItem()
                        item = listView:getItem(ytile)
                    end
                end
                item:setScale(listView.scrScale)
                item:setVisible(true)
                rawset(info,"isUpdate", false) --数据更新过了
                rendercall(obj, item, info, ytile)
                item.index = ytile
            end
        end
        listView.updateData = updateData
        local size = item:getContentSize()
        local expandListView = UIExpandListView.new(listView, size.width, size.height)
        expandListView:initListViewData(infos, nil, isFrame, isInitAll)
        
        listView.expandListView = expandListView
    else
        listView.expandListView:updateListViewData(infos)
    end
    
   
   --TODO 入池，而不是直接删掉
    local index = #infos
    while listView:getItem(index) ~= nil do
        if #listView:getItems() == 1 then  --留一个 防止只加一个时，快速拖动，导致的游戏崩溃问题
            local item = listView:getItem(0)
            item:setVisible(false)
            break
        end
        local item = listView:getItem(index)
        -- ComponentUtils:pushListViewItemPool(listView, item)
        
        listView:removeItem(index)
    end 
end

--释放掉ExpandListView，不然有问题
function ComponentUtils:finalizeExpandListView(listView)
    if listView.expandListView ~= nil then
        listView.expandListView:finalize()
    end
end

-----优化，渲染TableView-----------------------
function ComponentUtils:renderTableView(listView, infos, obj, rendercall, isNotReload)

    isNotReload = isNotReload or false
    for _, info in pairs(infos) do
        rawset(info,"isUpdate", true)
    end
    listView.infos = infos --以最后传入的infos数据为准
    if listView.isIniting == true then --正在初始化中，多调用了初始化接口
        return
    end
    
    listView:setVisible(false)
    listView.changeTableView = true
    listView.panel = obj
    
    if listView.isInit ~= true then
        local function updateData(item, info, idx)
--            print("=========updateData=============", idx)
--            if item.index ~= idx or rawget(info,"isUpdate") == true then
--                item.index = idx
--                rawset(info,"isUpdate", false)
--                item:resume()
                rendercall(obj, item, info, idx)
--            else
--                print("====不用更新=========", idx)
--            end
        end
        
        listView.jumpToTop = function()
            if listView.expandTableView ~= nil then
                listView.expandTableView:jumpToIndex(0)
            end
        end
        
        listView.isIniting = true

        self:delayInitTableView(listView, updateData)
        -- TimerManager:addOnce(60,self.delayInitTableView, self, listView, updateData)
        
    else
        listView.expandTableView:updateTableViewData(infos, isNotReload)
    end
end

--
function ComponentUtils:renderTableTableView(listView, titleWidget, tableInfos, titleInfos, obj, rendercall)
    local isNotReload =  false
    
    local infos = {}
    for type, infoList in pairs(tableInfos) do
        local titleInfo = (titleInfos[type])
        titleInfo.isTitleInfo = true
        table.insert(infos, titleInfo)
        for _, info in pairs(infoList) do
            info.isTitleInfo = false
            table.insert(infos,  (info) )
        end
    end
    
    for _, info in pairs(infos) do
        rawset(info,"isUpdate", true)
    end
    
    
    listView.infos = infos --以最后传入的infos数据为准
    if listView.isIniting == true then --正在初始化中，多调用了初始化接口
        return
    end

    listView:setVisible(false)
    listView.changeTableView = true
    listView.panel = obj

    if listView.isInit ~= true then
        local function updateData(item, info, idx)
            rendercall(obj, item, info, idx)
        end

        listView.jumpToTop = function()
            if listView.expandTableView ~= nil then
                listView.expandTableView:jumpToIndex(0)
            end
        end

        listView.isIniting = true
        self:delayInitTableView(listView, updateData, titleWidget)
        -- TimerManager:addOnce(60,self.delayInitTableView, self, listView, updateData, titleWidget)

    else
        local function call()
            listView.expandTableView:jumpToIndex(0)
            listView.expandTableView:updateTableViewData(infos, isNotReload)
        end

        call()
        -- TimerManager:addOnce(60,call,self)
    end
end

function ComponentUtils:delayInitTableView(listView, updateData, titleWidget)
    local infos = listView.infos
    listView.updateData = updateData
    local expandTableView = UIExpandTableView.new(listView, listView.panel, titleWidget)
    expandTableView:initTableViewData(infos)
    listView.expandTableView = expandTableView

    listView.isInit = true
    listView.isIniting = false
    
    listView.expandTableView = expandTableView
end

-----------------
--循环渲染列表
function ComponentUtils:renderUIListView(listView, infos, obj, rendercall)
    for _, info in pairs(infos) do
        rawset(info,"isUpdate", true)
    end
    listView.infos = infos
    if listView.isInit ~= true then
        local item = listView:getItem(0)
        listView:setBounceEnabled(false) 

        item:retain()
        listView:removeItem(0)
        listView.scrScale = item:getScale()

        self:insertListViewModel(item)

        listView:setItemModel(item)
        listView.itemModel = item
        item:setVisible(false)
        listView.isInit = true
        
        listView.jumpToTop = function()
--            listView.expandListView:jumpToTop()
        end

        local function updateData(item)
            local infos = listView.infos
            local ytile = item.index
            local info = infos[ytile + 1]

            if info ~= nil then
                local isUpdate = rawget(info,"isUpdate")
                if isUpdate == false then --不用执行更新
                    return
                end
                
                rawset(info,"isUpdate", false) --数据更新过了
                item:setVisible(true)
                rendercall(obj, item, info, ytile)
            else
                item:setVisible(false)
            end
        end
        listView.updateData = updateData
        local size = item:getContentSize()
        local expandListView = UIListView.new(listView, size.width, size.height)
        expandListView:initListViewData(infos)

        listView.expandListView = expandListView
    else
        listView.expandListView:updateListViewData(infos)
    end
end

--将listview中的某个index置顶
function ComponentUtils:setListViewItemIndex(listView, index, newIndex)
    if index == newIndex then
        return
    end
    local item = listView:getItem(index)
    item:retain()
    listView:removeItem(index)
    
    listView:insertCustomItem(item, newIndex)
    item:release()
    
    return item
end

--判断ListView是否移动到最底部
function ComponentUtils:isListViewInBottom(listView, callback ,obj)
    local container = listView:getInnerContainer()
    local size = container:getContentSize()
    local x, y = container:getPosition()
    
    if listView.isAddScrollView == nil and callback ~= nil then
        local function scrollViewEvent(sender, evenType)
            if evenType == ccui.ScrollviewEventType.scrollToBottom then
                callback(obj, 0)
            end
        end
        listView:addScrollViewEventListener(scrollViewEvent)
        
        listView.isAddScrollView = true
    end
    
    
    return y == 0 or size.height + y == 0
end

--处理滚动listView后，TouchEnd能够被捕捉到
--只限制在panel里面调用
function ComponentUtils:addListViewTouchEndEvent(listView, panel, touchEndCallback)
    local touchLayer = listView.touchLayer
    if touchLayer == nil then
        listView:setInertiaScrollEnabled(false)
        touchLayer = cc.Layer:create()
        listView:getParent():addChild(touchLayer)
        listView.touchLayer = touchLayer
        
        local function onTouchBegan(touch, event)
            return panel:isModuleVisible() == true 
        end
        
        local function onTouchEnd(touch, event)
--            if panel:isModuleVisible() ~= true then
--                return
--            end
            if touchEndCallback ~= nil then
                touchEndCallback(panel, listView)
            end
        end
        
        local eventDispatcher = touchLayer:getEventDispatcher()
        local touchOneByOneListener = cc.EventListenerTouchOneByOne:create()
        touchOneByOneListener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        touchOneByOneListener:registerScriptHandler(onTouchEnd,cc.Handler.EVENT_TOUCH_ENDED )
        eventDispatcher:addEventListenerWithSceneGraphPriority(touchOneByOneListener, touchLayer)
    end
end

--使用createRichNodeWithString创建富文本 需要注意事项：
--使用<br/>标签时不要单独出现，比如要放在<font/>里面（问题暂时未找），不然会出现崩溃
--获取多行的html格式，统一使用StringUtils:getHtmlByLines(lines)接口，不要去copy代码
--能少用该接口，则少用(慎用)
function ComponentUtils:createRichNodeWithString(htmlStr, size, clickCallback)
--    local label = cc.CCHTMLLabel:createWithString(htmlStr, size)
--    if clickCallback ~= nil then
--        label:registerLuaClickListener(clickCallback)
--    end
--    
--    local oldSetString = label.setString
--    
--    label.setString = function(label, str)
--        local str = string.format([[<font face = "fn18" color = "#eed6aa">%s</font>]], str)
--        oldSetString(label, str)
--    end
    local label = self:createRichLabel(htmlStr,size,clickCallback)
    
    return label
end

--type 1 格式 {content = , foneSize=, color=}
--type 2 格式 {content , foneSize, color}
function ComponentUtils:createRichLabel(htmlStr, size, clickCallback, contentType)
--    local labelMaxWidth = size.width
    contentType = contentType or 1
    size = size or 24
    local labelNode = cc.Node:create()
    labelNode:setAnchorPoint(0, 1)
    local function setString(lines)
        labelNode:removeAllChildren()
        if type(lines) ~= type({}) then
            return
        end
        local y = 0
        local maxWidth = 0
        local maxHeight = 0
        for _, line in pairs(lines) do
            local x = 0
            local maxH = 0
            local maxW = 0
            for _, value in pairs(line) do
                local content = ""
                local foneSize = 1
                local color = "#ffffff"
                if contentType == 1 then
                    content = value.content or ""
                    foneSize = value.foneSize or size
                    color = value.color or color
                else
                    content = value[1] or ""
                    foneSize = value[2] or size
                    color = value[3] or color
                end
                local label = ccui.Text:create()
                label:setAnchorPoint(cc.p(0, 1))
                label:setFontSize(foneSize)
                local content = string.gsub(content, "<br/>",  "\n")
                if string.find(content, "&#37;" ) ~= nil then
                    print("")
                end
                content = string.gsub(content, "&#37;",  "%%")
                label:setString(content)
                local color3b = ColorUtils:color16ToC3b(color)
                label:setColor(color3b)
                label:setPosition(x, y)
                labelNode:addChild(label)
                
                local size = label:getContentSize()
                x = x + size.width 
                if maxH < size.height then
                    maxH = size.height
                end
                maxW = maxW + size.width 
          end
            y = y - maxH
            if maxWidth < maxW then
                maxWidth = maxW
            end
            maxHeight = maxHeight + maxH
        end
        
        labelNode.width = maxWidth
        labelNode.height = maxHeight
        
    end
    
    local function getContentSize()
        return cc.size(labelNode.width, labelNode.height)
    end
    
    labelNode.setString = function (labelNode, lines)
        setString(lines)
    end
    
    labelNode.getContentSize = function (labelNode)
        return getContentSize()
    end
    

    
    return labelNode
end

-- 刷新坑位佣兵数量的显示内容 显示佣兵数量/显示武将名字
function ComponentUtils:updateSoliderPosCount(posPanel, num, color)
    color = color or cc.c3b(238,189,48)
    local team = posPanel
    local infoImg = team:getChildByName("infoImg")
    local count = infoImg:getChildByName("count")
    count:setString(num)
    count:setColor(color)
    -- team.name = num
    -- team.color = color
end

-- 刷新坑位底图 ：targetType=1 自己，targetType=2 敌人, isButton=1 按钮， isButton=2 图片
function ComponentUtils:updateSoliderPosImg(posPanel, targetType, isButton)
    isButton = isButton or 1 --默认是按钮
    local team = posPanel
    local url
    if targetType == 1 then
        url = "images/guiNew/teamNew22.png"
    else
        url = "images/guiNew/teamNew23.png"
    end

    if isButton == 1 then
        TextureManager:updateButtonNormal(team, url)
    else
        TextureManager:updateImageView(team,url)
    end

end

-- 佣兵坑位选中效果可见性
function ComponentUtils:setTeamSelectStatusByTeam(item,isShow)
    if item then
        local selectImg = item:getChildByName("selectImg")
        selectImg:setVisible(isShow)
    end
end

function ComponentUtils:updateSoliderPos(posPanel, id, num, dir, index, isUITeamDetail, isShowInfo, isShowAction, color)
    local configName = "ArmKindsConfig"
    dir = dir or 1
    local team = posPanel
    local dot = team:getChildByName("dot")
    local suoImg = team:getChildByName("suoImg")
    local infoImg = team:getChildByName("infoImg")
    local name = infoImg:getChildByName("name")
    local count = infoImg:getChildByName("count")
    local typeImg = infoImg:getChildByName("Image_94")
    
    local AtlasLabel = team:getChildByName("AtlasLabel")
    local isShowNum = dir == 1
    -- local isShowNum = dir
    
    color = color or cc.c3b(238,189,48) --数量的颜色
    count:setColor(color)
    -- team.color = color

    if index ~= nil then
        AtlasLabel:setString(index)  --坑位编号
    end

    if dot.srcPosY == nil then
        dot.srcPosY = dot:getPositionY()
        dot:setPositionY(dot.srcPosY + 30)  --模型偏移量Y
    end

    if AtlasLabel and AtlasLabel.srcPosY == nil then
        AtlasLabel.srcPosY = AtlasLabel:getPositionY()
        AtlasLabel.srcPosX = AtlasLabel:getPositionX()
        AtlasLabel:setPositionY(AtlasLabel.srcPosY + 0)  --数字标签偏移量Y
        AtlasLabel:setPositionX(AtlasLabel.srcPosX - 4)   --数字标签偏移量X
    end

    if infoImg and infoImg.srcPosY == nil then
        infoImg.srcPosY = infoImg:getPositionY()
        infoImg.srcPosX = infoImg:getPositionX()
        infoImg:setPositionY(infoImg.srcPosY + 0)   --信息偏移量Y
        infoImg:setPositionX(infoImg.srcPosX + 3)  --信息偏移量X
    end

--    if typeBg ~= nil and typeBg.srcPosY == nil then
--        typeBg.srcPosY = typeBg:getPositionY()
--        typeBg.srcPosX = typeBg:getPositionX()
--    end

    
    -- if AtlasLabel ~= nil then
    --     AtlasLabel:setPositionY(AtlasLabel.srcPosY + 0)  --数字标签偏移量Y
    --     AtlasLabel:setPositionX(AtlasLabel.srcPosX - 4)   --数字标签偏移量X
    -- end

    -- if infoImg ~= nil then
    --     infoImg:setPositionY(infoImg.srcPosY + 0)   --信息偏移量Y
    --     infoImg:setPositionX(infoImg.srcPosX + 3)  --信息偏移量X
    -- end

--    if typeBg ~= nil then
--        typeBg:setPositionY(typeBg.srcPosY - 9)  --圈 类型偏移量Y
--        typeBg:setPositionX(typeBg.srcPosX + 0)  --圈 类型偏移量X
--    end
    
    if id == nil or id <= 0 or num == 0 then
        infoImg:stopAllActions()
        dot:stopAllActions()

        team.isShowPuppet = false
        dot:setVisible(false)
        infoImg:setVisible(false)
        if isShowNum == true then
            if AtlasLabel ~= nil then
                AtlasLabel:setVisible(true)
            end
        end

        return
    end
    
    dot:setAnchorPoint(GlobalConfig.UISoldierAnchorPoint)
    dot:setVisible(true)
    infoImg:setVisible(true)
    team.isShowPuppet = true
    team.modeId = id
    --team.num = num
    
    if num ~= nil then
        count:setString(num)
        team.num = num
    else
        count:setString("")
        team.num = 0
    end
    
    --显示了佣兵，就不显示数字了
    if AtlasLabel ~= nil then
        AtlasLabel:setVisible(false)
    end

    
    local typePath
    local typeLevelPath
    if isUITeamDetail ~= nil then  --UITeamDetailPanel 副本布阵UI
        -- team:setScale(0.9)  --整个坑缩放
        name:setVisible(false)
        -- count:setColor(ColorUtils.wordWhiteColor)
        
        typePath = "images/guiNew/Icon_bg_level%d.png"
        typeLevelPath = "images/guiNew/Icon_level%d.png"        
    else
        typePath = "images/gui/Txt_%d.png"
        typeLevelPath = nil
        
    end
    
    if dot.url ~= id then
        dot.url = id
        local info = ConfigDataManager:getInfoFindByOneKey(configName,"ID",id)
        
        TextureManager:onUpdateSoldierImg(dot,id)
        
        name:setString(info.name)
        name:setColor(ColorUtils:getColorByQuality(info.color))
        
        if typeImg ~= nil then
            local url = string.format(typePath, info.type)
            TextureManager:updateImageView(typeImg, url)
        end
        
        local typeLevelImg = infoImg:getChildByName("typeLVImg")
        if typeLevelImg ~= nil and typeLevelPath ~= nil then
            local typeLevel = id % 100
            local url = string.format(typeLevelPath, typeLevel)
            TextureManager:updateImageView(typeLevelImg, url)
        end

    end

    -- dot:setScaleX(dir)

    if typeImg ~= nil then
        typeImg:setVisible(true)
    end

    -- isShowInfo = isShowInfo or nil
    if isShowInfo ~= nil then
        print("isShowInfo 00")
        infoImg:setVisible(isShowInfo)
    end

    -- isShowInfo = isShowInfo or nil
    if isShowInfo ~= nil then
        print("isShowInfo 11")
        suoImg:setVisible(isShowInfo)
    end

    if isShowAction == true then  --需要执行执行动画


        if infoImg.srcPos == nil then
            infoImg.srcPos = cc.p(infoImg:getPosition())
        end

        if dot.srcPos == nil then
            dot.srcPos = cc.p(dot:getPosition())
        end

        infoImg:stopAllActions()
        dot:stopAllActions()
        infoImg:setVisible(false)

        local function moveEnd()
            infoImg:setVisible(true)
            infoImg:setOpacity(0)

            local fadeTo = cc.FadeTo:create(0.2, 255)
            infoImg:runAction(fadeTo)

            local ccb = UICCBLayer.new("rpg-buzheng", infoImg, nil, nil, true)
            ccb:setPosition(40, 10)
        end
        
        local srcPos = dot.srcPos
        dot:setPositionX(srcPos.x - 30)
        local action = cc.MoveTo:create(0.2, srcPos)
        dot:runAction(cc.Sequence:create(action, cc.CallFunc:create(moveEnd)))
    end

end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--军师信息显示接口
--[[
    -- 数据结构
    -- local consuData = {}
    -- consuData.icon = 军师图片 (0显示默认军师图片，999显示空图)
    -- consuData.name = 军师名字
    -- consuData.quality = 军师品质
    -- consuData.starNo = 星数
    -- consuData.infoImgShow = 是否显示军师信息
]]
function ComponentUtils:updateConsuPos(consuPanel,data)
    if consuPanel == nil or data == nil then
        logger:error("....ComponentUtils:updateConsuPos(consuPanel,data) 军师显示数据有误")
        return
    end

    local dot = consuPanel:getChildByName("dot")
    local suoImg = consuPanel:getChildByName("suoImg")
    local infoImg = consuPanel:getChildByName("infoImg")
    local count = infoImg:getChildByName("count")
    local starNum = infoImg:getChildByName("starNum")
    local starIcon = infoImg:getChildByName("starIcon")

    -- 图标
    if rawget(data,"icon") ~= nil then
        local url = string.format("images/consigliereIcon/%d.png",data.icon)
        TextureManager:updateImageView(dot,url)
    end
    -- 名字
    if rawget(data,"name") ~= nil then
        count:setString(data.name)

        -- 名字颜色
        local quality = rawget(data,"quality")
        local color = ColorUtils:getColorByQuality(quality)
        count:setColor(color)
    end
    -- 星数
    if rawget(data,"starNo") ~= nil then
        local starNo = data.starNo
        local url = string.format("images/component/num_%d.png",starNo)
        TextureManager:updateImageView(starNum,url)

        -- 名字的坐标
        if starNo == 0 then
            if count.initX == nil then
                count.initX = count:getPositionX()
            end
            count:setPositionX(count.initX - 12)
        else
            if count.initX then
                count:setPositionX(count.initX)
            end
        end
        starIcon:setVisible(starNo ~= 0)
        starNum:setVisible(starNo ~= 0)
    end
    
    -- 可见性
    if rawget(data,"infoImgShow") ~= nil then
        infoImg:setVisible(data.infoImgShow)
    end
    if rawget(data,"suoImgShow") ~= nil then
        suoImg:setVisible(data.suoImgShow)
    end
end
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

------------url----------------------------------------------------------------
function ComponentUtils:getUrlByPowerAndID(power, typeid)
    local info = ConfigDataManager:getConfigByPowerAndID(power, typeid)
    local url = string.format("images/%s/%d.png", info.iconFolder, typeid)
    return url
end

--获取世界的建筑URL
function ComponentUtils:getWorldBuildingUrl(buildIcon,isRes)
    local url
    if isRes == nil then
        url = string.format("images/map/building%02d.png", buildIcon)
    else
        url = string.format("images/map/res%d.png", buildIcon)
    end 
    return url
end

--获取英雄图鉴 包括经验书
function ComponentUtils:getHeroPortraitUrl(heroId)
    local config = ConfigDataManager:getConfigById(ConfigData.HeroConfig, heroId)
    local miniList = {1, 2, 8, 24, 101}
    local url = nil
    if table.indexOf(miniList, config.icon) >= 0 then
        url = string.format("bg/portrait/heroMini/%d.pvr.ccz", config.icon)
    else
        local isFileExist = cc.FileUtils:getInstance():isFileExist("bg/portrait/hero/3.pvr.ccz")
        if isFileExist then
            url = string.format("bg/portrait/hero/%d.pvr.ccz", config.icon)
        else
            if heroId >= 101 then
                url = "bg/portrait/heroMini/101.pvr.ccz"
            else
                url = "bg/portrait/heroMini/1.pvr.ccz"
            end
        end
    end
    
    return url
end

--获取宝具小图标url
function ComponentUtils:getTreasureIconImgUrl(typeid)
    local  config = ConfigDataManager:getConfigById(ConfigData.TreasureBaseConfig, typeid)
    local url = "images/heroTreasureIcon/" .. config.icon .. ".png"
    return url
end
--获取宝具高级(洗炼)属性图标url
function ComponentUtils:getTreasureHighAttImgUrl(typeid)

    return string.format("images/heroTreasureIcon/high_%d.png", typeid)

end

----------------action---------------
function ComponentUtils:playAction(panelName, name, callback)
    local action = self:getActionByName(panelName, name)
    if action ~= nil then
        if callback ~= nil then
            local callFunc = cc.CallFunc:create(callback)
            action:play(callFunc)
        else
            action:play()
        end

        return true
    else
        logger:warn("=========找不到动画数据:%s===========", name)
        return false
    end
end

function ComponentUtils:stopAction(panelName, name)
    local action = self:getActionByName(panelName, name)
    if action ~= nil then
        action:stop()
    end
end

function ComponentUtils:getActionByName(panelName, name)
    local jsonName = panelName .. ".ExportJson"
    local action = ccs.ActionManagerEx:getInstance():getActionByName(jsonName, name)
    return action
end

function ComponentUtils:releaseAction(panelName)
    local jsonName = panelName .. ".ExportJson"
    ccs.ActionManagerEx:getInstance():releaseAction(jsonName)
end

---------------------------------
--TODO 增加下划线
function ComponentUtils:drawLine(widget)
    local drawNode = cc.DrawNode:create()
    
    local x, y = widget:getPosition()
    local size = widget:getContentSize()
    
--    local startPos = cc.p(float,float)
--    drawNode:drawSegment(vec2,vec2,float,color4f)
end

-----------------------------------------
--角色信息变化效果
function ComponentUtils:roleInfoDifEffect(roleProxy, diff)
    local typeid = diff.typeid
    local oldValue = roleProxy:getRoleAttrValue(diff.typeid)
    -- 计算战力变更差值
    local dt = diff.value - oldValue
--    if diff.showValue > 0 then
--        dt = diff.showValue
--    end
    --or (diff.showValue <= 0 and 
--      typeid == PlayerPowerDefine.POWER_exp)
    if dt == 0  then
--        logger:error("!!!!!竟然属性没改变也发送通知!!!!!!:%d", typeid)
        return
    end
    if  typeid == PlayerPowerDefine.POWER_highestCapacity then
        -- 战力提升触发
        local params = {}
        params.dt = dt
        params.fightingVar = diff.value
        params.fightingOldVar = oldValue

        AnimationFactory:playAnimationByName("CapactityAnimation", params)
    elseif typeid == PlayerPowerDefine.POWER_exp then
--        self:showGetExpAction(roleProxy, dt, 200,480)
    -- elseif typeid == PlayerPowerDefine.POWER_energy and dt > 0 then
    --     self:showAddEnergyAction(roleProxy, dt, 200,480)
    elseif typeid == PlayerPowerDefine.POWER_level then
        AnimationFactory:playAnimationByName("LevelUpAnimation", {})
    end
end

function ComponentUtils:finalizeAction()
    self._uiLvActionQueue = nil
    self._lvUpPanel = nil
    
    self._infoQueue = nil
    self._playLevelAction = nil
end


--获取经验动画，需要计算等级与经验的差值
function ComponentUtils:showGetExpAction(roleProxy, data)

    local difExpValue = nil
    local difLevelValue = nil
    local diffs = data.diffs
    for _, diff in pairs(diffs) do
    	if diff.typeid == PlayerPowerDefine.POWER_exp then
    	    difExpValue = diff.value
    	end
    	
        if diff.typeid == PlayerPowerDefine.POWER_level then
            difLevelValue = diff.value
        end
    end
    
    if difExpValue == nil then
        return
    end
    
    local x, y = 200,480
    
    local oldValue = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_exp)
    local dt = difExpValue - oldValue
    if dt <= 0 and difLevelValue == nil then
        logger:error("=====经验没变=等级没变==power也发==:%d===", dt)
        return
    end
    
    local num = 0
    if difLevelValue == nil then --没有升级
        num = dt
    else --有等级差了，要算出真正的dt
        local oldLevel = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_level)
        local newLevel = difLevelValue
        
        local maxExp = 0
        for level=oldLevel, newLevel - 1 do
            local info = ConfigDataManager:getInfoFindByOneKey(ConfigData.CommanderConfig,
                "leve",level)
            maxExp = maxExp + info.exp
        end
        
        num = (maxExp + difExpValue) - oldValue
    end

    if num == nil then
        logger:error("经验变化的量为nil")
        return
    elseif num <= 0 then
        logger:error("经验变化的量为:%d",num)
        return
    end
    
    local function showGetRewardAction()
        local node = cc.Node:create()
        local expImg = TextureManager:createImageView("images/gui/bg_exp.png")
        expImg:setAnchorPoint(cc.p(0, 0.5))
        node:addChild(expImg)
        local numTxt = ccui.Text:create()
        numTxt:setAnchorPoint(cc.p(0, 0.5))
        local str = string.format("+%d", num)
        numTxt:setString(str)
        numTxt:setFontSize(RewardActionConfig.FONT_SIZE)
        node:addChild(numTxt)
        numTxt:setPosition(RewardActionConfig.EXP_X + RewardActionConfig.DISTANCE,0)
        numTxt:setColor(ColorUtils.wordGreenColor)
        local layer = roleProxy:getCurGameLayer(GameLayer.popLayer)
        layer:addChild(node)
        node:setPosition(x, y)
        self:showGetRewardAction(node)
    end
    
    if GuideManager:isStartGuide() == true then
        local temp = {}
        TimerManager:addOnce(GameConfig.guideParams.DELAY_FLY_TIME,showGetRewardAction, temp)
    else
        showGetRewardAction()
    end
    
end

-- 飘字体力+xxx
function ComponentUtils:showAddEnergyAction(roleProxy, num, x, y)
    local node = cc.Node:create()

    local expImg = TextureManager:createImageView("images/common/word_exp.png")
    expImg:setAnchorPoint(cc.p(0, 0.5))
    node:addChild(expImg)
    
    local exp_plus = TextureManager:createImageView("images/common/exp_plus.png")
    exp_plus:setAnchorPoint(cc.p(0, 0.5))
    exp_plus:setPosition(62,0)
    node:addChild(exp_plus)
    
    local numTxt = ccui.TextAtlas:create()
    numTxt:setAnchorPoint(cc.p(0, 0.5))
    numTxt:setProperty("1234567890", "ui/images/fonts/num_exp_plus.png", 18, 27, "0")
    node:addChild(numTxt)
    numTxt:setPosition(82,0)
    numTxt:setString(num)
    
    local layer = roleProxy:getCurGameLayer(GameLayer.popLayer)
    layer:addChild(node)
    node:setPosition(x, y)

    local function call()
        self:showGetRewardAction(node)
    end
    -- TimerManager:addOnce(60,call,self)
    call()
end

function ComponentUtils:showGetRewardAction(node)
    local function callback()
        node:removeFromParent()
    end
    local x, y = node:getPosition()

    local action = cc.MoveTo:create(RewardActionConfig.FLY_TIME, cc.p(x, y + RewardActionConfig.FLY_HIGHT))
    node:runAction(cc.Sequence:create(action, cc.CallFunc:create(callback)))
end


function ComponentUtils:showNotice(roleProxy,data, showNoticeCallback)
    if data == nil or data.name == nil then
        if showNoticeCallback ~= nil then
            showNoticeCallback()
        end
        return
    end
    print("data.type===",data.type)
    local node = cc.Node:create()
    node:setScale(1 / NodeUtils:getAdaptiveScale())
    node:setPosition(100,820)
    local hornUrl,hornImg,bgUrl

    local function playAction(ccbi)
        self.btnEffect1 = UICCBLayer.new(ccbi, node)
        self.btnEffect1:setPosition(250,0)
    end

    if data.type == 3361 then
        bgUrl = string.format("images/especialGoodsUse/bg%d.png", data.type)
        local bg = TextureManager:createImageView(bgUrl)
        bg:setContentSize(cc.size(400,405))
        bg:setAnchorPoint(cc.p(0, 0.5))
        bg:setPosition(-20,0)
        node:addChild(bg)

    --喇叭的动画
    elseif data.type == 3362 then
        playAction("rpg-zimu-xin")
    elseif data.type == 3363 then
        playAction("rpg-zhimu-laba")
    elseif data.type == 3364 then
        playAction("rpg-zimu-dangao")
    end

    local layer = roleProxy:getCurGameLayer(GameLayer.popLayer)
    layer:addChild(node)

    local clippingNode = cc.ClippingNode:create()
    clippingNode:setInverted(false)
    clippingNode:setPosition(cc.p(300,840))
    clippingNode:setAlphaThreshold(0.0)

    local textName =  ccui.Text:create()
    textName:setAnchorPoint(cc.p(0, 1))
    textName:setColor(ColorUtils.wordGreenColor)
    textName:setFontSize(20)
    textName:setString(data.name..":")
    textName:setPosition(cc.p(40,15))
    textName:setVisible(false)
    node:addChild(textName)

    local xxxx = textName:getContentSize()
    local eneen = textName:getPosition()

    clippingNode:setPositionX(300 - xxxx.width)

    local sprite = TextureManager:createSprite("images/common/uiBg_4.png")  --"images/common/image210.png"
    sprite:setAnchorPoint(0,1)
    sprite:setScaleX(4.9)
    sprite:setPosition(-160+xxxx.width,-8)
    clippingNode:setStencil(sprite)
    layer:addChild(clippingNode)
    
    local content = ccui.Text:create()
    content:setColor(ColorUtils.wordWhiteColor)
    content:setAnchorPoint(cc.p(0, 1))
    content:setFontSize(20)
    
    content:setPosition(cc.p(eneen+xxxx.width-200,-8))
    content:setString(data.name..":"..data.mess)
    clippingNode:addChild(content)
    self.content = content
    self.node = node
    self.makeMove = 0
    self.clippingNode = clippingNode
    TimerManager:addOnce(3000, self.onUpdate, self, showNoticeCallback)
    
    -- local function callback()
    --     content:setString("")
    --     node:removeFromParent()
    -- end
    -- local x, y = content:getPosition()
    -- local action = cc.MoveTo:create(10,cc.p(x-1200, y))
    -- content:runAction(cc.Sequence:create(action, cc.CallFunc:create(callback)))
end

function ComponentUtils:onUpdate(showNoticeCallback)
--    self.makeMove = self.makeMove + 1
--    if self.makeMove == 3 then
    self:moveText(showNoticeCallback)
--        self:onCloseTimerOpenFun()
--    end 
end
function ComponentUtils:moveText(showNoticeCallback)
    local function callback()
        self.content:setString("")
        self.clippingNode:removeFromParent()
        self.node:removeFromParent()
        self.content = nil
        self.node = nil
--        print("===============showNotice=============")
        if showNoticeCallback ~= nil then
            showNoticeCallback()
        end
    end
    local x, y = self.content:getPosition()
    local size = self.content:getContentSize()
    local speed = 30
    local time = size.width / speed
    local action = cc.MoveTo:create(time,cc.p(x- size.width - 10, y))
    self.content:runAction(cc.Sequence:create(action, cc.CallFunc:create(callback)))
end

--function ComponentUtils:onCloseTimerOpenFun()
--    TimerManager:remove(self.onUpdate,self)
--end

--聊天专用 
function ComponentUtils:getChatItem(context, scale)
    if context == "" or not context then
        return {{txt = ""}}
    end
    local params = {}
    local bqPath = {}
    local config = ConfigDataManager:getConfigData(ConfigData.ChatFaceConfig)
    for _, info in pairs(config) do
        local lenght = string.len(info.faceinstead)
        -- bqPath[string.sub(info.faceinstead, 2, lenght)] = string.format("images/faceIcon/face_%d.png", info.iconID)
        bqPath[string.sub(info.faceinstead, 2, lenght)] = string.format("images/faceIcon/%d.png", info.iconID)
    end
    --没有表情
    if not string.find(context, "#") then
        local p = {}
        p.txt = context
        table.insert(params, p)
        return params
    end
    scale = scale or 1
    --以#分割字符串
    local allStr = string.split(context, "#")
    for i=1,#allStr do
        if bqPath[allStr[i]] then
            local p = {}
            p.img = bqPath[allStr[i]]
            p.scale = scale
            table.insert(params, p)
        elseif string.len(allStr[i]) >= 3 then
            local isBq = false
            for k,v in pairs(bqPath) do
                local pos = string.find(allStr[i], k)
                if pos and pos == 1 then
                    local p = {}
                    p.img = v
                    p.scale = scale
                    table.insert(params, p)
                    if string.len(k) < string.len(allStr[i]) then
                        local q = {}
                        q.txt = string.sub(allStr[i], string.len(k)+1, string.len(allStr[i]))
                        table.insert(params, q)
                    end
                    isBq = true
                    break
                end               
            end
            if not isBq then
                if i ~= 1 then
                    local q = {}
                    q.txt = "#"..allStr[i]
                    table.insert(params, q)
                else
                    local q = {}
                    q.txt = allStr[i]
                    table.insert(params, q)
                end
                
            end
        else
            if i~=1 then
                local p = {}
                p.txt = "#"..allStr[i]
                table.insert(params, p)
            else
                if allStr[i]~="" then
                    local p = {}
                    p.txt = allStr[i]
                    table.insert(params, p)
                end
            end

        end
    end
    return params
end


function ComponentUtils:renderStar(stars, count, url, drakUrl, starMax)
    starMax = starMax or 5
    url = url or "images/gui/Icon_stars.png"
    for i=1,count do
        stars[i]:setVisible(true)
        TextureManager:updateImageView(stars[i], url)
    end
    if count >= 5 then
        return
    end
    for i=count+1,starMax do
        stars[i]:setVisible(drakUrl ~= nil)
        if drakUrl ~= nil then
            TextureManager:updateImageView(stars[i], drakUrl)
        end
    end
    for i=starMax+1,5 do
        stars[i]:setVisible(false)
    end
end

function ComponentUtils:renderLabel(info, widgets, otherWidgets)
    local index = 1
    local function updateLabelData(data, widget)
        if data.color then
            widget:setColor(ColorUtils:color16ToC3b(data.color))
        end
        if data.font then
            widget:setFontSize(data.font)
        end
        if data.txt then
            widget:setString(data.txt)
        else
            widget:setVisible(false)
        end
    end
    for i=1,#info,2 do
        widgets[index]:setVisible(true)
        otherWidgets[index]:setVisible(true)
        updateLabelData(info[i], widgets[index])
        updateLabelData(info[i+1], otherWidgets[index])
        index = index + 1
    end
    for i=index,5 do
        widgets[i]:setVisible(false)
        otherWidgets[i]:setVisible(false)
    end
end

-- 创建数字标签
function ComponentUtils:createTextAtlas(parent, imageFile, width, height)
    -- body
    local textAtlas = ccui.TextAtlas:create()
    -- textAtlas:setProperty("1234567890", "ui/images/fonts/" .. imageFile .. ".png", width, height, "0")
    
    local url = string.format("ui/images/fonts/%s.png",imageFile)
    textAtlas:setProperty("1234567890", url, width, height, "0")
    logger:info("数字标签 url %s",url)

    if parent ~= nil then
        parent:addChild(textAtlas)
    end

    return textAtlas
end

function ComponentUtils:onUpdateLvItem(bgImg,type)
    --if bgImg and type then
        if bgImg._type ~= type then
            bgImg._type = type
            local url = "images/guiNew/LvItem_other.png"  --所有
            if type == 2 then
                url = "images/guiNew/LvItem_self.png"   --军团
            elseif type == 3 then
                url = "images/guiNew/LvItem_self.png"   
            end
            -- bgImg:setVisible(false)
            -- local function delay()
                bgImg:setVisible(true)
                TextureManager:updateImageView(bgImg,url)
            -- end
            -- TimerManager:addOnce(30,delay, self) 
        end
    --end
end

--通用二级面板，渲染不确定获取物品弹窗, UI结构，参考UIGetProp
--@param listView UI列表
--@param bgImg UI背景
--@param secLvBg 二级面板类
--@param sureBtn 确认按钮
--@param infos 物品信息列表
--@param panel 所在的逻辑Panel
function ComponentUtils:renderAllGoods(listView, bgImg, secLvBg, sureBtn, infos, panel)
    local srcX = listView.srcX
    local srcY = listView.srcY
    if listView.bgImgX == nil then
        listView.bgImgX = bgImg:getPositionX()
        listView.btnX = sureBtn:getPositionX()
        listView.posY = bgImg:getPositionY()
    end
    local bgImgX = listView.bgImgX
    local btnX = listView.btnX
    local posY = listView.posY
    local scale = NodeUtils:getAdaptiveScale()
    if srcX == nil then
        listView.srcX, listView.srcY = listView:getPosition()
        srcX, srcY = listView.srcX, listView.srcY
    end
    local tempInfo = self:infoTodouble(infos)
    local bgWidth = 540
    local bgHeight = 0
    if listView.oldRow ~= #tempInfo then
        local offsetY = 20
        if #tempInfo == 1 then
            listView:setPosition(srcX  , srcY + 205)
            listView:setContentSize(550, 140)
            secLvBg:setContentHeight(305+10)
            bgImg:setContentSize(bgWidth, 150)
            bgHeight = 150
            bgImg:setPositionY(posY - 106)
        elseif #tempInfo == 2 then
            listView:setPosition(srcX  , srcY + 130*scale)
            listView:setContentSize(550, 280)
            secLvBg:setContentHeight(450+10)
            bgImg:setContentSize(bgWidth, 290)
            bgHeight = 290
            bgImg:setPositionY(posY - 106)
        elseif #tempInfo == 3 then
            listView:setPosition(srcX , srcY + 70*scale)
            listView:setContentSize(550, 420)
            secLvBg:setContentHeight(590+10)
            bgImg:setContentSize(bgWidth, 430)
            bgHeight = 430
            bgImg:setPositionY(posY - 106)
            offsetY = 20
        elseif #tempInfo == 4 then
            listView:setPosition(srcX , srcY*scale)
            listView:setContentSize(550, 560)
            secLvBg:setContentHeight(740+10)
            bgImg:setContentSize(bgWidth, 570)
            bgHeight = 570
            bgImg:setPositionY(posY - 106)
            offsetY = 20
        else 
            listView:setPosition(srcX , srcY - 60/scale)
            listView:setContentSize(550, 680)
            secLvBg:setContentHeight(900+10)
            bgImg:setContentSize(bgWidth, 720)
            bgHeight = 720
            bgImg:setPositionY(posY - 106)
            offsetY = 20
        end
        local y = bgImg:getPositionY() - bgImg:getContentSize().height/2*1/scale
        local height = sureBtn:getContentSize().height
        sureBtn:setPositionY(y - height/2 - 10)
        listView.oldRow = #tempInfo
    end


    bgImg:setScale(1/scale)
    listView:setScale(1/scale)
    bgImg:setPositionX(bgImgX*1/scale)
    listView:setPositionX(bgImgX*1/scale - bgWidth*0.5*1/scale)
    local listHeight = listView:getContentSize().height
    --发现bgimg的位置非常准确，listview的y坐标跟着bgimg的坐标走
    listView:setPositionY(bgImg:getPositionY() - listHeight*0.5*1/scale)
    sureBtn:setPositionX(btnX*1/scale)

    local function renderItemPanel(obj, item, data)
        if (not item) or (not data) then
            return
        end
        for i=1,5 do
            local icon = item:getChildByName("icon"..i)
            icon:setVisible(data[i] ~= nil)
            if data[i] then
                local uiIcon = icon.uiIcon
                if not uiIcon then
                    uiIcon = UIIcon.new(icon, data[i], true, panel)
                    icon.uiIcon = uiIcon
                else
                    uiIcon:updateData(data[i])
                end
                uiIcon:setPosition(icon:getContentSize().width/2, icon:getContentSize().height/2)
    
                local info = ConfigDataManager:getConfigByPowerAndID(data[i].power, data[i].typeid)
                local nameLab = icon:getChildByName("nameLab")
                nameLab:setString(info.name)
                local color = ColorUtils:getColorByQuality(info.color or 1)
                nameLab:setColor(color)
            end
        end
            self:adjustIconPos(item, #data)
    end

    ComponentUtils:renderListView(listView, tempInfo, self, renderItemPanel)
end

--渲染宝具洗炼属性恢复选择弹窗
--@param listView UI列表
--@param bgImg UI背景
--@param secLvBg 二级面板类
--@param sureBtn 确认按钮
--@param infos 物品信息列表
--@param panel 所在的逻辑Panel
function ComponentUtils:renderTreasureRecover(listView, bgImg, secLvBg, sureBtn, infos, panel,addfunc,sureBtnHandler)
    local srcX = listView.srcX
    local srcY = listView.srcY
    if listView.bgImgX == nil then
        listView.bgImgX = bgImg:getPositionX()
        listView.btnX = sureBtn:getPositionX()
        listView.posY = bgImg:getPositionY()
    end
    local bgImgX = listView.bgImgX
    local btnX = listView.btnX
    local posY = listView.posY
    local scale = NodeUtils:getAdaptiveScale()
    if srcX == nil then
        listView.srcX, listView.srcY = listView:getPosition()
        srcX, srcY = listView.srcX, listView.srcY
    end
    local tempInfo = infos--self:infoTodouble(infos)
   
    local bgWidth = 540
    if listView.oldRow ~= #tempInfo then
        local offsetY = 20
        if #tempInfo == 1 then
            listView:setPosition(srcX - 10 , srcY + 175)
            listView:setContentSize(550, 140)
            secLvBg:setContentHeight(220)
            bgImg:setContentSize(bgWidth, 150)
            bgImg:setPositionY(posY - 106)
        elseif #tempInfo == 2 then
            listView:setPosition(srcX  - 10 , srcY + 93*scale)
            listView:setContentSize(550, 290)
            secLvBg:setContentHeight(365)
            bgImg:setContentSize(bgWidth, 290)
            bgImg:setPositionY(posY - 106)
        elseif #tempInfo == 3 then
            listView:setPosition(srcX - 10 , srcY + 38*scale)
            listView:setContentSize(550, 440)
            secLvBg:setContentHeight(510)
            bgImg:setContentSize(bgWidth, 430)
            bgImg:setPositionY(posY - 106)
            offsetY = 20
        elseif #tempInfo == 4 then
            listView:setPosition(srcX  - 10, srcY - 10*scale)
            listView:setContentSize(550, 580)
            secLvBg:setContentHeight(655+10)
            bgImg:setContentSize(bgWidth, 570)
            bgImg:setPositionY(posY - 106)
            offsetY = 20
        else 
            listView:setPosition(srcX  - 10, srcY - 90/scale)
            listView:setContentSize(550, 730)
            secLvBg:setContentHeight(810)
            bgImg:setContentSize(bgWidth, 720)
            bgImg:setPositionY(posY - 106)
            offsetY = 20
        end
        local y = bgImg:getPositionY() - bgImg:getContentSize().height/2*1/scale
        local height = sureBtn:getContentSize().height
        sureBtn:setPositionY(y - height/2 - 10)
        listView.oldRow = #tempInfo
    end
    


    bgImg:setScale(1/scale)
    listView:setScale(1/scale)
    bgImg:setPositionX(bgImgX*1/scale)
    sureBtn:setPositionX(btnX*1/scale)

    local function renderItemPanel(obj, item, data, index)
        if (not item) or (not data) then
            return
        end
 
        local icon = item:getChildByName("icon1")
        local iconImg = icon:getChildByName("img")
        local attUrl =  self:getTreasureHighAttImgUrl(data.typeid)
        TextureManager:updateImageView(iconImg, attUrl)

        local sureBtn = item:getChildByName("sureBtn")
        local attAddLab = item:getChildByName("attAddLab")
        local nameLab = item:getChildByName("nameLab")

        nameLab:setString(data.name)
        attAddLab:setString(data.propertyName .. "  +" .. data.property)
    

        local selectImg = item:getChildByName("selectImg")
        selectImg:setVisible(false)
        item.hideSelect = function ()
            selectImg:setVisible(false)
        end
        local function onTouchItemHandler(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                addfunc(listView,data,index)
                --selectImg:setVisible(true)
            end
        end
        local function onSureBtnHandler(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                sureBtnHandler(listView,data,index)
                --selectImg:setVisible(true)
            end
        end
        item:addTouchEventListener(onTouchItemHandler)
        sureBtn:addTouchEventListener(onSureBtnHandler)              
    end

    ComponentUtils:renderListView(listView, infos, self, renderItemPanel)
end
function ComponentUtils:adjustIconPos(item, lenght)
    local pos = {}
    pos["pos5"] = {36, 147, 258, 369, 481}
    for i=1,4 do
        pos["pos"..i] = {}
        for j=1,i do
            pos["pos"..i][j] = 525/(i + 1) * j
        end
    end
    local posData = pos["pos"..lenght]
    for i=1, lenght do
        local icon = item:getChildByName("icon"..i)
        icon:setPositionX(posData[i])
    end
end

function ComponentUtils:infoTodouble(info)
    info = TableUtils:map2list(info)
    local tempInfo = {}
    local index = 1
    for i=1, #info, 5 do
        tempInfo[index] = tempInfo[index] or {}
        table.insert(tempInfo[index], info[i])
        table.insert(tempInfo[index], info[i+1])
        table.insert(tempInfo[index], info[i+2])
        table.insert(tempInfo[index], info[i+3])
        table.insert(tempInfo[index], info[i+4])
        index = index + 1
    end
    return tempInfo
end

--[[
    创建图文混排富文本  下划线，触摸事件
    像UIIcon等控件
    if uiIcon ~= nil then
        uiIcon:updateData(data)
    end
    在存在的时候更新数据，调用对象的setData(data)
    参数用法，参考RichTextMgr.lua比较详细
    返回富文本对象和真实宽度
]]
function ComponentUtils:createUIRichLabel(data, maxwidth, color, callback, lineSize)
    require "modules.chat.rich.RichTextMgr"
    local richNode, width = RichTextMgr:getInstance():getRich(data, maxwidth, color, callback, lineSize)
    richNode:setAnchorPoint(0,0)
    return richNode, width
end

--逐字渲染文本
--text Text控件
--content 内容
function ComponentUtils:renderTextByOneWord(text, content, callback)
    local wordAry = StringUtils:splitUtf8String(content, "")

    local function complete()
        print("~~~~~~~~~~~~~~complete~~~~~~~~~~~~~~")
        if callback ~= nil then
            callback()
        end
    end

    local newWordAry = {}
    local function renderWord(obj, word)
        table.insert(newWordAry, word)
        local content = table.concat(newWordAry, "")
        text:setString(content)

        if #newWordAry == #wordAry then
            complete()
        end
    end
    local index = 1
    for _, word in pairs(wordAry) do
        TimerManager:addOnce(100 * index, renderWord, {}, word)
        index = index + 1
    end
end

--调整星星的位置，无论显示多少颗星，都能居中
--distance  原本的长度  例如五颗星本来占用了163个像素点
--stars     所有星星
--count     要显示几个星
--isY       纵向居中时候传非nil，默认横向居中
function ComponentUtils:adjustStarPos(distance, stars, count, isY)
    -- if count == #stars or count == 0 then
    --     print("无需调整")
    --     return
    -- end
    local interval = distance/(count + 1)


    for i=1,#stars do
        if isY ~= nil then
            stars[i]:setPositionY(interval*i)
        else
            stars[i]:setPositionX(interval*i)
        end
    end
    
end


--军师专用
--=======================================================================
--通用的谋士item刷新方法。。
--item       编辑器编辑好的item，或者一个空的panel(代码帮你创建) size:200*200
--typeid     谋士表id

--_lv        谋士等级。默认0
--_posUrl    状态  传图片路径。默认nil，无状态
--_hideSkill 是否隐藏技能。  默认否
--_hideEff   是否隐藏特效。  默认否  *已注册监听 item与特效将同时释放
--_isGrey    是否灰   默认否
--_strInfoName 名字替换，默认表的军师名

function ComponentUtils:renderConsigliereItem( item, typeid, _lv, _posUrl, _hideSkill, _hideEff, _isGrey, _strInfoName)
    if not _lv  then
        _lv = 0
    end
    local path = "images/guiNew/"
    local size = item:getContentSize()

    local img_icon = item:getChildByName("img_icon")  --身体
    local img_head = item:getChildByName("img_head") --头像
    local batImg = item:getChildByName("img_battle") --状态

    local lab_name = item:getChildByName("lab_name") --名字
    local img_star = item:getChildByName("img_star") --星级数目
    local img_bg3 = item:getChildByName( "img_bg3" ) --背景
    local img_star3 = item:getChildByName( "img_star3" ) --星星
    -- local desc_Bgimg = item:getChildByName( "desc_Bgimg" ) --描述背景
    local lab_desc = item:getChildByName( "lab_desc" ) --描述

    if not img_icon then  --编辑器上未创建子对象，则代码创建
        img_icon, img_head, batImg, lab_name, img_star, img_bg3, img_star3, lab_desc = self:_createConsigliereItem( item )
    end
    --desc_Bgimg:setScale9Enabled(true)
    img_star:setVisible( false )
    img_star3:setVisible( false )

    --基本信息
    local addInfo = nil
    local skillconf = nil
    local quality = nil
    local visiHead = false
    local url = "images/consigliere/adviser_dufout.png" --默认图片 未知人物
    local bgurl = path.."adviser_bg11.png"
    local colorQuality = ColorUtils.wordWhiteColor
    local itemX = size.width*0.5
    local itemY = size.width*0.4
    if typeid then
        local _conf = ConfigDataManager:getConfigData(ConfigData.CounsellorConfig)
        local conf = _conf[ typeid ] or {}
        local bodyPos = StringUtils:jsonDecode( conf.bodyXY or "[0,0]" ) or {0,0}
        local visiLv = _lv>0
        itemX = itemX + bodyPos[1]
        itemY = itemY + bodyPos[2]
        -- if _lv > 0 then
        --     TextureManager:updateImageView( img_star, string.format("images/guiNew/adviser_num_%d.png", tonumber(_lv)) )
        -- end
        img_star:setVisible( visiLv )
        img_star3:setVisible( visiLv )

        if conf.headIcon and conf.headIcon>0 then
            local headPos = StringUtils:jsonDecode( conf.headXY or "[0,0]" ) or {0,0}
            url = string.format("images/consigliereImg/head%d.png", conf.headIcon)
            img_head:setPosition( itemX+headPos[1], itemY+headPos[2]+68 )
            TextureManager:updateImageView(img_head, url)
            visiHead = true
        end

        quality = conf.quality
        skillconf = conf.skillID
        addInfo = conf.addInfo
        colorQuality = ColorUtils:getColorByQuality(conf.quality)
        if conf.icon then
            url = string.format("images/consigliereImg/body%d.png", conf.icon )
        end
        if conf.quality then
            bgurl = string.format( "images/guiNew/adviser_bg1%d.png", conf.quality )
        end
        
        lab_name:setString( conf.name or "" )
        lab_name:setColor( colorQuality )
        lab_desc:setColor( colorQuality )
        if not visiLv then 
            lab_name:setAnchorPoint( 0.5, 0.5 )
        else
            lab_name:setAnchorPoint( 0.2, 0.5 )
        end

        if visiLv then
            local sStarUrl = string.format(path.."adviser_num_%d.png", _lv)
            TextureManager:updateImageView(img_star, sStarUrl)
            conf = ConfigDataManager:getInfoFindByTwoKey(ConfigData.CounsellorLvupConfig, "lv", _lv, "CounsellorID", typeid )
        end
    else
        lab_name:setAnchorPoint(0.5,0.5)
        lab_name:setString( TextWords:getTextWord(390) )
        lab_name:setColor( ColorUtils.wordGrayColor )
        lab_desc:setColor( ColorUtils.wordWhiteColor )
    end
    local grey = _isGrey and cc.c3b(110,110,110) or cc.c3b(255,255,255)
    TextureManager:updateImageView( img_bg3, bgurl )
    TextureManager:updateImageView( img_icon, url)
    img_icon:setPosition( itemX, itemY )
    img_icon:setColor( grey )
    img_head:setColor( grey )
    img_head:setVisible( visiHead )


    lab_desc:setVisible(_strInfoName ~= nil)
    if _strInfoName then
        lab_desc:setString( _strInfoName )
        --desc_Bgimg:setContentSize(lab_desc:getContentSize().width+40, desc_Bgimg:getContentSize().height)
        lab_desc:setAnchorPoint( visiLv and 0.2 or 0.5, 0.5 )
        -- lab_desc:setPosition(desc_Bgimg:getPosition())
    end   

    --官职
    batImg:setVisible( not not _posUrl )
    if _posUrl then
        TextureManager:updateImageView( batImg, _posUrl)
    end

    --特效
    local function removeEff()
        if item.__effObj then
            logger:error("消除特效:"..item.__strEffName)
            item.__effObj:finalize()
            item.__effObj = nil
            item.__strEffName = nil
        end
    end
    if not _hideEff and not _isGrey and quality then

        local _EffNameArr = {[2]="rgb-jsf-pinzilv", [3]="rgb-jsf-pinzilan", [4]="rgb-jsf-pinzizi", [5]="rgb-jsf-pinzihuang"}
        
        local strCurName = _EffNameArr[quality]

        if item.__strEffName~=strCurName then --交换
            if strCurName then
                removeEff()
                item.__effObj = UICCBLayer.new(strCurName, item)
                item.__effObj:setPosition( size.width*0.5, 40)
                item.__strEffName = strCurName
            elseif item.__effObj then
                item.__effObj:setVisible(false)
            end
        elseif item.__effObj then
            item.__effObj:setVisible( true )
        end
    elseif item.__effObj then
        item.__effObj:setVisible( false )
    end

    --技能图标
    local strIconName = "___skillIconName"

    local function renderSkillIcon( i, png )
        local iconUrl = "images/consigliere/"..png  --技能图标
        local err = TextureManager:getUITexture( iconUrl )
        local mIcon = item:getChildByName( strIconName..i )
        if not mIcon then
            mIcon = TextureManager:createImageView(iconUrl)
            local iconH = mIcon:getContentSize().height
            mIcon:setPosition( size.width*0.8, 15+(iconH+5)*i )
            mIcon:setName( strIconName..i )
            item:addChild( mIcon )
        else
            TextureManager:updateImageView( mIcon, iconUrl )
        end
        mIcon:setVisible(true)
        mIcon:setColor( grey )
        mIcon:setScale( err and 1 or 0.39 )
    end

    if not _hideSkill and quality and skillconf then
        local strArr = StringUtils:jsonDecode( skillconf )
        local len = 0
        for i=1, #strArr do
            len = i
            renderSkillIcon( len, string.format("skill%d.png", quality) )
        end
        if addInfo and addInfo~="" and addInfo~=" " then
            len = len + 1
            renderSkillIcon( len, "tian_fu.png" )
        end
        for i=len+1, 5 do
            local mIcon = item:getChildByName( strIconName..i )
            if mIcon then
                mIcon:setVisible( false )
            end
        end
    end

    --释放特效
    item:setBackGroundColorType(0)
    item:registerScriptHandler(function(state, v2)
        if state=="cleanup" then
            removeEff()
        end
    end)
end
function ComponentUtils:_createConsigliereItem( item )
    local w = item:getContentSize().width
    local h = item:getContentSize().height

    local function createImg(name, x, y)
        local Img = ccui.ImageView:create()
        Img:setName(name)
        if x and y then Img:setPosition( x, y ) end
        item:addChild( Img )
        return Img
    end

    local img_icon =createImg("img_icon" )
    local img_head =createImg("img_head" )
    local batImg =  createImg("img_battle", w*0.9, h*0.9 )
    local img_bg3 = createImg("img_bg3", w*0.5, 15 )
    local img_star3= createImg("img_star3", w*0.23, 16 )
    local img_star = createImg("img_star", w*0.33, 14 )
    --local desc_Bgimg = createImg("desc_Bgimg",  w*0.5, -20 )

    batImg:setAnchorPoint( 1, 1 )
    batImg:setScale( 1/item:getScale() )

    local lab_name = ccui.Text:create()
    lab_name:setName("lab_name")
    lab_name:setFontSize( 20 )
    lab_name:setAnchorPoint(0.5, 0.5)
    lab_name:setPosition( w*0.5, 15 )
    item:addChild(lab_name)

    local lab_desc = ccui.Text:create()
    lab_desc:setName("lab_desc")
    lab_desc:setFontSize( 18 )
    lab_desc:setAnchorPoint(0.5, 0.5)
    lab_desc:setPosition( w*0.5, -20 )
    item:addChild(lab_desc)

    TextureManager:updateImageView( img_star3, "images/guiNew/adviser_star3.png" )
    --TextureManager:updateImageView( desc_Bgimg, "images/guiNew/Bg_list_only.png" )
    return img_icon, img_head, batImg, lab_name, img_star, img_bg3, img_star3, lab_desc--, desc_Bgimg
end
--军师专用
--=======================================================================
--通用的谋士属性列表刷新方法  返回列表高度
--mPanel  parent对象
--adviserConf 某个军师的配置表
--_tableObj  父级对象，技能图标用，默认无
--_visiSkill 是否显示技能描述，默认是
--_addInfo  附加描述，默认空
function ComponentUtils:updateConsigliereProperty( mPanel, adviserConf, _tableObj, _visiSkill, _addInfo )
    local MAX_LEN = 6  --默认最多五列属性
    local SIZE = 20  --字体大小
    local D = 5 --间距 

    local propertys = StringUtils:jsonDecode( adviserConf.property or "[]" )

    local height = 0
    if not mPanel then return end

    --公用
    local function getText( name, color )
        local mText = mPanel:getChildByName( name )
        if not mText then
            mText = ccui.Text:create()
            mText:setName( name )
            mText:setFontSize( SIZE )
            mText:setColor( color or ColorUtils.wordWhiteColor )
            mText:setAnchorPoint(0,0.5)
            mPanel:addChild( mText )
        end
        return mText
    end

    --属性列表
    local function getProText( i, kv, isLeft, pitem )
        local name = "_mtext"..i.."_"..kv
        local color= isLeft and ColorUtils.wordWhiteColor or  ColorUtils.wordGreenColor
        local mText = getText( name, color )
        local x = 0
        height = i*(SIZE+D)
        if not isLeft and pitem then
            x = pitem:getPositionX()+pitem:getContentSize().width+10
        end
        mText:setPosition( x, -height )
        mText:setString( str )
        return mText
    end
    local ResourceConfig = ConfigDataManager:getConfigData( ConfigData.ResourceConfig )

    local newPropertys = {}
    if adviserConf.command>0 then  --手动插入带兵量
        local P_KEY = 106  --带兵量Id是 106
        newPropertys = { {P_KEY, adviserConf.command} }
    end
    for i,v in ipairs(propertys) do
        table.insert(newPropertys, v)
    end

    local keys = { [106]=true,  }  --需要隐藏百分号的，往这里加 基础资源key
    local mText = nil
    for i,v in ipairs(newPropertys) do

        local hidePercent = nil

        for kv, vul in ipairs(v) do
            local isLeft = kv%2==1

            local str = ""

            if isLeft then
                hidePercent = keys[vul]
                local conf = ResourceConfig[vul] or {}
                str = conf.name and (conf.name..": ") or ""
            else
                if not hidePercent then
                    str = "+"..((vul or 0)*0.001).."%"
                else
                    str = "+"..vul
                end
            end
            mText = getProText( i, kv, isLeft, mText )
            mText:setString( str )
        end
    end
    for i=#newPropertys+1, MAX_LEN do
        for kv=1,2 do
            local name = "_mtext"..i.."_"..kv
            local mText = mPanel:getChildByName( name )
            if mText then
                mText:setString("")
            end
        end
    end

    --技能列表
    if _visiSkill then
        local skillStr = self:analyzeConsiglierePropertyStr( adviserConf.skillID, _addInfo, false )
        local mSkilllv = getText( "_mSkillLv" )
        mSkilllv:setAnchorPoint(0,1)
        mSkilllv:setColor( ColorUtils.wordTitleColor )
        mSkilllv:setPositionY( -height-SIZE+D )
        mSkilllv:setString( StringUtils:getStringAddBackEnter( skillStr, 14) )
    elseif mPanel:getChildByName("_mSkillLv") then
        mPanel:getChildByName("_mSkillLv"):setVisible(false)
    end

    mPanel:setBackGroundColorType(0)
end

function ComponentUtils:analyzeConsiglierePropertyStr( skillID, _addInfo, _visiSkillDse )
    local skillStr = ""
    local skillIds = StringUtils:jsonDecode( skillID or "[]" )
    for i, skillid in ipairs(skillIds) do
        local skillconf = ConfigDataManager:getConfigData(ConfigData.CounsellorSkillConfig)
        local skillData = skillconf[skillid] or {}

        --lv
        local lv = skillData.skillLevel or 0
        local lvStr = lv>0 and ("Lv"..lv) or ""
        -- if i~=1 then
        --     skillStr = skillStr.."\n"
        -- end
        skillStr = skillStr..skillData.name..lvStr
        if _visiSkillDse==nil or _visiSkillDse==true then
            skillStr = skillStr.."："..(skillData.info or "").."\n"
        end
    end
    if _addInfo and _addInfo~="" and _addInfo~=" " then
        skillStr = skillStr.."天赋：".._addInfo
    end
    return skillStr
end

--通用物品刷新，
--返回 数量比 如数量  7/3 返回2,  1/2 返回0
function ComponentUtils:renderItemFormPanel( parent, itemPanel, typeid, _power, _num )
    local customNumStr = nil
    local isFullNumber = nil
    local numberAtBag = _num
    if _num then
        local itemProxy = parent:getProxy( GameProxys.Item )
        numberAtBag = itemProxy:getItemNumByType( typeid )
        isFullNumber = numberAtBag>=_num
        local color = isFullNumber and ColorUtils.wordGreenColor16 or ColorUtils.wordRedColor16
        local numStr1 = StringUtils:formatNumberByK( numberAtBag )
        local numStr2 = "/"..StringUtils:formatNumberByK( _num )
        customNumStr = {{{ numStr1, 18, color}, { numStr2, 18, ColorUtils.wordWhiteColor16}  }}
    end
    local data = {
        power = _power or 401,
        typeid = typeid,
        customNumStr = customNumStr,
        num = numberAtBag or 1,
    }
    if not itemPanel.icon then
        itemPanel.icon = UIIcon.new( itemPanel, data, true, parent, nil, true)
    else
        itemPanel.icon:updateData( data )
    end
    return isFullNumber
end

--通用渲染任务图标
function ComponentUtils:renderTaskIcon(panel)
    if panel.taskIcon ~= nil then
        panel.taskIcon:removeFromParent()
        panel.taskIcon = nil
    end

    local taskProxy = panel:getProxy(GameProxys.Task)
    local taskInfo = taskProxy:getMainTaskListByType(1)

    if taskInfo == nil then
        return 
    end

    local config = taskInfo.conf
    if config == nil then
        return
    end

    local panelName = panel.NAME
    if panelName ~= config.reaches then
        return
    end
    
    if panel[config.markControl] ~= nil then
        local widget = panel[config.markControl]
        panel.taskIcon = TextureManager:createImageView("images/guiNew/taskImg.png")
        widget:addChild(panel.taskIcon)
        panel.taskIcon:setLocalZOrder(99)
        local offsetPos = StringUtils:jsonDecode(config.markXY)
        local x = offsetPos[1] or 0
        local y = offsetPos[2] or 0
        panel.taskIcon:setPosition(x, y)
    end
end

function ComponentUtils:removeTaskIcon(panel)
    if panel.taskIcon ~= nil then
        panel.taskIcon:removeFromParent()
        panel.taskIcon = nil
    end
end