ItemProxy = class("ItemProxy", BasicProxy)
-- 可以批量使用的其他物品的类型枚举
ItemProxy.OTHER_CAN_BATCH = {
    [1] = 1,
    [2] = 2,
    [3] = 37
}

function ItemProxy:ctor()
    ItemProxy.super.ctor(self)
    self.proxyName = GameProxys.Item
    self:resetAttr()
end

function ItemProxy:finalize( )
	-- body
	ItemProxy.super.ctor(self)
end

function ItemProxy:resetAttr()
    self._itemMap = {}
    self._itemInfo={}   --TODO，此数据无用
end

------------网络数据请求与同步-------------
function ItemProxy:onTriggerNet80011Req(data)
    self:syncNetReq(AppEvent.NET_M8, AppEvent.NET_M8_C80011, data)
end
-- 道具使用
function ItemProxy:onTriggerNet90001Req(data)
    self:syncNetReq(AppEvent.NET_M9, AppEvent.NET_M9_C90001, data)
end

function ItemProxy:onTriggerNet90004Req(data)
    self:syncNetReq(AppEvent.NET_M9, AppEvent.NET_M9_C90004, data)
end

function ItemProxy:onTriggerNet90005Req(data)
    self:syncNetReq(AppEvent.NET_M9, AppEvent.NET_M9_C90005, data)
end

function ItemProxy:onTriggerNet90006Req(data)
    self:syncNetReq(AppEvent.NET_M9, AppEvent.NET_M9_C90006, data)
end

function ItemProxy:onTriggerNet90007Req(data)
    self:syncNetReq(AppEvent.NET_M9, AppEvent.NET_M9_C90007, data)
end

function ItemProxy:onTriggerNet100008Req(data)
    self:syncNetReq(AppEvent.NET_M10, AppEvent.NET_M10_C100008, data)
end

function ItemProxy:initSyncData(data)
    ItemProxy.super.initSyncData(self, data)
    self:onRoleInfoResp(data)
end

function ItemProxy:onTriggerNet80011Resp(data) --随机迁移城市
    self:sendNotification(AppEvent.PROXY_BAG_CHANGEPOINT, data)
end

function ItemProxy:onTriggerNet90001Resp(data)  --道具使用
    if data.rs ~= 0 then
        return
    end
    self:onItemUseResp(data)

    -- Time:09.22  Q:2532 【优化】- 背包使用物品隐藏成功使用提示
    -- 物品使用成功之后飘文字控制
    -- self:showMsgAfterUse(data.typeId)
end

function ItemProxy:onTriggerNet90004Resp(data)  --道具使用发红包改名卡
    self:onItemUseResp(data)
    self:sendNotification(AppEvent.PROXY_BAG_ESPECIALUSE, data)
end

function ItemProxy:onTriggerNet90005Resp(data)
    self:sendNotification(AppEvent.PROXY_BAG_SURFACEGOODSUSE, data)
end

function ItemProxy:onTriggerNet90007Resp(data)  --增加军团贡献度
    self:sendNotification(AppEvent.PROXY_BAG_LEGIONCONTRIBUTE, data)
end

function ItemProxy:onTriggerNet100008Resp(data)  --购买商品回调
    self:sendNotification(AppEvent.PROXY_BUYGOODS_UPDATE, data)
end

function ItemProxy:onTriggerNet30104Resp(data) --仓库满了提示
    self:showSysMessage(TextWords:getTextWord(563))
end


--初始化背包ItemMap
function ItemProxy:onRoleInfoResp(data)
    self._itemMap = {}
    self._itemInfo={}
    local itemList = data.itemList
    self:updateItemInfos(itemList)
end

--面板更新
function ItemProxy:onItemUseResp(data)
    local iteminfos = data.iteminfos
    self:updateItemInfos(iteminfos)
end
--外部的proxy会调用
function ItemProxy:updateItemInfos(itemList)

    local addItemIdList = {}
    local updateItemIdList = {}
    local removeItemIdList = {}
    
    for _, itemInfo in pairs(itemList) do
        if itemInfo.num == 0 then --0表示物品被删除了
            table.insert(removeItemIdList, itemInfo.typeid)
            self._itemMap[itemInfo.typeid] = nil
        else
            if self._itemMap[itemInfo.typeid] == nil then
                table.insert(addItemIdList, itemInfo.typeid)
            else
                table.insert(updateItemIdList, itemInfo.typeid)
            end
            self._itemMap[itemInfo.typeid] = itemInfo
        end
    end
    
    local data = {}
    data.addItemIdList = addItemIdList
    data.updateItemIdList = updateItemIdList
    data.removeItemIdList = removeItemIdList

    self:sendNotification(AppEvent.PROXY_ITEMINFO_UPDATE, data)
    self:updateRedPoint()
