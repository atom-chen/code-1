
UIExpandListView = class("UIExpandListView")
UIExpandListView.PRE_LOAD_LIST_ITEM_NUM = 4

function UIExpandListView:ctor(listView, itemWidth, itemHeight, frameRenderCount)
    self._listView = listView
    self._initState = true
    self._itemWidth = itemWidth
    self._itemHeight = itemHeight

    self._itemsMargin = listView:getItemsMargin()
    self._updateDataCallback = listView.updateData
    self._listViewData = nil
    
    self._itemAHeight = self._itemHeight + self._itemsMargin

    self._minYTile = 0
    self._maxYTile = 0
    
    self._preLoadDelay = math.random(200,500) --随机的预加载加载时间 分散多个ListView预加载

    self._preLoadNum = UIExpandListView.PRE_LOAD_LIST_ITEM_NUM

    self._frameRenderCount = frameRenderCount or 3 
    
    self._curLoadIndex = 0 --当前加载的数据Index
    self._fromPanel = fromPanel

    self:initListView(listView)
end


function UIExpandListView:initListView(listView)
    self:addListViewEvent(listView)

    local size = self._listView:getContentSize()
    self._maxSeeItemCount = math.ceil( size.height / self._itemHeight )

    self._expandViewQueue = Queue.new()

end

--这里对于每个列表，都要做一下释放
function UIExpandListView:finalize()
    -- logger:error("~~~~~~~~~~列表释放~~~~~~~~~~~~~")
    self:removeSchedule()

    self._expandViewQueue = nil
end

--模块关闭的时候，还是需要移除掉定时器的
function UIExpandListView:removeSchedule()
    -- TimerManager:remove(self.onExpandViewSchedule, self)

    if self.expandSchedule ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.expandSchedule)
        self.expandSchedule = nil
    end
end

function UIExpandListView:addSchedule()
    -- TimerManager:add(30, self.onExpandViewSchedule, self)

    if self.expandSchedule ~= nil then
        return
    end

    local function onExpandViewSchedule()
        self:onExpandViewSchedule()
    end

    self.expandSchedule = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onExpandViewSchedule,0,false)
end

function UIExpandListView:onExpandViewSchedule()

    -- print("~~~~~~~~~UIExpandListView:onExpandViewSchedule()~~~~~~~~~~~~")

    if self._fromPanel ~= nil and self._fromPanel.isVisible ~= nil then
        if self._fromPanel:isVisible() == false then
            return
        end
    end

    if self._expandViewQueue:size() == 0 then  --同时删除定时器
        self:removeSchedule()
        return  --没有数据就退出
    end

    for index=1, self._frameRenderCount do
        local pos = self._expandViewQueue:pop()
        if pos ~= nil then
            self._updateDataCallback(pos.x, pos.y,0)
        end
    end

end

function UIExpandListView:pool()
end

function UIExpandListView:initListViewData(data, preLoadNum, isFrame, isInitAll)
    self._initState = false
    preLoadNum = preLoadNum or UIExpandListView.PRE_LOAD_LIST_ITEM_NUM
    if isInitAll == true then
        preLoadNum = #data
    end
    self._preLoadNum = preLoadNum
    
    local function delayMove()
        self._listViewData = data
        self._initState = true
    end
    
--    print("-----UIExpandListView:initListViewData------", debug.traceback())
    local initCount = 1  --初始化渲染多少个
    if type(isFrame) == type(1) then
        initCount = isFrame
        isFrame = true
    end
    
    if isFrame ~= true then
        local delayTime = 0
        local count = 1
        for index, _ in pairs(data) do
            if count <= self._maxSeeItemCount + preLoadNum then
                self._curLoadIndex = index
                self:updateDataCallback(0,index - 1,count)
                delayTime = delayTime + index + 1
            end
            count = count + 1
        end
        TimerManager:addOnce(delayTime, delayMove, self)
        
        -- TimerManager:addOnce(self._preLoadDelay, self.delayPushPool, self)
    else
        local index = 1
        local function updateDataCallback()
            local isEnd = false
            for i=1,initCount do
                if index <= self._maxSeeItemCount + preLoadNum then
                    self:updateDataCallback(0,index - 1, index)
                    index = index + 1
                else
                    isEnd = true
                end
            end

            if isEnd then
                TimerManager:addOnce(30, delayMove, self)
                -- TimerManager:addOnce(self._preLoadDelay, self.delayPushPool, self)
            else
                TimerManager:addOnce(30 , updateDataCallback, self)
            end
            -- if index <= self._maxSeeItemCount + preLoadNum then
            --     self:updateDataCallback(0,index - 1, index)
            --     TimerManager:addOnce(30 , updateDataCallback, self)
            -- else
            --     TimerManager:addOnce(30, delayMove, self)
            --     TimerManager:addOnce(self._preLoadDelay, self.delayPushPool, self)
            -- end
            -- index = index + 1
        end
        
        updateDataCallback()
        -- TimerManager:addOnce(30 , updateDataCallback, self)
    end
    
