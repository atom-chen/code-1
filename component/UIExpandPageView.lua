
--[[
自定义的PageView，实现循环翻页
index从0开始
]]
UIExpandPageView = class("UIExpandPageView")

function UIExpandPageView:ctor(pageView)
    
    self._pageView = pageView
    self._pageList = {}
    self._eventState = true --pageview 响应按钮的状态

    self:registerEvents()
end

function UIExpandPageView:initPage(dataList, initcallback, obj)
    self._obj = obj
    local firstPage = self._pageView:getPage(0)
    firstPage:setVisible(true)
    
    for index, data in pairs(dataList) do
        local page = self._pageView:getPage(index - 1)
        if page == nil then
            page = firstPage:clone()
            if index == #data then --最后一个直接插入到第一行
                self._pageView:insertPage(page, 0)
            else
                self._pageView:addPage(page)
            end
            
        end 
        page.index = index - 1
        table.insert(self._pageList,page)
        initcallback(obj, page, data)
    end
    
    -- self._curPageIndex = 1
    self._curPageIndex = 0 --起始下标=0
end

function UIExpandPageView:registerEvents()
    local function onPageViewListener(sender)
        --self:onPageViewListenerHandler() -- Android下是没有回调的，接口废弃
    end 
    self._pageView:addEventListener(onPageViewListener)
end

-- 每次scrollToPage()都会走这里
function UIExpandPageView:onPageViewListenerHandler()
    if self._eventState then
        self._eventState = false
        logger:error("----------------------------------------00000---------------------------------------")

        local pageView = self._pageView
        local curPageIndex = pageView:getCurPageIndex()
        local page = pageView:getPage(curPageIndex)

        -- print(" 上 curPageIndex、page.index",curPageIndex, page.index)

        local pageNum = #pageView:getPages()
        if curPageIndex == 0 then --翻到到第一页了，要把最后一页移动过去
            local page = pageView:getPage(pageNum - 1)
            page:retain()
            pageView:removePageAtIndex(pageNum - 1)
            pageView:insertPage(page, 0)
            page:release()

            pageView:scrollToPage(1)
            pageView:update(10)

            page = pageView:getPage(1)
            -- print("···--翻到到第1页了，要把最后页移动过去",curPageIndex)
        end
        if curPageIndex == pageNum - 1 then --翻到到第最后页了，要把第一页移动过去
            local page = pageView:getPage(0)
            page:retain()
            pageView:removePageAtIndex(0)
            pageView:insertPage(page, pageNum)
            page:release()

            pageView:scrollToPage(pageNum - 2)
            pageView:update(10)

            page = pageView:getPage(pageNum - 2)
            -- print("···--翻到到最后页了，要把第1页移动过去",curPageIndex)

        end
        self._curPageIndex = page.index
        -- print(" 下 page.index",page.index)
        
        if self._pageMoveCallback ~= nil then
            self._pageMoveCallback(self._obj, self._curPageIndex)
        end

        logger:error("----------------------------------------11111---------------------------------------")
        self._eventState = true
    end

end

------------------------------------

------
-- 移动到指定page
-- @param  index [int] 页码，从1开始算
-- @return nil
function UIExpandPageView:moveToPage(index)
    index = index - 1
    local pageView = self._pageView
    local curPageIndex = pageView:getCurPageIndex()
    local page = pageView:getPage(curPageIndex)
    local pageIndex = page.index
    local mark =  index - page.index
    if curPageIndex == 1 and mark < -1 then
        mark = mark + 6
    elseif curPageIndex == 2 and mark < -2 then 
        mark = mark + 6
    elseif curPageIndex == 3 and mark > 2 then
        mark = mark - 6
    elseif curPageIndex == 4 and mark > 1 then
        mark = mark - 6
    end  
    if mark > 0 then
        for i = 1, mark do
            self:moveRight()
        end
    elseif mark < 0 then
        for i = 1, -mark do
            self:moveLeft()
        end    
    end
end

function UIExpandPageView:getPage(index)
    return self._pageList[index + 1]
end

function UIExpandPageView:getCurPageIndex()
    return self._curPageIndex
end

function UIExpandPageView:addCallBack(callback)
    self._pageMoveCallback = callback
end

function UIExpandPageView:getPages()
    return self._pageList
end

--向左翻页
function UIExpandPageView:moveLeft()
    local curPageIndex = self._pageView:getCurPageIndex()
    -- print("上 moveLeft curPageIndex=",curPageIndex)
    curPageIndex = curPageIndex - 1
    if curPageIndex < 0 then
        -- curPageIndex = 0
        local pageNum = #self._pageView:getPages()
        curPageIndex = pageNum - 1
    end
    self._pageView:scrollToPage(curPageIndex)
    -- print("下 moveLeft curPageIndex=",curPageIndex)

    TimerManager:addOnce(100, self.onPageViewListenerHandler, self)
end

--向右翻页
function UIExpandPageView:moveRight()
    local curPageIndex = self._pageView:getCurPageIndex()
    -- print("上 moveRight curPageIndex=",curPageIndex)
    self._pageView:scrollToPage(curPageIndex + 1)

    curPageIndex = self._pageView:getCurPageIndex()
    -- print("下 moveRight curPageIndex=",curPageIndex)

    TimerManager:addOnce(100, self.onPageViewListenerHandler, self)
end

--重置
function UIExpandPageView:resetPageView()
    local pageList = {}
    local pages = self._pageView:getPages()
    for _, page in pairs(pages) do
        pageList[page.index + 1] = page
        page:retain()
        self._pageView:removePageAtIndex(0) --全删掉
    end
    
    local pageNum = #pageList
    local index = 1
    for _, page in pairs(pageList) do
        if index == pageNum then
            self._pageView:insertPage(page, 0)
        else
            self._pageView:addPage(page)
        end
        index = index +1
    end
    
    for _, page in pairs(pages) do
        page:release()
    end
    
    self._pageView:moveToPage(1)
    self._curPageIndex = 0
end


