------------
----增益Buff Proxy
-- TODO 用type+powerId做定时器的key，然后有个待优化的问题是，例如全面开采道具，就会创建5个定时器，结束时连续请求5次

ItemBuffProxy = class("ItemBuffProxy ", BasicProxy)


function ItemBuffProxy:ctor()
    ItemBuffProxy.super.ctor(self)
    self.proxyName = GameProxys.ItemBuff

    self._itemBuffMap = {}
end

function ItemBuffProxy:resetAttr()
end

------------------------------------------------------------------------------
-- 初始化
------------------------------------------------------------------------------
function ItemBuffProxy:initSyncData(data)
    ItemBuffProxy.super.initSyncData(self, data)

	self._bufferShowIds = data.bufferShowIds

    local key = nil
    for k,v in pairs(data.itemBuffInfo) do
    	key,key2 = self:getKey(v.itemId, v.type, v.powerId)
    	if v.remainTime == 0 then
    		-- 删除
    		self._itemBuffMap[key] = nil				
    	else
    		-- 更新、新增

    		-- v.remainTime = 40 --TODO 测试代码

    		self._itemBuffMap[key] = v
    		self:updateItemBuffTime(v.type, v.powerId, key2, v.remainTime,v.buffType)
    	end
    end

end

-------------------------------------------------------------------------------
-- -- 主要检查某些buff道具会对多个属性生效，改为为1个key1个定时器。
-- function ItemBuffProxy:checkKey(itemId, key)
-- 	-- body
-- 	logger:info("checkKey(itemId, key).../// itemId =%d, key =%s", itemId, key)

-- 	local key2 = key

-- 	local itemBuffInfos = clone(self._itemBuffMap)
-- 	if table.size(itemBuffInfos) > 0 then
-- 		local tmpTab = {}
-- 		for k,v in pairs(itemBuffInfos) do
-- 			if v.itemId == itemId then
-- 				v.key = k
-- 				table.insert(tmpTab, v)
-- 				-- logger:info("checkkey...k, v.powerId", k, v.powerId)
-- 			end
-- 		end

-- 		if #tmpTab > 0 then
--     		table.sort(tmpTab, function(a,b) return a.powerId<b.powerId end)