end

--TODO,增加缓存处理
function UIExpandListView:delayPushPool()
    print("~~~~~~~~~~~~~~~~~~delayPushPool~~~~~~~~~~")
    local listView = self._listView
    local items = listView:getItems()
    local count = #items
    local num = ComponentUtils:getListViewItemPoolNum(listView)
    local listViewData = self._listViewData or {}
    if count + num < #listViewData then --还有数据没有填充，先预加载Item
        local item = listView.itemModel:clone()
        ComponentUtils:pushListViewItemPool(listView, item)
--        print("--------delayPushPool------", num, count)
        
        TimerManager:addOnce(self._preLoadDelay, self.delayPushPool, self)
    end
end

--更新列表
function UIExpandListView:updateListViewData(data, isDelayUpdate)

--    print("-----UIExpandListView:updateListViewData------", debug.traceback())
    
    self._expandViewQueue:clear() --把缓存队列清空，以防出现问题
    self._listViewData = data
    self._initState = true
    self._curLoadIndex = 0
    self:handleListViewMove(isDelayUpdate)
    
    self._isUpdating = true
    
    -- TimerManager:addOnce(self._preLoadDelay, self.delayPushPool, self)
    
    local function callback()
       self._isUpdating = false
    end
    TimerManager:addOnce(300,callback,self)
end

--TODO, 有数据还没有更新，才回调计算
function UIExpandListView:handleListViewMove(isMoveUpdate)
    if self._listViewData == nil  then  --and self._isUpdating == true
        return
    end
    if table.size(self._listViewData) == 0 then
        return
    end
    
--    if self._curLoadIndex >= table.size(self._listViewData) then
--        return  --加载的数据，已经超过数据大小了
--    end
    
--    local listView = self._listView
--    local wh = listView:getContentSize().height
--    local sh = self._itemAHeight
--    local container = listView:getInnerContainer()
--    local ch = container:getContentSize().height
--    local x , y = container:getPosition()
--    local scale = NodeUtils:getAdaptiveScale()
--    local sIndex = math.ceil( (ch - wh - math.abs(y)) /sh ) 
--    local items = listView:getItems()
--    for index, item in pairs(items) do
--        if index < sIndex then
--            item:setVisible(false)
--        elseif index > sIndex + self._maxSeeItemCount then
--            item:setVisible(false)
--        else
--            item:setVisible(true)
--        end
--    end
    
    local size = self._listView:getContentSize()
    local width = size.width
    local height = size.height

    local x0, y0 = self:scPos2ItemPos(0,0)
    local x2, y2 = self:scPos2ItemPos(width,height)

    local minXTile = self:xPos2Tile(x0) - 2
    local maxXTile = self:xPos2Tile(x2) + 1

    local minYTile = self:yPos2Tile(y2) - 2
    local maxYTile = self:yPos2Tile(y0) + 1
    
    if minYTile <= 0 then
        minYTile = 0
    end
    
    if maxYTile <= 0 then
        maxYTile = 0
    end

    minXTile = math.max( 0, minXTile )
    maxXTile = math.max( 0, maxXTile )

    self._minYTile = minYTile
    self._maxYTile = maxYTile

    if minXTile == self._lastMinXTile and maxXTile == self._lastMaxXTile
        and minYTile == self._lastMinYTile and maxYTile == self._lastMaxYTile then
        if isMoveUpdate == true then
            return
        end
    end
    