end

--TODO
--通过类型ID，拿到道具数量
function ItemProxy:getItemNumByType(typeid)
    local itemNumber = self:getItemNum()
    for k, v in pairs(itemNumber) do
    	if k == typeid then
    	    return itemNumber[k] 
    	end
    end
    return 0 --没有数量
end

--TreasureModule调用
function ItemProxy:setItemNumByType(typeid,num)
    if typeid == typeid then
        if num > 0 then
            if self._itemMap[typeid] then
                self._itemMap[typeid].num = num
            else
                self._itemMap[typeid] = {}
                self._itemMap[typeid].num = num 
                self._itemMap[typeid].typeid = typeid
            end
        else
            self._itemMap[typeid] = nil
        end
    end 
end


function ItemProxy:getItemByType(typeid)
    return self._itemMap[typeid]
end

--匹配num数据排列
function ItemProxy:getItemNum()
    local  itemNum = {}
    for _,v in pairs(self._itemMap) do
        if v.num == 0 then --0表示物品被删除了
            itemNum[v.typeid] = nil
        else
            itemNum[v.typeid] = v.num
        end
    end
    return itemNum
end
--获取所有的物品数据s
function ItemProxy:getAllItemList()
    local list = {}      
    for _, item in pairs(self._itemMap) do   
        local info = ConfigDataManager:getConfigById(ConfigData.ItemConfig, item.typeid)
        if info.ShowType ~= 4 and info.bagType == ItemBagTypeConfig.COMMON_BAG then
            item["sequence"] = info.sequence
            table.insert(list, item)
        end
    end
    table.sort( list, function (a,b) return a.sequence > b.sequence end )
    return list
end
--TODO 通过分类拿到对应的物品数据
--1资源 2增益 3其他 4背包不显示道具
--bagType 背包类型 1正常背包 2宝具  3军械
function ItemProxy:getItemByClassify(classifyid, bagType)
    --分类   
    bagType = bagType or ItemBagTypeConfig.COMMON_BAG
    local itemList = {}
    for _, item in pairs(self._itemMap) do
        local typeid = item.typeid
        local info = ConfigDataManager:getConfigById(ConfigData.ItemConfig, typeid)
        if info.ShowType == classifyid and info.bagType == bagType then
            local data = {}
            data["serverData"] = item
            data["excelInfo"] = info
            data["sequence"] = info.sequence
            table.insert(itemList, data)
        end
    end
    table.sort( itemList, function (a,b) return a.sequence > b.sequence end )
    return itemList
end

--是否能够在背包中直接使用
function ItemProxy:isCanUse(typeid)
    local info = ConfigDataManager:getConfigById(ConfigData.ItemConfig, typeid)
    local flag = true
    local type = info.type
    if type == 5 or type == 6 or type == 7 or type == 17 or type == 38 then
        flag = false
    end
    flag = info.use == 1 --直接配置表
    return flag
end

------
-- 其他道具类是否可以批量使用
-- @param  itemType [int] 道具类型
-- @return state [bool]
function ItemProxy:isOthenCanBatch(itemType)
    local state = false
    for key, value in pairs(ItemProxy.OTHER_CAN_BATCH) do
        if value == itemType then
            state = true
            break
        end
    end
    return state
end


--小红点更新
function ItemProxy:updateRedPoint()
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    redPointProxy:checkBagRedPoint() 
end

-- 90001道具使用成功飘字.
function ItemProxy:showMsgAfterUse(typeId)
    -- body
    local info = ConfigDataManager:getConfigById(ConfigData.ItemConfig, typeId)
    local str = string.format(TextWords:getTextWord(5050), info.name)
    self:showSysMessage(str)
end

-- 缓存当前道具在列表中的位置
function ItemProxy:setCurIndex(index)
    -- body
    if index == nil then
        index = 0
    end
    self._curIndex = index
end

-- 获取当前道具在列表中的位置
function ItemProxy:getCurIndex()
    -- body
    if self._curIndex == nil then
        return 0
    else
        return self._curIndex
    end
end

function ItemProxy:sortList(itemList)
	local data = {}
	for i = 1, #itemList do
		local index = math.floor((i + 1)/2)
		if not data[index] then
			data[index] = {}
			data[index][1] = itemList[i]
		else 
			data[index][2] = itemList[i]
		end
	end
	return data
end 