-- 			key2 = tmpTab[1].key
-- 			logger:info("···#tmpTab =%d, key2 =%d",#tmpTab, key2)
-- 		end
-- 	end

-- 	return key,key2
-- end


function ItemBuffProxy:getBufferShowIds()
	return self._bufferShowIds
end

function ItemBuffProxy:getKey(itemId, type, powerId)
	-- body
	local key = nil
	if type ~= nil and powerId ~= nil then
		key = "key_buff_"..type..powerId
	end

	-- key,key2 = self:checkKey(itemId, key) --似乎多余了 o(╯□╰)o
	return key,key
end

function ItemBuffProxy:getBuffsByItem(itemInfo)
	-- body
	local buffTab = {}
	for k,v in pairs(self._itemBuffMap) do
		if v.type == itemInfo.type and v.powerId == itemInfo.powerId then
			table.insert(buffTab, v)
		end
	end

	return buffTab
end

function ItemBuffProxy:updateItemBuffInfo(call, itemInfo, info)
	-- body
	local tmpTab = self:getBuffsByItem(itemInfo)

	-- 新增buff
	if table.size(tmpTab) == 0 and info ~= nil then
		local key,key2 = self:getKey(info.itemId, info.type, info.powerId)
		tmpTab[key] = info
		self._itemBuffMap[key] = info
		-- logger:info("···新增buff itemId =%d, key =%s, remainTime =%d", info.itemId, key, info.remainTime)
	end
	

	local key,key2,remainTime = nil,nil,nil
	for _,v in pairs(tmpTab) do
		key,key2 = self:getKey(v.itemId, v.type, v.powerId)
		
		if call == 1 then --更新buff信息
			if info ~= nil then
				key,key2 = self:getKey(info.itemId, info.type, info.powerId)
			end
			self._itemBuffMap[key] = info

		elseif call == 2 then  --只更新buff的倒计时
			self._itemBuffMap[key].remainTime = info
		end
		

		if info == nil then
			remainTime = 0
			if v.buffType == 1 then 
				table.removeValue(self._itemBuffMap,v)
			end
		elseif type(info) == "table" then
			remainTime = info.remainTime
		else
			remainTime = info
		end		
		-- logger:info("···更新buff  itemId =%d, key =%s, type =%d, powerId =%d, remainTime =%d", v.itemId, key, v.type, v.powerId, remainTime)
		self:updateItemBuffTime(v.type, v.powerId, key2, remainTime,v.buffType)
		

	end

end

------------------------------------------------------------------------------
-- 请求协议
------------------------------------------------------------------------------
--buff倒计时完的请求
function ItemBuffProxy:onTriggerNet90002Req(sendData)
	-- logger:info("buff结束发请求···onTriggerNet90002Req : type =%d, powerId =%d",sendData.type, sendData.powerId)
	self:syncNetReq(AppEvent.NET_M9, AppEvent.NET_M9_C90002, sendData)
end

------------------------------------------------------------------------------
-- 接收协议
------------------------------------------------------------------------------

--buff倒计时完的返回
function ItemBuffProxy:onTriggerNet90002Resp(data)
	if data.rs == 0 then
		local remainTime = data.remainTime
		-- logger:info("buff倒计时完的返回 ...onTriggerNet90002Resp remainTime =%d", remainTime)

		if remainTime == nil or remainTime <= 0 then --TODO 服务器会发负数的过来
			-- 删除定时器
			self:updateItemBuffInfo(1, data, nil)

		else
			-- 时间不同步，更新为服务端的时间
			self:updateItemBuffInfo(2, data, remainTime)
		end
		self:sendNotification(AppEvent.ITEM_BUFF_UPDATE, {}) --TODO 需要优化


	elseif data.rs == -2 then  --TODO 暂时处理rs=-2问题
		local remainTime = data.remainTime
		-- logger:info("buff倒计时完的返回 ...onTriggerNet90002Resp data.rs == -2")

		if remainTime == nil or remainTime == 0 then
			-- 删除定时器
			self:updateItemBuffInfo(1, data, nil)
		end
		self:sendNotification(AppEvent.ITEM_BUFF_UPDATE, {}) --TODO 需要优化
	end
end

function ItemBuffProxy:onTriggerNet20801Resp(data)
	self:sendNotification(AppEvent.BUFF_SHOW_UPDATE, data)
end


function ItemBuffProxy:onTriggerNet90003Req(data)
	--self:onTriggerNet90003Resp(data)
end
--更新推送道具buff加成效果 只推送新增、更新的
function ItemBuffProxy:onTriggerNet90003Resp(data)
	if data.rs == 0 then
		-- table.sort(data.itemBuffInfo, function(a,b) return a.powerId<b.powerId end)
		for k,v in pairs(data.itemBuffInfo) do
			-- v.remainTime = 10 		--TODO 测试代码

			if v.remainTime == nil or v.remainTime == 0 then
				-- 删除
				self:updateItemBuffInfo(1, v, nil)

			else
				-- 更新、新增
				self:updateItemBuffInfo(1, v, v)

			end
		end

		self:sendNotification(AppEvent.ITEM_BUFF_UPDATE, {})


		-- -- 测试代码 start-------------------------------------------------
		-- for _,v in pairs(data.itemBuffInfo) do
		-- 	print("onTriggerNet90003Resp-->itemId, type, powerId, time, remainTime",v.itemId,v.type,v.powerId,v.time,v.remainTime)
		-- end
		-- -- 测试代码 end-------------------------------------------------
	end
end

------------------------------------------------------------------------------
-- 实例变量
------------------------------------------------------------------------------
function ItemBuffProxy:getItemBuffInfos()
	-- body
	-- -- 测试代码 start-------------------------------------------------
	-- for k,v in pairs(self._itemBuffMap) do
	-- 	logger:info("ItemBuffProxy:getItemBuffInfos-->itemBuffInfo--->v.itemId,v.type,v.powerId,v.time",v.itemId,v.type,v.powerId,v.time)
	-- end
	-- -- 测试代码 end-------------------------------------------------

	return self._itemBuffMap
end


------------------------------------------------------------------------------
-- 定时器
------------------------------------------------------------------------------
-- 更新某个道具的倒计时
function ItemBuffProxy:updateItemBuffTime(type, powerId, key, remainTime,buffType)
	-- body
	local sendData = {}
	sendData.type = type
	sendData.powerId = powerId
	sendData.buffType =buffType

	if key ~= nil then
		-- logger:info("...pushRemainTime: type =%d, powerId =%d, key =%s, remainTime =%d", type, powerId, key, remainTime)
		self:pushRemainTime(key, remainTime, AppEvent.NET_M9_C90002, sendData, self.remainTimeCompleteCall)
	end
end

-- 倒计时结束回调
function ItemBuffProxy:remainTimeCompleteCall(sendDataList)
	-- body

	for _,sendData in pairs(sendDataList) do
		self:onTriggerNet90002Req(sendData)
	end
end

-------------------------------------------------------------------------------
function ItemBuffProxy:getTimeKeyByMore(itemId, type, powerId)
	-- body
	local key,key2 = self:getKey(itemId, type, powerId)
	local info = self._itemBuffMap[key]

	if info ~= nil then
		return key2
	else
		return nil
	end
end

-- 获取1个道具的倒计时(公共接口)
function ItemBuffProxy:getBuffRemainTimeByMore(itemId, type, powerId)
	-- body
	local key = self:getTimeKeyByMore(itemId, type, powerId)
	local remainTime = self:getRemainTime(key)
	return remainTime
end

