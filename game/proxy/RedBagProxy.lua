-- /**
--  * @Author:	  lizhuojian
--  * @DateTime:	2016-12-13
--  * @Description: 抢红包
--  */

RedBagProxy = class("RedBagProxy", BasicProxy)

function RedBagProxy:ctor()
    RedBagProxy.super.ctor(self)
    self.proxyName = GameProxys.RedBag
    --红包信息map，key为功能id
    self.newRedBagInfosMap = {}
end

function RedBagProxy:initSyncData(data) 
    if data.newRedBagInfos and #data.newRedBagInfos > 0 then
	    self:setNewRedBagInfosMap(data.newRedBagInfos)
	end
end

--红包功能推送新增跟消失 
function RedBagProxy:onTriggerNet230028Resp(data)
	if data.rs == 0 then
 		self:setSingleNewRedBagInfo(data)
		if data.opt == 0 then
			--0去除
			--self:sendNotification(AppEvent.PROXY_UPDATE_VIPSUPPLYVIEW, data)
		elseif data.opt == 1 then
			--1增加
			--self:sendNotification(AppEvent.PROXY_UPDATE_VIPSUPPLYVIEW, data)
            --self:pushRemainTime("oneRedBagActivity_RemainTime" .. data.newRedBagInfo.id,data.newRedBagInfo.time)
            local name = "oneRedBagActivity_RemainTime" .. data.newRedBagInfo.id
            local time = data.newRedBagInfo.time
            self:pushRemainTime(name,time, AppEvent.NET_M23_C230028,data.newRedBagInfo.id,self.oneRedBagActivityComplete)
		end
    end
end

--红包数量变更服务器3秒主动推送，当检查有数据更变的时候
function RedBagProxy:onTriggerNet230029Resp(data)
	if data.rs==0 then
		self:updateSingleNewRedBag(data)
	end
	--增加updata事件，通知模块刷新界面
	-- self:sendNotification(AppEvent.PROXY_UPDATE_VIPSUPPLY_RECEIVE, data)
end


--抢红包
function RedBagProxy:onTriggerNet230027Req(data)
	self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230027, data)
end
function RedBagProxy:onTriggerNet230027Resp(data)

	if data.rs == 0 then
		--领取后开启冷却时间
		-- print("------data.time---in------onTriggerNet230027Resp-------")
		-- print(data.time)
		local name = "RedBag_CoolingTime" ..  data.id
		local coolTime = data.time
		self:pushRemainTime(name,data.time,AppEvent.NET_M23_C230027,data.id,self.oneRedBagCoolingTimeComplete)
		--奖励弹窗
		self:sendNotification(AppEvent.PROXY_REDBAGI_OPEN, data.rewards)
		self:minusOneRedBagNum(data.id)
	end

end
function RedBagProxy:oneRedBagActivityComplete(args)
    -- print("oneRedBagActivityComplete")
    local name = "oneRedBagActivity_RemainTime" .. args[1]
	self._remainTimeMap[name] = nil
    --删除红包Info in map
    local data = {}
    data.opt = 0
    data.newRedBagInfo = {}
    data.newRedBagInfo.id = args[1]
    self:setSingleNewRedBagInfo(data)

end
function RedBagProxy:oneRedBagCoolingTimeComplete(args)
    -- print("oneRedBagCoolingTimeComplete")
    local name = "RedBag_CoolingTime" ..  args[1]
	self._remainTimeMap[name] = nil
end


function RedBagProxy:resetCountSyncData()

end
--红包信息Map
function RedBagProxy:setNewRedBagInfosMap(data)
	--self.newRedBagInfos = data
	for _,v in ipairs(data) do
		self.newRedBagInfosMap[v.id] = v
        if v.endTime == 0 then
            local name = "oneRedBagActivity_RemainTime" .. v.id
            self._remainTimeMap[name] = nil
		    --删除红包Info in map
		    local data = {}
		    data.opt = 0
		    data.newRedBagInfo = {}
		    data.newRedBagInfo.id = v.id
		    self:setSingleNewRedBagInfo(data)
        elseif v.endTime >  0 then
            local name = "oneRedBagActivity_RemainTime" .. v.id
            local time = v.time
            self:pushRemainTime(name,time, AppEvent.NET_M23_C230028,v.id,self.oneRedBagActivityComplete)
        end
	end
end
function RedBagProxy:getNewRedBagInfosMap()
	return	self.newRedBagInfosMap
end
function RedBagProxy:getNewRedBagInfos()
	local info = TableUtils:map2list(self.newRedBagInfosMap)
	return	info
end
function RedBagProxy:setSingleNewRedBagInfo(data)
	if data.opt == 0 then
		self.newRedBagInfosMap[data.newRedBagInfo.id] = nil
	elseif data.opt == 1 then
		self.newRedBagInfosMap[data.newRedBagInfo.id] = data.newRedBagInfo
	end
    --通知toolbar
    self:sendNotification(AppEvent.PROXY_UPDATE_REDBAGINFOS)
    
end
function RedBagProxy:updateSingleNewRedBag(data)
	if self.newRedBagInfosMap[data.id] then
		if data.num > 0 then
			self.newRedBagInfosMap[data.id].num = data.num
		else
		    --删除红包Info in map
		    local tdata = {}
		    tdata.opt = 0
		    tdata.newRedBagInfo = {}
		    tdata.newRedBagInfo.id = data.id
		    self:setSingleNewRedBagInfo(tdata)
		end
	else
		if data.num > 0 then
		    --增加红包Info in map
		    local tdata = {}
		    tdata.opt = 1
		    tdata.newRedBagInfo = {}
		    tdata.newRedBagInfo.id = data.id
		    tdata.newRedBagInfo.num = data.num
		    self:setSingleNewRedBagInfo(tdata)
		end
	end
end
--抢一次红包后主动减一次红包数量，等3秒推送来了在刷新真实数据
function RedBagProxy:minusOneRedBagNum(id)
	if self.newRedBagInfosMap[id] then
		self.newRedBagInfosMap[id].num = self.newRedBagInfosMap[id].num - 1
	    --通知toolbar
	    self:sendNotification(AppEvent.PROXY_UPDATE_REDBAGINFOS)
	end
end