--    print("=======handleListViewMove=======", minYTile, maxYTile)

    local isPush = isMoveUpdate or false

    local dir = self._listView:getDirection()
    local isVerticalDir = dir==ccui.ScrollViewDir.vertical --是否是垂直滚动

    if self._lastMinXTile == nil or isMoveUpdate ~= true then
        --self:delayUpdateListViewTile(minXTile, maxXTile, minYTile, maxYTile)

        if isVerticalDir then
            self:delayUpdateListViewTile( nil, nil, minYTile, maxYTile)
        else
            self:delayUpdateListViewTile( nil, nil, minXTile, maxXTile)
        end
    elseif isVerticalDir then
        local startY, endY
        local dirY = maxYTile - self._lastMaxYTile
        if dirY > 0 then
            startY = self._lastMaxYTile
            endY = maxYTile
        else
            startY = minYTile
            endY = self._lastMinYTile
        end

        for y=startY, endY + self._preLoadNum do
           -- if startY == endY then
           --     break
           -- end
            self:updateListViewTile(0, y, y - startY + 1, isPush)
        end

        if isPush == true then
            self:addSchedule()   --如果是isPush的，开启一个定时器
        end
        
    else
               -- for x=minXTile, maxXTile do
               --     if minXTile == maxXTile then
               --         break
               --     end
        
               -- end

        
               local startX, endX
               local dirX = maxXTile - self._lastMaxXTile
               if dirX > 0 then
                   startX = self._lastMaxXTile
                   endX = maxXTile
               else
                   startX = minXTile
                   endX = self._lastMinXTile
               end
        
               for x=startX, endX do
                   if startX == endX then
                       break
                   end
                   -- for y=minYTile, maxYTile do
                   --     if minYTile == maxYTile then
                   --         break
                   --     end
                       self:updateListViewTile(0,x)
                   -- end
               end
    end

    self._lastMinXTile = minXTile
    self._lastMaxXTile = maxXTile
    self._lastMinYTile = minYTile
    self._lastMaxYTile = maxYTile
end

--ListView移动到最底端了，判断是否还有数据可以加载
function UIExpandListView:handleListViewMoveBottom()
    print("=============handleListViewMoveBottom===============")
    
    for index=1, self._maxSeeItemCount do
        local nextIndex = self._curLoadIndex + 1
        if self._listViewData[nextIndex] ~= nil then
            self:updateDataCallback(0, nextIndex - 1)
            self._curLoadIndex = self._curLoadIndex + 1
        end
    end
end

function UIExpandListView:delayUpdateListViewTile(minXTile, maxXTile, minYTile, maxYTile)
    if minYTile < 0 then
        minYTile = 0
    end
    if maxYTile < 0 then
        maxYTile = 0
    end
    local index = 0
    for j=minYTile , maxYTile  + self._preLoadNum do
--        for i=minXTile, maxXTile do
            self:updateListViewTile(0,j,index+1)
            index = index + 1
--        end
    end
end


function UIExpandListView:updateListViewTile(xtile, ytile,delay, isPush)
    --    print("===============updateListViewTile=================",xtile, ytile)
    self:updateDataCallback(xtile,ytile,delay, isPush)
end

function UIExpandListView:updateDataCallback(xtile, ytile ,delay, isPush)
    if self._updateDataCallback ~= nil then
        if isPush == true then
            self._expandViewQueue:push({x = xtile, y = ytile})
        else
            self._updateDataCallback(xtile, ytile,delay)
            
            self._curLoadIndex = ytile + 1
        end

        --        
    end
end

function UIExpandListView:getMinYTile()
    return self._minYTile
end

function UIExpandListView:getMaxYTile()
    return self._maxYTile
end


function UIExpandListView:addListViewEvent(listView)
    local function scrollViewEvent(sender, evenType)
        self:handleListViewMove(true)
    end
    listView:addScrollViewEventListener(scrollViewEvent)
end


function UIExpandListView:scPos2ItemPos(scPosX, scPosY)
    local movePos = self._listView:getMoveChildPoint()
    local x = scPosX + math.abs(movePos.x)
    local y = scPosY + math.abs(movePos.y)

    return x, y
end

function UIExpandListView:xPos2Tile(xpos)
    if xpos==0 then
        return 0
    end
    local items = self._listView:getItems()
    for i, item in ipairs(items) do  --TODO 缓存坐标
        local x = item:getPositionX()
        if xpos>x and xpos<=(x+item:getContentSize().width+self._itemsMargin) then
            return i
        end
    end
    local x = math.floor(xpos / (self._itemWidth ))
    return x

end

function UIExpandListView:yPos2Tile(ypos)
    local items = self._listView:getItems()
    local ah = #items * (self._itemHeight + self._itemsMargin) - self._itemsMargin
    local cy = ah - ypos
    local y = cy / (self._itemHeight + self._itemsMargin)
    y = math.floor(y)
    --    local y =  math.floor( ((#items) * (self._itemHeight + self._itemsMargin)  - ypos) / (self._itemHeight + self._itemsMargin))

    return y
end


function UIExpandListView:getListViewData()
    return self._listViewData
end

function UIExpandListView:getInitState()
    return self._initState
end


