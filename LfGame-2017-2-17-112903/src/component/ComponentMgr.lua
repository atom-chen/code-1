require "RichText"
ComponentMgr = class("ComponentMgr")


--[[
	创建富文本，返回富文本和真实宽度

	--imageview loadtexture模式默认读plist或者textureCache。
	--imageview loadtexture模式默认读plist或者textureCache。
	--imageview loadtexture模式默认读plist或者textureCache。

	参数：params嵌套的table   txt字段用于创建label fontSize字段用于设置lable尺寸 color字段用于设置label的颜色 
	pos字段用于下划线和当前控件的位置偏差，一般传cc.p(0,0)
	isUnderLine字段指定为1才能划线
	img字段用于创建imageview  
	data字段用于回调函数的参数
	所有控件统一回调函数，但是在回调函数里面可以根据参数不同做不同的操作。如果需要回调函数，必须要传data字段，不传默认不回调
	
	maxwidth:设置最大宽度，用于自动换行
	color:全局颜色参数，但是以每个table中的color为优先
	callback:回调函数，不置空必须要传data字段

	例子：
	local p1 = {}
 	p1.txt = "11dddddddd"
 	p1.data = "11撒旦是大事!@#$%^&*())__+''|:}{~!1**卧槽**11"
	p1.color = cc.c3b(200, 120, 0)
	p1.isUnderLine = 1
 	p1.pos = cc.p(0,0)
 	local p2 = {}
 	p2.img = "1-40.png"
 	p2.data = "1-40.png"

 	local p3 = {}
 	p3.txt = "11撒旦是大事!@#$%^&*())__+''|:}{~!1**卧槽**11"
 	p3.data = "11撒旦是大事!@#$%^&*())__+''|:}{~!1**卧槽**11"
	p3.color = cc.c3b(200, 120, 155)

	local params = {}
	params[1] = p1
	params[2] = p2
	params[3] = p3
	

	getRich(params, 300, cc.c3b(200, 120, 155), nil, nil)

	--imageview loadtexture模式默认读plist或者textureCache。
	--imageview loadtexture模式默认读plist或者textureCache。
	--imageview loadtexture模式默认读plist或者textureCache。
]]
function ComponentMgr:getRichLabel(params, maxwidth, color, callback, lineSize)
	local rich = RichLabel:create()
	rich:setData(params, maxwidth, color, lineSize)
	if callback then
		rich:setOnClickHandle(callback)
	end
	local lines = rich:getLines()
	local width = 0
	if lines == 1 then
		width = rich:getRealWidth()
	else
		width = maxwidth
	end
	return rich, width
end

function ComponentMgr:getEditBox(uiType, parent, size, bg, placeHolder, maxLenght, fontSize)
	bg = bg or "ui/input.png"
	fontSize = fontSize or 22
	placeHolder = placeHolder or "请输入："
	local bgSpr = cc.Scale9Sprite:create(bg)
	size = size or bgSpr:getContentSize()
	maxLenght = maxLenght or 5
	print("editBox maxLenght is : "..maxLenght)
	local editBox = cc.EditBox:create(size, bg, uiType)
	editBox:setPlaceHolder(placeHolder)
	editBox:setFontSize(fontSize)
	editBox:setMaxLength(maxLenght)
	parent:addChild(editBox)
	return editBox
end

function ComponentMgr:createNode(csb_name)
	cc.CSLoader:setIsUesPlist(true)
    local node = cc.CSLoader:createNode(csb_name)
    return node
end

function ComponentMgr:showMsgBox(data)
	MsgBox:create(data)
end

function ComponentMgr:addTouch(widget, callback, obj)
	widget:setTouchEnabled(true)
	widget:addTouchEventListener(function(sender, event)
		if event == ccui.TouchEventType.ended then
			if type(callback) == "function" then
                if obj ~= nil then
                    callback(obj, widget)
                else
                    callback(widget)
                end
				
			end
		end
	end)
end

function ComponentMgr:showAlert(data)
	Alert:create(data)
end

function ComponentMgr:getRichText(param, maxwidth, callback, this, auto, rowSpace)
	local ret = RichText:create()
	ret:setDrawType(auto or 1)
	ret:setRowSpace(rowSpace or 0)
	ret:init(param, maxwidth, callback, this)
	return ret
end

--listView 列表Widget
--infos 渲染的数据列表
--obj 回调Object
--rendercall 渲染的回调方法
--isInitAll 是否初始化就初始化全部
function ComponentMgr:renderListView(listView, infos, obj, rendercall, isInitAll)
	for _, info in pairs(infos) do
        rawset(info,"isUpdate", true)
    end
    listView.infos = infos
    if listView.isInit ~= true then
        local item = listView:getItem(0)
        --设置回弹
        listView:setBounceEnabled(true) 
        local margin = listView:getItemsMargin()
        if margin < 5 then
        	listView:setItemsMargin(5)
        end
        item:retain()
        listView:removeItem(0)
        listView.scrScale = item:getScale()
        
        self:insertListViewModel(item)
        
        listView:setItemModel(item)
        listView.itemModel = item
        item:setVisible(false)
        listView.isInit = true
        
        local jumpToTop = listView.jumpToTop
        local function delayJumpToTop()
            jumpToTop(listView)
        end
        listView.jumpToTop = function()
        	TimerManager.addTimer(30, delayJumpToTop, false, listView)
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
                    item = self:popListViewItemPool(listView)
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
    
   
   --入池，而不是直接删掉
    local index = #infos
    while listView:getItem(index) ~= nil do
        if #listView:getItems() == 1 then  --留一个 防止只加一个时，快速拖动，导致的游戏崩溃问题
            local item = listView:getItem(0)
            item:setVisible(false)
            break
        end
        local item = listView:getItem(index)
        self:pushListViewItemPool(listView, item)
        
        listView:removeItem(index)
    end 
end

--保存retain过的item，最后release
function ComponentMgr:insertListViewModel(model)
    if self._listViewModelList == nil then
        self._listViewModelList = {}
    end
    
    table.insert(self._listViewModelList, model)
end

--每个listview都建立一个池用来保存item，用于重复利用
function ComponentMgr:pushListViewItemPool(listView, item, isCustom)
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

function ComponentMgr:addListViewPool(listView)
    if self.listViewPool == nil then
        self.listViewPool = {}
    end
    table.insert(self.listViewPool,listView)
end

--释放掉缓存数据
function ComponentMgr:finalizeListViewItemPool()
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

--从池中取出Item
function ComponentMgr:popListViewItemPool(listView, isCustom)
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

--获取池里面的个数
function ComponentMgr:getListViewItemPoolNum(listView)
    if listView.itemPool == nil then 
        return 0
    end
    return #listView.itemPool
end

function ComponentMgr:getChildByName(parent, name)
	local ary = Utils.split(name,"/")
    
    local curPanel = parent
    for _, key in pairs(ary) do
    	curPanel = curPanel:getChildByName(key)
    end
    
    return curPanel
end

function ComponentMgr:finalize()
    if self._listViewModelList ~= nil then
        for _, model in pairs(self._listViewModelList ) do
            model:release()
        end
    end
    self._listViewModelList = nil
    self:finalizeListViewItemPool()
end