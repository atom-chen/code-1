
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

    self:initListView(listView)
end


function UIExpandListView:initListView(listView)
    self:addListViewEvent(listView)

    local size = self._listView:getContentSize()
    self._maxSeeItemCount = math.ceil( size.height / self._itemHeight )

    self._expandViewQueue = Queue.new()
    
    local function onExpandViewSchedule()
        self:onExpandViewSchedule()
    end
    self.expandViewSchedule = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onExpandViewSchedule,0,false)

end

function UIExpandListView:finalize()

    if self.expandViewSchedule ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.expandViewSchedule)
    end

end

function UIExpandListView:onExpandViewSchedule()

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
        TimerManager.addTimer(delayTime, delayMove, false)
        
        TimerManager.addTimer(self._preLoadDelay, function()
            self:delayPushPool()
        end, false)
    else
        local index = 1
        local function updateDataCallback()
            if index <= self._maxSeeItemCount + preLoadNum then
                self:updateDataCallback(0,index - 1, index)
                TimerManager.addTimer(30 , updateDataCallback, false)
            else
                TimerManager.addTimer(30, delayMove, false)
                TimerManager.addTimer(self._preLoadDelay, function()
                    self:delayPushPool()
                end, false)
            end
            index = index + 1
        end
        
        TimerManager.addTimer(30 , updateDataCallback, false)
    end
    
end

--TODO,增加缓存处理
function UIExpandListView:delayPushPool()
    local listView = self._listView
    local items = listView:getItems()
    local count = #items
    local num = ComponentMgr:getListViewItemPoolNum(listView)
    local listViewData = self._listViewData or {}
    if count + num < #listViewData then --还有数据没有填充，先预加载Item
        local item = listView.itemModel:clone()
        ComponentMgr:pushListViewItemPool(listView, item)
--        print("--------delayPushPool------", num, count)
        
        TimerManager.addTimer(self._preLoadDelay, function()
            self:delayPushPool()
        end, false)
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
    
    TimerManager.addTimer(self._preLoadDelay, function()
        self:delayPushPool()
    end, false)
    
    local function callback()
       self._isUpdating = false
    end
    TimerManager.addTimer(300, callback, false)
end

--TODO, 有数据还没有更新，才回调计算
function UIExpandListView:handleListViewMove(isMoveUpdate)
    if self._listViewData == nil  then  --and self._isUpdating == true
        return
    end
    if #self._listViewData == 0 then
        return
    end
    
    local size = self._listView:getContentSize()
    local width = size.width
    local height = size.height

    local x0, y0 = self:scPos2ItemPos(0,0)
    local x2, y2 = self:scPos2ItemPos(width,height)

    local minXTile = self:xPos2Tile(x0)
    local maxXTile = self:xPos2Tile(x2)

    local minYTile = self:yPos2Tile(y2) - 2
    local maxYTile = self:yPos2Tile(y0) + 1
    
    if minYTile <= 0 then
        minYTile = 0
    end
    
    if maxYTile <= 0 then
        maxYTile = 0
    end

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

    if self._lastMinXTile == nil or isMoveUpdate ~= true then
        self:delayUpdateListViewTile(minXTile, maxXTile, minYTile, maxYTile)
    else
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
            self:updateListViewTile(0, y, y - startY + 1, isPush)
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
        self:updateListViewTile(0,j,index+1)
        index = index + 1
    end
end


function UIExpandListView:updateListViewTile(xtile, ytile,delay, isPush)
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


