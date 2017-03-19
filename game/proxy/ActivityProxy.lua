-- /**
--  * @Author:    fzw
--  * @DateTime:    2016-04-07 21:15:46
--  * @Description: 活动数据代理
--  */

ActivityProxy = class("ActivityProxy", BasicProxy)

function ActivityProxy:ctor()
    ActivityProxy.super.ctor(self)
    self.proxyName = GameProxys.Activity

    self._limitActivityInfo = {}
    self.allInfo = {}
    self.labaXinxi = {}
    self.rankInfo = {}
    self.moduleName = {}
    self.allRedPint = {}
    self.allTotal = {}
    self.pos = 1
    self.pkgKey = "legionShare"
    self.limitKey = "limitKey"
    self.actKey = "activity"
    -- self.time = {10*60, 15*60, 30*60, 60*60, 90*60}
    self.lastTime = 0
    self.firstSend = true
    self.chatName = ""
    self.allLaBaEffectid = {}
    -- self.time = {60, 90, 120, 150, 200}
    self._partsGodInfos = nil

    self.spendTimes = 0  --金鸡砸蛋
    self.remainTimes = 0
    self.squibInfos = {} --爆竹数据
    self.martialInfos = {} --武学讲堂数据

    self.__oldSpend = nil  --登陆时的今日累计消费。第二天后自动为0。  *不可随意修改

    self._lastReqTime = os.time()
end

function ActivityProxy:resetAttr()
    self._allActivityInfo = {}
    self._activeIDTmp = {}
    self._labaActivityInfo = {}
    self.allTipsData = {}
    self._limitActivityInfo = {}
    self.redPkgInfo = {}
    self._partsGodInfos = nil
    self.labaXinxi = {}
    self.moduleName = {}
    self.allRedPint = {}
    self.allTotal = {}
    self._removeQueue:clear()
    self._frameQueue:clear()

end

function ActivityProxy:resetCountSyncData()

    self.__oldSpend = 0

    --清0砸蛋次数
    self:resetEggTimes()
    
    for k,v in pairs(self.labaXinxi) do
        self.labaXinxi[k].free = 1
        local data = {}
        data.rs = 0
        data.labaInfo = self.labaXinxi[k]
        -- self:onTriggerNet230003Resp(data)

        if not self.labaXinxi then self.labaXinxi = {} end
        self.labaXinxi[data.labaInfo.id] = data.labaInfo
        self._labaActivityInfo = data.labaInfo
        self.LabaNum = data.labaInfo.free
        self:sendNotification(AppEvent.PROXY_LABA_INFO, false)
        -- self:updateLimitRedpoint()
    end
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    redPointProxy:setPullBarRed()

    self.allRedPint = {}
    self:setPartsGodFree()
    self:updateTurnTable()

    for k,v in pairs(self._allActivityInfo) do
        if v.resettime == 1 then
           -- print("名字-====",v.name)
            self._allActivityInfo[k].already = 0
            local num = self:getTotalById(v.activityId)
            num = num or 200
            self._allActivityInfo[k].total = num
            if v.effectInfos then
                for key,value in pairs(self._allActivityInfo[k].effectInfos) do
                    if self._allActivityInfo[k].effectInfos[key].iscanget ~= 2 then
                        self._allActivityInfo[k].effectInfos[key].iscanget = 3
                    end
                    if value.limit then
                        self._allActivityInfo[k].effectInfos[key].limit = 0
                    end
                end
            end
            --大按钮重置的type未明
            -- if v.buttons then
            --     for key,value in pairs(self._allActivityInfo[k].buttons) do
            --         if self._allActivityInfo[k].buttons[key].type == 2 then
            --             self._allActivityInfo[k].buttons[key].type = 1
            --         end
            --     end
            -- end
        end
    end

    local eProxy = self:getProxy(GameProxys.EmperorAward)
    eProxy:resetData()

    local vProxy = self:getProxy(GameProxys.VipRebate)
    vProxy:resetData()

    local gProxy = self:getProxy(GameProxys.GeneralAndSoldier)
    gProxy:resetData()



    self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
    self.proxy:setAllLimitActivity()

    --清空爆竹酉礼数据
    self:cleanClientSquibInfo()

    --充值武学讲堂免费次数
    self:resetMartialFreeTime()

    --通知所有活动界面，0点刷新
    self:sendNotification( AppEvent.PROXY_UPDATE_ACTVIEW_TIMEOVER )

    
end

function ActivityProxy:registerNetEvents()
    -- self:registerNetEvent(AppEvent.NET_M2, AppEvent.NET_M2_C20200, self, self.onUpdateTipsResp)--所有小红点缓存
    self:addEventListener(AppEvent.PROXY_UPDATE_ROLE_INFO, self, self.updateRoleInfoRsp)
    self:addEventListener(AppEvent.PROXY_UPDATE_BUFF_NUM, self, self.updateRoleBagRsp)
end

function ActivityProxy:unregisterNetEvents()
    -- self:unregisterNetEvent(AppEvent.NET_M2, AppEvent.NET_M2_C20200, self, self.onUpdateTipsResp)--所有小红点缓存
    self:removeEventListener(AppEvent.PROXY_UPDATE_ROLE_INFO, self, self.updateRoleInfoRsp)
    self:removeEventListener(AppEvent.PROXY_UPDATE_BUFF_NUM, self, self.updateRoleBagRsp)
end

function ActivityProxy:onTriggerNet230000Req(data) 
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230000, data) 
end

function ActivityProxy:onTriggerNet230001Req(data, id, flag, isBuy)
    self.curId = id
    self.isBig = flag
    self.isBuy = isBuy
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230001, data)
end

function ActivityProxy:onTriggerNet230002Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230002, data)
end

function ActivityProxy:onTriggerNet230003Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230003, data)
end

function ActivityProxy:onTriggerNet230005Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230005, data)
end

function ActivityProxy:onTriggerNet230006Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230006, data)
end

function ActivityProxy:onTriggerNet230008Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230008, data)
end

function ActivityProxy:onTriggerNet230009Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230009, data)
end

function ActivityProxy:onTriggerNet230010Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230010, data)
end

function ActivityProxy:onTriggerNet230011Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230011, data)
end

function ActivityProxy:onTriggerNet230015Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230015, data)
end

function ActivityProxy:onTriggerNet230016Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230016, data)
end

function ActivityProxy:onTriggerNet230018Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230018, data)
end

function ActivityProxy:onTriggerNet230022Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230022, data)
end

function ActivityProxy:onTriggerNet230030Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230030, data)
end
function ActivityProxy:onTriggerNet230031Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230031, data)
end

-- 初始化活动数据
function ActivityProxy:initSyncData(data)
    ActivityProxy.super.initSyncData(self, data)
    self._frameQueue = FrameQueue.new(2)
    self._removeQueue = FrameQueue.new(1)
    self.allTotal = {}
    self.proxy = self:getProxy(GameProxys.RedPoint)
    self.onLineTime = data.actorInfo.totalOnlineTime
    local tempdata = {}
    tempdata.activitys = data.activitys
    tempdata.nextOpenId = data.actorInfo.nextOpenId
    tempdata.nextOpenTime = data.actorInfo.nextOpenTime
    table.sort(tempdata.activitys, function(a, b)
        return a.sort < b.sort
    end)
    tempdata.rs = 0
    self:onTriggerNet230000Resp(tempdata)
    local tempdata = {}
    tempdata.nextOpenId = data.actorInfo.nextLimtOpenId
    tempdata.nextOpenTime = data.actorInfo.nextLimtOpenTime
    tempdata.activitys = data.limitActivitys
    tempdata.rs = 0
    self._delyData = tempdata
    self.redPkgInfo = data.redBagInfo
    self.turntableInfos = data.turntableInfos

    --金鸡砸蛋数据
    -- if rawget( data, "smashEggInfos" ) then
    if data.smashEggInfos then
        self:onUpdateSmashEgg(data)
    end
    --春节活动爆竹信息
    if data.squibInfos and #data.squibInfos > 0 then
        self:setSquibInfos(data.squibInfos)
    end
    --武学讲坛学习信息
    if data.martialInfos and #data.martialInfos > 0 then
        self:setMartialInfos(data.martialInfos)
    end
end

function ActivityProxy:afterInitSyncData()
    local roleProxy = self:getProxy(GameProxys.Role)
    self.vipLevel = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_vipLevel)
    self.allSpend = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_all_spend_coin)
    self.__oldSpend = self.__oldSpend or roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_all_spend_coin)  --登陆时的今日累计消费。第二天后自动为0。  *不可随意修改

    self:onTriggerNet230002Resp(self._delyData)

end

--根据活动id返回单个活动信息,
function ActivityProxy:getDataById(id)
    if type(self._allActivityInfo)~="table" then
        return false
    end
    for k,v in pairs(self._allActivityInfo) do
        if v.activityId == id then
            return true, v, id
        end
    end
    return false
end

--根据活动条件，获取单个活动信息
function ActivityProxy:getDataByCondition(condition)
    if type(self._allActivityInfo)~="table" then
        return false
    end
    for k,v in pairs(self._allActivityInfo) do
        if v.conditiontype == condition then
            return true, v, v.activityId
        end
    end
    return false
end

function ActivityProxy:getTurnTableInfo(id)
    local roleProxy = self:getProxy(GameProxys.Role)
    local allSpend = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_all_spend_coin)
    for k,v in pairs(self.turntableInfos) do
        v.spend = allSpend
        if v.id == id then
            return self.turntableInfos[k]
        end
    end
end

function ActivityProxy:getCurActivityData()
    return self.curActivityData
end

function ActivityProxy:setCurGetId(id)
    self.curId = id
end

--在线礼包倒计时
function ActivityProxy:updateOnlineTime()

    for k,v in pairs(self.time) do
        local scheduKey = "onlineTime" .. k
        for key,value in pairs(v) do
            if value - self.onLineTime > 0 then
                self:pushRemainTime(scheduKey..key, value - self.onLineTime, 230012, k..key, function(this, param)
                    self._remainTimeMap["onlineTime"..param[1]] = nil
                    self:onTriggerNet230012Req({})
                end)
            end
        end
    end

    for k,v in pairs(self.otherTime) do
        local scheduKey = "otherOnlineTime" .. k
        for _,value in pairs(v) do
            if value > 0 then
                self:pushRemainTime(scheduKey, value, 230036, k, function(this, param)
                    self._remainTimeMap["otherOnlineTime"..param[1]] = nil
                    self:onTriggerNet230036Req({activityId = param[1]})
                end)
            end
        end
    end
end

function ActivityProxy:onTriggerNet230012Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230012, data)
end

--请求修改在线礼包的领取状态。。不可领---->可领取（倒计时后请求）
function ActivityProxy:onTriggerNet230012Resp(data)
    if data.rs == 0 then
        self.onLineTime = data.totalOnlineTime
        local curTime = data.totalOnlineTime
        for _,activity in pairs(self._allActivityInfo) do
            if activity.effectInfos then
                for k,v in pairs(activity.effectInfos) do
                    if v.conditiontype == 102 and curTime >= v.condition2 and v.iscanget == 3 then
                        self._allActivityInfo[_].effectInfos[k].iscanget = 1
                    end
                end
            end
        end
        self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
        self.proxy:checkActivityRedPoint()
        self.proxy:checkArmyBigRewardRedPoint()
    else
        self:updateOnlineTime()
    end
end

function ActivityProxy:getPkgInfoByEffectId(id)
    for k,v in pairs(self.redPkgInfo) do
        if v.id == id then
            return self.redPkgInfo[k]
        end
    end
end

function ActivityProxy:getTotalById(id)
    local rs = {}
    if not self.allTotal[id] then
        return nil
    end
    for k,v in pairs(self.allTotal[id]) do
        table.insert(rs, v.totalLimit)
    end
    table.sort( rs, function(a, b)
        return a < b
    end )
    return rs[1]
end

-- 活动列表
function ActivityProxy:onTriggerNet230000Resp(data)
    if data.rs == 0 then
        if self._removeQueue then
            self._removeQueue:finalize()
            self._removeQueue = nil
            self._removeQueue = FrameQueue.new(1)
        end
        self._allActivityInfo = {}
        self.time = {}--在线礼包的倒计时  conditiontype = 102
        self.otherTime = {}  --军团募集类型活动的倒计时  conditiontype = 129
        self._allActivityInfo = data.activitys
        
        for i=1,#data.activitys do
            self:checkRemove(data.activitys[i], self:getScheduKey(self.actKey, data.activitys[i].activityId), true)
            local v = data.activitys[i]
            if v.effectInfos then
                self.allTotal[v.activityId] = v.effectInfos
                self.time[v.activityId] = self.time[v.activityId] or {}
                self.otherTime[v.activityId] = self.otherTime[v.activityId] or {}
                for k,value in pairs(v.effectInfos) do
                    if value.conditiontype == 102 then
                        table.insert(self.time[v.activityId], value.condition2)
                    elseif value.conditiontype == 129 then
                        table.insert(self.otherTime[v.activityId], value.condition2 - value.condition1)
                    end
                end
            end
        end
        self:updateOnlineTime()
        self:updateLegionGiftData()
        
        self:checkOpen(data, self.actKey, AppEvent.NET_M23_C230010)

    end
end

function ActivityProxy:onTriggerNet230018Resp(data)
    if data.rs == 0 then
        local param = {}
        param.rbrInfo = data.rbrInfo
        param.name = self.chatName
        if data.getMoney then
            local effectId = data.bagid
            local config = ConfigDataManager:getConfigById(ConfigData.RedBagConfig, effectId)
            local redBagInfo = self:getPkgInfoByEffectId(effectId)
            if redBagInfo then
                redBagInfo.num = redBagInfo.num + data.getMoney
            end
        end
        if data.getMoney == 0 then
            local roleProxy = self:getProxy(GameProxys.Role)
            local myName = roleProxy:getRoleName()
            for k,v in pairs(data.rbrInfo) do
                if v.name == myName then
                    param.showNum = v.num
                    break
                end
            end
        else
            param.showNum = data.getMoney
        end

        self:sendNotification(AppEvent.PROXY_SHOW_REDPKGVIEW, param)
    end
end

--普通活动领取奖励，通过rs，客户端自己修改type或者iscanget或者limit(限购次数+1)
--@self.isBig  是不是大按钮
--@self.curId  当前领取奖励的活动id
--@self.isBuy  是不是限购
function ActivityProxy:onTriggerNet230001Resp(data)
    if data.rs == 0 then
        local flag, info, id = self:getDataById(data.activityId)
        if not flag then
            return
        end
        if self.isBig then
            if self.curId and info.buttons then
                if info.uitype == 2 then
                    info.buttons[self.curId] = nil
                else
                    info.buttons[self.curId].type = 3
                    info.buttons[self.curId].name = "已领取"
                end
            end
        else
            if self.curId and info.effectInfos then
                if self.isBuy then
                    info.effectInfos[self.curId].limit = info.effectInfos[self.curId].limit + 1
                else
                    info.effectInfos[self.curId].iscanget = 4
                end
                
                info.effectInfos[self.curId].effectId = data.effectId
            end
        end
        self.proxy:checkActivityRedPoint()
        self.proxy:checkArmyBigRewardRedPoint()
        table.sort( self._allActivityInfo, function(a,b)
            return a.sort < b.sort
        end )
        -- self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
        self:sendNotification(AppEvent.PROXY_UPDATE_ONE, info)

        -- print("活动关闭类型===", info.endjudge)
        --根据活动的关闭类型判断是否需要请求关闭
        --[[
            endjudge:0:时间到消失,1:奖励全部领取完消失,2:活动时间到并且奖励全部领取完消失
        ]]
        if info.endjudge == 1 then
            local num = 0
            if info.buttons then
                for k,v in pairs(info.buttons) do
                    if v.type == 2 or v.type == 4 then
                        num = num + 1
                    end
                end
            end
            if info.effectInfos then
                for k,v in pairs(info.effectInfos) do
                    -- data.activityId ~= 15:同盟大礼可领取状态不需要此验证
                    if v.iscanget >= 1 and v.iscanget <= 3 and data.activityId ~= 15 then
                        num = num + 1
                    end
                end
            end
            if num == 0 then
                local sendData = {}
                sendData.checkActivityIds = {id}
                self:onTriggerNet230008Req(sendData)
            end
        end
        if info.endjudge == 2 then
            local num = 0
            if info.buttons then
                for k,v in pairs(info.buttons) do
                    if v.type == 2 then
                        num = num + 1
                    end
                end
            end
            if info.effectInfos then
                for k,v in pairs(info.effectInfos) do
                    if v.iscanget == 3 then
                        num = num + 1
                    end
                end
            end
            if num == 0 then
                self:onTriggerNet230008Req({checkActivityIds = {info.activityId}})
            end
        end
        
    end
end

--检测下一个活动开启倒计时
function ActivityProxy:checkOpen(data, key, cmdId)
    -- print("显示活动===",data.nextOpenId,"===",data.nextOpenTime)
    if  data.nextOpenId and data.nextOpenTime and data.nextOpenId > 0 and data.nextOpenTime > 0 then
        local time = data.nextOpenTime
        -- print("还有"..time)
        self:pushRemainTime(self:getScheduKey(key, data.nextOpenId), time, cmdId, {cmdid = tostring(cmdId), id = data.nextOpenId}, function(this, param)
            for k,v in pairs(param) do
                -- print("我要请求啊啊啊啊啊啊"..v.cmdid)
                self._remainTimeMap[self.actKey..v.id] = nil
                if self["onTriggerNet"..v.cmdid.."Req"] and type(self["onTriggerNet"..v.cmdid.."Req"]) == "function" then
                    self["onTriggerNet"..v.cmdid.."Req"](self, {checkActivityIds = v.id})
                end
            end
        end)
    end
end

-- 限时活动列表
function ActivityProxy:onTriggerNet230002Resp(data)
    if data.rs == 0 then
        self.allShareReward = {}
        if self._frameQueue then
            self._frameQueue:finalize()
            self._frameQueue = nil
            self._frameQueue = FrameQueue.new(2)
        end
        if #self._limitActivityInfo > 0 then
            self._limitActivityInfo = data.activitys
        else
            for i=1,#data.activitys do
                table.insert(self._limitActivityInfo, data.activitys[i])
            end
        end
        self:sendNotification(AppEvent.PROXY_UPDATE_LIMIT, #data.activitys>0)
        self:sendNotification(AppEvent.PROXY_NEW_ACT)
        for i=1,#data.activitys do
            self:checkRemove(data.activitys[i], self:getScheduKey(self.limitKey, data.activitys[i].activityId), true)
            local uitype = data.activitys[i].uitype
            if uitype == ActivityDefine.LIMIT_ACTION_LABA_ID then   --拉霸唯一判定 活动ID
                self.allLaBaEffectid[data.activitys[i].effectId] = {activityId = data.activitys[i].activityId,type = 0}
            elseif uitype == ActivityDefine.ACTIVITY_CONDITION_VIP_GO_TYPE then -- 
                local proxy = self:getProxy(GameProxys.VipRebate)
                proxy:set230002Data(data.activitys[i])
            elseif uitype == ActivityDefine.LIMIT_ACTION_VIPBOX_ID then --vip特权宝箱
                local proxy = self:getProxy(GameProxys.VIPBox)
                --proxy:set230002Data(data.activitys[i])
            elseif uitype == ActivityDefine.LIMIT_ACTION_LEGIONSHARE_ID then --有福同享
                self.closeTime = data.activitys[i].endTime
                self.pos = 1
                self.allInfo = {}
                self:onTriggerNet230005Req({})
            elseif uitype == ActivityDefine.LIMIT_ACTION_ORDNANCEFORGING_ID then  --军械神将
                self._partsGodInfos = data.activitys[i]
                local redPointProxy = self:getProxy(GameProxys.RedPoint)
                redPointProxy:setPartsGodRed()
            elseif uitype == ActivityDefine.LIMIT_ACTION_ERERYDAY_ZHUANPAN_ID then
                self:getZPCount(data.activitys[i].activityId)
                -- self:updateLimitRedpoint()
                local redPointProxy = self:getProxy(GameProxys.RedPoint)
                redPointProxy:setDayTrunRed()
            elseif uitype == ActivityDefine.LIMIT_SMASHEGG_ID then  --砸蛋
                self.proxy:setSmashEggRed()
            elseif uitype == ActivityDefine.LIMIT_COLLECTBLESS_ID then  --迎春集福
                self.proxy:setCollectBlessRed()
            end

           

        end
        self:checkOpen(data, self.limitKey, AppEvent.NET_M23_C230011)
        for k,v in pairs(self.allLaBaEffectid) do
            self._frameQueue:pushParams(self.onTriggerNet230003Req, self, v)
        end
    end
end

--通用活动倒计时检测删除函数
function ActivityProxy:checkRemove(data, key, isState)
        if data.lestime and data.lestime > 0 and isState then
            local time = data.lestime
            self:pushRemainTime(key, time, data.activityId, data.activityId, function(this, param)
                self._remainTimeMap[key] = nil
                local sendData = {}
                sendData.checkActivityIds = param
                self._removeQueue:pushParams(self.onTriggerNet230008Req, self, sendData)
            end)
        end
end

-- 拉霸活动信息
function ActivityProxy:onTriggerNet230003Resp(data)
    -- body
    if data.rs == 0 then
        if not self.labaXinxi then self.labaXinxi = {} end
        self.labaXinxi[data.labaInfo.id] = data.labaInfo
        self._labaActivityInfo = data.labaInfo
        self.LabaNum = data.labaInfo.free
        self:sendNotification(AppEvent.PROXY_LABA_INFO, true)
        -- self:updateLimitRedpoint()
        local redPointProxy = self:getProxy(GameProxys.RedPoint)
        redPointProxy:setPullBarRed()
    else
       self:sendNotification(AppEvent.PROXY_LABA_INFO) 
    end
end

function ActivityProxy:getScheduKey(const, param)
    return const..param
end

function ActivityProxy:onTriggerNet230015Resp(data)
    if data.rs == 0 and data.redBagInfo then
        for k,v in pairs(self.redPkgInfo) do
            if v.id == data.redBagInfo.id then
                self.redPkgInfo[k] = data.redBagInfo
                return
            end
        end
    end
end

function ActivityProxy:onTriggerNet230016Resp(data)
    if data.rs == 0 and self.curActivityData then
        local effectId = self.curActivityData.activityId
        local config = ConfigDataManager:getConfigById(ConfigData.RedBagConfig, self.curActivityData.effectId)
        local redBagInfo = self:getPkgInfoByEffectId(effectId)
        if redBagInfo then
            redBagInfo.num = redBagInfo.num - config.price*config.discount*0.01
            redBagInfo.num = redBagInfo.num > 0 and redBagInfo.num or 0
        end
        self:sendNotification(AppEvent.PROXY_UPDATE_ACTVIEW, self.curActivityData)
    end
end

--获取有福同享礼包列表，倒计时
function ActivityProxy:onTriggerNet230005Resp(data)
    if data.rs == 0 then
        for k,v in pairs(data.legionShareInfo) do
            v.pos = self.pos
            v.time = os.time()
            self:pushRemainTime(self:getScheduKey(self.pkgKey, v.pos), v.timeLeft, 230008, v.pos, function(this, param)
                self._remainTimeMap[self:getScheduKey(self.pkgKey, v.pos)] = nil
                for k,v in pairs(param) do
                    self:removeInfo(v)
                    local num = 0
                    if self.LabaNum then
                        num = #self.allInfo + self.LabaNum
                    else
                        num = #self.allInfo
                    end
                    self:sendNotification(AppEvent.PROXY_UPDATE_COUNT, num)
                    self:sendNotification(AppEvent.PROXY_PKG_INFO, self.allInfo)
                    if #self.allInfo == 0 then
                        local data = {}
                        data.checkActivityIds = {}
                        data.checkActivityIds[1] = 18
                        self:onTriggerNet230008Req(data)
                    end
                end
            end)
            table.insert(self.allInfo, v)
            self.pos = self.pos + 1
        end
        self:sendNotification(AppEvent.PROXY_PKG_INFO, self.allInfo)
        self:updateLimitRedpoint()
    end
end

function ActivityProxy:onTriggerNet230006Resp(data)
    self:sendNotification(AppEvent.PROXY_GET_REWARD, data)
    -- self:updateLimitRedpoint()
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    redPointProxy:setChargeShareRed()
end

function ActivityProxy:onTriggerNet230010Resp(data)
    if data.rs == 1 then
        local info = data.activityInfo
        for i=1,#info do
            table.insert(self._allActivityInfo, info[i])
            self.allTotal[info[i].activityId] = info[i].effectInfos
        end
        table.sort(self._allActivityInfo, function(a, b)
            return a.sort < b.sort
        end)
        self.proxy:checkActivityRedPoint()
        self.proxy:checkArmyBigRewardRedPoint()
        self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
        self:checkOpen(data, self.actKey, AppEvent.NET_M23_C230010)
    end

end

function ActivityProxy:onTriggerNet230011Resp(data)
    if data.rs == 0 then
        local param = {}
        param.rs = 0
        param.activitys = {}
        param.nextOpenId = data.nextOpenId
        param.nextOpenTime = data.nextOpenTime
        
        for i=1,#self._limitActivityInfo do
            table.insert(param.activitys, self._limitActivityInfo[i])
        end
        for i=1,#data.activityInfo do
            table.insert(param.activitys, data.activityInfo[i])
        end
        self:onTriggerNet230002Resp(param)
    end
end

--服务端推新的活动数据，替换数据，刷新单个活动面板
function ActivityProxy:onTriggerNet230007Resp(data)
    if self._allActivityInfo == nil then
        return
    end
    for i=1,#data.activityInfo do
        local isFind = false
        for k,v in pairs(self._allActivityInfo) do
            if data.activityInfo[i].activityId == v.activityId then
                isFind = k
                break
            end
        end
        if isFind then
            if data.activityInfo[i].buttons then
                for k,v in pairs(data.activityInfo[i].buttons) do
                    self._allActivityInfo[isFind].buttons[k].type = v.type
                    if v.type == 1 then
                        self._allActivityInfo[isFind].buttons[k].name = "立刻前往"
                    elseif v.type == 2 then
                        self._allActivityInfo[isFind].buttons[k].name = "立刻领取"
                    elseif v.type == 3 then
                        self._allActivityInfo[isFind].buttons[k].name = "已领取"
                    else
                        self._allActivityInfo[isFind].buttons[k].name = "立刻购买"
                    end
                end
            end
            if data.activityInfo[i].effectInfos then
                for k,v in pairs(data.activityInfo[i].effectInfos) do
                    self._allActivityInfo[isFind].effectInfos[v.sort].iscanget = v.iscanget
                    self._allActivityInfo[isFind].effectInfos[v.sort].rewardState = v.rewardState
                end
            end
            if data.activityInfo[i].already then
                self._allActivityInfo[isFind].already = data.activityInfo[i].already
            end
            if data.activityInfo[i].total then
                self._allActivityInfo[isFind].total = data.activityInfo[i].total
            end
        end
    end
    -- print("刷新小红点数量")
    self.proxy:checkActivityRedPoint()
    self.proxy:checkArmyBigRewardRedPoint()
    table.sort(self._allActivityInfo, function(a, b)
        return a.sort < b.sort
    end)
    --遍历到有奖励的活动直接return并刷新单个活动
    for i=1,#self._allActivityInfo do
        if self._allActivityInfo[i].effectInfos then
            for j=1,#self._allActivityInfo[i].effectInfos do 
                if self._allActivityInfo[i].effectInfos[j].iscanget == 1 then
                    self:sendNotification(AppEvent.PROXY_UPDATE_ONE, self._allActivityInfo[i])
                    self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
                    return
                end
            end
        end

        if self._allActivityInfo[i].buttons then
            for j=1,#self._allActivityInfo[i].buttons do 
                if self._allActivityInfo[i].buttons[j].type == 2 then
                    self:sendNotification(AppEvent.PROXY_UPDATE_ONE, self._allActivityInfo[i])
                    self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
                    return
                end
            end
        end
    end
    --没找到有奖励的活动，默认刷新第一个活动
    self:sendNotification(AppEvent.PROXY_UPDATE_ONE, self._allActivityInfo[1])
    self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
end

--活动关了，叫界面刷新吧 
function ActivityProxy:onTriggerNet230008Resp(data)
    for k,v in pairs(data.activityIds) do
        if v ~= 0 then
            self:removeActivity(self._allActivityInfo, v)
            self:removeActivity(self._limitActivityInfo, v)
        end
    end
    self:sendNotification(AppEvent.PROXY_REMOVE_ACT, data.activityIds)
    self:closeAllActivity()

    table.sort(self._allActivityInfo, function(a, b)
        return a.sort < b.sort
    end)
    self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
    self:sendNotification(AppEvent.PROXY_NEW_ACT)
    self.proxy:checkActivityRedPoint()
    self.proxy:checkArmyBigRewardRedPoint()
    self:updateLimitRedpoint()
    local isHas, legInfo = self:getDataByCondition(ActivityDefine.LEGION_JOIN_CONDITION) -- self:getDataById(15)
    self:sendNotification(AppEvent.PROXY_LEGION_GIFT, legInfo)
end

--通用删除活动函数
function ActivityProxy:removeActivity(param, id)
    for k,v in pairs(param) do
        if v.activityId == id then
            table.remove(param, k)
            break
        end
    end
end

function ActivityProxy:onTriggerNet240000Req(data)
    self:syncNetReq(AppEvent.NET_M24, AppEvent.NET_M24_C240000, data)
end

--间隔上次打开活动界面过去5分钟请求排行榜数据。前提是有排行榜活动
function ActivityProxy:onTriggerNet230013Req(data)
    if self._allActivityInfo == nil then
        return
    end
    local isSend = false
    for k,v in pairs(self._allActivityInfo) do
        if v.uitype == 5 then
            isSend = true
            break
        end
    end
    --TODO 第一次没有数据，会导致模块打开一半，再进行渲染
    local now = os.time()
    if isSend and now - self._lastReqTime >= 5 * 60   then --5分钟，才会去请求数据
        self._lastReqTime = now
        self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230013, data)
    else
        self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
    end
    
end

function ActivityProxy:onTriggerNet230013Resp(data)
    if data.rs == 0 then
        local activityRankInfo = data.activityRankInfo
        for i=1,#activityRankInfo do
            local flag, info = self:getDataById(activityRankInfo[i].activityid)
            if flag then
                -- print("现在的排名===",activityRankInfo[i].rank)
                if activityRankInfo[i].rank ~= -1 then 
                    info.already = activityRankInfo[i].rank
                end
            end
        end
        self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
    end
end

--新增1个限时活动
function ActivityProxy:onTriggerNet230009Resp(data)
    local id = data.activityInfo.activityId
    local isNew = false
    for k,v in pairs(self._limitActivityInfo) do
        if v.activityId == id then
            isNew = k
            break
        end
    end
    if isNew then
        self._limitActivityInfo[isNew] = data.activityInfo
    else
        table.insert(self._limitActivityInfo, data.activityInfo)
    end
    
    self:sendNotification(AppEvent.PROXY_UPDATE_LIMIT, true)
    self:sendNotification(AppEvent.PROXY_NEW_ACT)
end

function ActivityProxy:updateLegionGiftData()
    local flag, info, activeID = self:getDataByCondition(ActivityDefine.LEGION_JOIN_CONDITION) --self:getDataById(15)
    self:setLegionGiftIDTmp(activeID)
    self:sendNotification(AppEvent.PROXY_LEGION_GIFT, info)
end

-- 设置军团好礼活动id
function ActivityProxy:setLegionGiftID(data)
    -- body
    self._activeID = data
end

-- 设置军团好礼活动按钮状态
function ActivityProxy:setLegionGiftBtn(data)
    -- body
    self._LGiftBtn = data
end

-- 设置军团好礼活动id Tmp
function ActivityProxy:setLegionGiftIDTmp(data)
    -- body
    self._activeIDTmp = data
end

function ActivityProxy:closeAllActivity()
    local num = 0
    for k,v in pairs(self._limitActivityInfo) do
        num = num + 1
    end
    if num == 0 then
        self:sendNotification(AppEvent.PROXY_UPDATE_LIMIT, false)
    end
end

function ActivityProxy:onUpdateTipsResp(data)
    self.allTipsData = data
end


-----------------------------------------------------------
-- get function 外部调用接口

-- 获取活动列表
function ActivityProxy:getActivityInfo()
    -- body
    return self._allActivityInfo
end

-- 获取军团好礼活动id
function ActivityProxy:getLegionGiftID()
    -- body
    return self._activeID
end

-- 获取军团好礼活动id Tmp
function ActivityProxy:getLegionGiftIDTmp()
    -- body
    return self._activeIDTmp
end

-- 获取军团好礼活动按钮状态
function ActivityProxy:getLegionGiftBtn()
    -- body
    return self._LGiftBtn
end

-- 主城按钮点击：设置军团好礼活动id Tmp to 
function ActivityProxy:setTmpToLegionGiftID(isTrue)
    -- body
    self._activeID = self._activeIDTmp
    self._LGiftBtn = isTrue --是否点击了按钮标记
end


-- 获取限时活动列表
function ActivityProxy:getLimitActivityInfo()
    return self._limitActivityInfo
end
-- 获取限时活动id，通过uitype
function ActivityProxy:getLimitActivityDataByUitype( uitype )
    for k,v in pairs(self._limitActivityInfo) do
        if v.uitype == uitype then
            return v
        end
    end
    return nil
end
function ActivityProxy:removeLimitActivityInfo(id)
    for k,v in pairs(self._limitActivityInfo) do
        if v.activityId == id then
            table.remove(self._limitActivityInfo, k)
            break
        end
    end
end

-- 获取拉霸活动列表
function ActivityProxy:getLaBaActivityInfo()
    -- body
    return self._labaActivityInfo or {}
end

function ActivityProxy:returnInfo()
    return self.allInfo
end


function ActivityProxy:removeInfo(pos)
    -- print("remove pos===",pos)
    -- self.allInfo[pos] = 0
    for k,v in pairs(self.allInfo) do
        if v.pos == pos then
            table.remove(self.allInfo, k)
        end
    end
end

function ActivityProxy:getAllTipsData()
    return self.allTipsData
end

function ActivityProxy:getPartsGodInfos()  --得到军械神将的数据
    return self._partsGodInfos
end

-----------------------------------------------------------

function ActivityProxy:updateLimitRedpoint()
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    redPointProxy:setAllLimitActivity()
end


function ActivityProxy:onTriggerNet230017Resp(data)
    if data.rs == 0 then
        self:sendNotification(AppEvent.PROXY_ACTIVITY_PARTSGOD_GETREWARD , data)
        self._partsGodInfos = self._partsGodInfos or {}
        rawset(self._partsGodInfos,"ordnanceTime", nil)
        local redPointProxy = self:getProxy(GameProxys.RedPoint)
        redPointProxy:setPartsGodRed()
    end
end

function ActivityProxy:onTriggerNet230017Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230017, data)
end

function ActivityProxy:onTriggerNet230019Req(data)
    self.reqActId = data.activityid
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230019, data)
end

function ActivityProxy:isUpdate()
    return self.reqActId == self.curActivityData.activityId
end

function ActivityProxy:onTriggerNet230019Resp(data)   --活动排行榜信息
    print("----------------------------onTriggerNet230019Resp")
    if table.size(data.activityRankInfos) == 0 then
        self.rankInfo[self.reqActId] = {}
        self.rankInfo[self.reqActId].activityRankInfos = {}
        self.rankInfo[self.reqActId].myRankInfo = data.myRankInfo
    else
        self.rankInfo[self.reqActId] = data
    end
    self:sendNotification(AppEvent.PROXY_ACTIVITY_PARTSGOD_UPDATERANKDATA)
    self:sendNotification(AppEvent.PROXY_UPDATE_ACTIVITY_RANK, data)
end

function ActivityProxy:getRankInfoById(id)
    id = id or self.curActivityData.activityId
    return self.rankInfo[id] or {activityRankInfos = {}}
end

function ActivityProxy:onTriggerNet140001Req(data)  --获取个人信息
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140001, data)
end

function ActivityProxy:setPartsGodFree() --重置军械神将免费
    if self._partsGodInfos ~= nil then
        if rawget(self._partsGodInfos,"ordnanceTime") == nil then
            rawset(self._partsGodInfos,"ordnanceTime",true)
            self:sendNotification(AppEvent.PROXY_ACTIVITY_PARTSGOD_SETFREE)
        end
    end
end

function ActivityProxy:onTriggerNet230022Resp(data)
    local curId = self.curActivityData.activityId
    if data.rs == 0 then
        local info = self:getTurnTableInfo(curId)
        if info then
            info.free = info.free + #data.rewards
            --已经用掉的免费次数，限制为2次
            info.free = info.free > 2 and 2 or info.free
            --已经抽了多少次，简单粗暴加上抽的次数，这个值固定为抽的所有次数
            info.times = info.times + #data.rewards
        end
        local param = {}
        param.id = curId
        param.reward = data.rewards
        self:sendNotification(AppEvent.PROXY_UPDATE_ZPVIEW, data.rewards)
        self.allJifen = data.jifen
    else
        self:sendNotification(AppEvent.PROXY_UPDATE_ZPVIEW, {})
    end
    --更新转盘小红点，而不是更新全部活动的小红点
    self:getZPCount(curId)
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    redPointProxy:setDayTrunRed()
    -- self:updateLimitRedpoint()

end


--=============================================================================
--金鸡砸蛋:更新初始化数据
function ActivityProxy:onUpdateSmashEgg( data )
    local eggData = data.smashEggInfos[1] or {}
    self.spendTimes = eggData.spendTimes or 0
    self.remainTimes = eggData.remainTimes or 0
end
function ActivityProxy:onTriggerNet230030Resp( data )
    if data.rs==0 then
        self.spendTimes = self.spendTimes + ( self.nNumberSmash or 1 )
        self.remainTimes = self.remainTimes - ( self.nNumberSmash or 1 )
        self.proxy:setSmashEggRed()
        self:sendNotification(AppEvent.PROXY_UPDATE_ACTVIEW_SMASHEGG, data.rewardList)
    end
end
function ActivityProxy:setNumberSmash( state )
    self.nNumberSmash = state
end
--获得今日可用的砸蛋点数、剩下砸蛋点数上限
function ActivityProxy:getSmashEggNumber()
    local conf = ConfigDataManager:getConfigData( ConfigData.SmashEggConfig ) or {}
    conf = conf[1] or {}
    local roleProxy = self:getProxy(GameProxys.Role)
    local nowSpend = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_all_spend_coin)
    local newNum = math.floor( (nowSpend - (self.__oldSpend or 0)) / (conf.expendMoney or 1) )
    local num2 = conf.numberMax - self.spendTimes  --99/99
    local num1 = math.min(num2, self.remainTimes + newNum)  --今日可用的点数
    return num1, num2
end
--刷新金鸡次数  0点后，直接设置为最大
function ActivityProxy:resetEggTimes()
    self.spendTimes = 0
    self.remainTimes = 0
end


--=============================================================================
--迎春集福 集福回来
function ActivityProxy:onTriggerNet230031Resp( data )
    if data.rs==0 then
        self:showSysMessage( "集福成功" )
        self.proxy:setCollectBlessRed()
        --self:sendNotification(AppEvent.PROXY_UPDATE_ACTVIEW_SMASHEGG, {})
    end
end
--可集福数量
function ActivityProxy:getCollectBlessFullNumber()
    local conf = ConfigDataManager:getConfigData( ConfigData.CollectBlessConfig )
    local fullNumber = 0
    local numberArr = {}
    for i,v in ipairs(conf) do
        local arr = StringUtils:jsonDecode( v.collectID or "[]") or {}
        local addnumber = 99999
        for j, icondata in ipairs( arr ) do
            local id = icondata[2]
            local num = icondata[3]
            local itemProxy = self:getProxy(GameProxys.Item)
            local numberAtBag = numberArr[id] or itemProxy:getItemNumByType( id )
            if addnumber~=nil then
                addnumber = math.min( addnumber, math.floor(numberAtBag/num) )
                numberArr[id] = (numberArr[id] or 0) - num
                if numberAtBag<num then
                    addnumber = nil
                end
            end
        end
        if addnumber==99999 or addnumber==nil then
            addnumber = 0
        end
        fullNumber = fullNumber + addnumber
    end
    return fullNumber
end


--=================================================================
--爆竹酉礼领取
function ActivityProxy:onTriggerNet230026Req(data)
    --记录点击的位置
    self.squibSendPos = data.pos
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230026, data)
end

--爆竹酉礼领取
function ActivityProxy:onTriggerNet230026Resp(data)
    if data.rs == 0 then
        self:changeClientSquibInfo(data.activityId,self.squibSendPos)
        --self:sendNotification(AppEvent.PROXY_UPDATE_SQUIBINFO)
        --领取后点燃
        self:sendNotification(AppEvent.PROXY_SQUIB_AFTER_KINDLE,self.squibSendPos)
        local redPointProxy = self:getProxy(GameProxys.RedPoint)
        redPointProxy:setSpringSquibRed()
    end
end
--=================================================================
--武学讲坛学习
function ActivityProxy:onTriggerNet230032Req(data)
    self.learnTime = data.times
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230032, data)
end

--武学讲坛学习
function ActivityProxy:onTriggerNet230032Resp(data)
    if data.rs == 0 then
        self:martialInfoAddOneById(data.activityId,data.learnTimes)
        self:sendNotification(AppEvent.PROXY_UPDATE_MARTIALINFO)

        local redPointProxy = self:getProxy(GameProxys.RedPoint)
        redPointProxy:setMartialRed()
    end
end

function ActivityProxy:onTriggerNet230036Req(data)
    self:syncNetReq(AppEvent.NET_M23, AppEvent.NET_M23_C230036, data)
end

function ActivityProxy:onTriggerNet230036Resp(data)
    if data.rs == 0 then
        local flag, info = self:getDataById(data.activityId)
        if info ~= nil and info.effectInfos ~= nil then
            for k,v in pairs(info.effectInfos) do
                if v.conditiontype == 129 then
                    info.effectInfos[k].condition1 = data.time
                    if data.time >= v.condition2 and v.iscanget == 3 then
                        info.effectInfos[k].iscanget = 1
                    end
                end
            end

            self:sendNotification(AppEvent.PROXY_ACTIVITY_INFO, self._allActivityInfo)
            self.proxy:checkActivityRedPoint()
            self.proxy:checkArmyBigRewardRedPoint()
        end
    else
        self:updateOnlineTime()
    end
end

--根据activityId找武学讲坛信息然后对应学习次数加一
function ActivityProxy:martialInfoAddOneById(activityId,learnTimes)
    for k,v in pairs(self.martialInfos) do
        if v.activityId == activityId then
            
            if self.learnTime == 0 then
                self.martialInfos[k].free  = self.martialInfos[k].free + 1
                self.learnTime =  self.learnTime + 1
            end
             self.martialInfos[k].learnTimes = learnTimes
        end
    end
    
end
function ActivityProxy:setMartialInfos(martialInfos)
    self.martialInfos = martialInfos
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    redPointProxy:setMartialRed()
end
function ActivityProxy:getMartialInfos()
    return self.martialInfos or {}
end
--重置武学讲堂免费次数
function ActivityProxy:resetMartialFreeTime()
    -- print("resetMartialFreeTime")
    for _,v in pairs(self:getMartialInfos()) do
        v.free = 0
    end
    self:sendNotification(AppEvent.PROXY_UPDATE_MARTIALINFO)
end

--根据活动id获取武学讲坛免费次数
function ActivityProxy:getMartialFreeTime(activityId)
    for _,v in pairs(self:getMartialInfos()) do
        if v.activityId == activityId then
            return 1 - v.free
        end
    end
    print("There is not data in MartialInfos by this activityId")
    return 0
end
--根据活动id获取武学讲坛信息
function ActivityProxy:getMartialInfoById(activityId)
    if self.martialInfos then
        for k,v in pairs(self:getMartialInfos()) do
            if v.activityId == activityId then
                return self.martialInfos[k]
            end
        end
    else
        print("martialInfos is nil")
        return {}
    end
    print("no martialInfo by this activityId")
    print(activityId)
    return {}
end
--=================================================================


function ActivityProxy:updateTurnTable()
    local roleProxy = self:getProxy(GameProxys.Role)
    local allSpend = roleProxy:setRoleAttrValue(PlayerPowerDefine.POWER_all_spend_coin, 0)
    self.turntableInfos = self.turntableInfos or {}
    for k,v in pairs(self.turntableInfos) do
        self.turntableInfos[k].times = 0
        self.turntableInfos[k].free = 1
        self:getZPCount(v.id)
    end
    -- self:updateLimitRedpoint()
    --重置的时候
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    redPointProxy:setDayTrunRed()
    self:sendNotification(AppEvent.PROXY_RESET_TTDATA)
end

function ActivityProxy:setModuleNameData(id, name)
    if not self.moduleName then
        self.moduleName = {}
    end
    self.moduleName[id] = name
end

function ActivityProxy:getModuleData(id)
    return self.moduleName[id]
end

function ActivityProxy:setRedPointCount(id, count)
    self.allRedPint[id] = count
    local redPoint = self:getProxy(GameProxys.RedPoint)
    redPoint:setRedPoint(id, count)
end

function ActivityProxy:getAllRedPint()
    return self.allRedPint
end

function ActivityProxy:getZPCount(id, info)
    if type(id) ~= "number" then
        return
    end
    local function getLimitInfoById(id)
        for k,v in pairs(self._limitActivityInfo) do
            if v.activityId == id then
                return v
            end
        end
    end
    if not info then
        info = getLimitInfoById(id)
    end
    local turnInfo = self:getTurnTableInfo(id)
    if info and turnInfo then
        local roleProxy = self:getProxy(GameProxys.Role)
        local config = ConfigDataManager:getConfigById(ConfigData.CoronaConfig, info.effectId)
        local vipLv = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_vipLevel)
        local vipCount = vipLv > 0 and 1 + config.condition or 1
        local hasCount = math.floor(turnInfo.spend/config.limit) - turnInfo.times + vipCount
        hasCount = hasCount < 0 and 0 or hasCount
        self:setRedPointCount(id, hasCount)
    end
end

--监测属性变化，更新小红点
function ActivityProxy:updateRoleInfoRsp(data)
    local roleProxy = self:getProxy(GameProxys.Role)
    local nowLevel = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_vipLevel)
    local nowSpend = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_all_spend_coin)
    if (self.vipLevel == 0 and nowLevel ~= 0) or (self.allSpend ~= nowSpend) then
        -- print("需要刷新")
        for k,v in pairs(self._limitActivityInfo) do
            self:getZPCount(v.activityId)
        end
        -- self:updateLimitRedpoint()
        local redPointProxy = self:getProxy(GameProxys.RedPoint)
        redPointProxy:setDayTrunRed()
        redPointProxy:setSmashEggRed()
    end
    self.vipLevel = nowLevel
    self.allSpend = nowSpend
end
--监听背包
function ActivityProxy:updateRoleBagRsp(data)
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    if #data.itemList>0 then
        redPointProxy:setCollectBlessRed()
    end
end

function ActivityProxy:getRankReqData(id)
    local data = {}
    local info = self.allTotal[id]
    for k,v in pairs(info) do
        if v.rewardState == 1 then
            data.effectId = v.effectId
            data.sort = v.sort
            break
        end
    end
    return data
end
function ActivityProxy:setSquibInfos(squibInfos)
    self.squibInfos = squibInfos
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    redPointProxy:setSpringSquibRed()
end
function ActivityProxy:getSquibInfos()
    return self.squibInfos or {}
end
--根据activityId获取爆竹酉礼点燃位置的信息
function ActivityProxy:getSquibPosInfos(activityId)
    for k,v in pairs(self.squibInfos) do
        if v.activityId == activityId then
            return self.squibInfos[k].pos
        end
    end
    return {}
end

--获取当前活动数据
function ActivityProxy:getCurActivityData()
    return self.curActivityData
end
--主动修改爆竹酉礼爆竹位置信息
function ActivityProxy:changeClientSquibInfo(activityId,squibSendPos)
    for k,v in pairs(self.squibInfos) do
        if v.activityId == activityId then
            table.insert(self.squibInfos[k].pos,squibSendPos) 
        end
    end
    
end
--清空爆竹位置信息
function ActivityProxy:cleanClientSquibInfo()
    for k,v in pairs(self.squibInfos) do
        self.squibInfos[k].pos = {}
    end

    self:sendNotification(AppEvent.PROXY_UPDATE_SQUIBINFO)
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    redPointProxy:setSpringSquibRed()
end
--根据activityId获取爆竹酉礼还能点击多少次
function ActivityProxy:getSquibCanTouchTime(activityId)

    --计算当前充值金额前面有段
    local n = 0
    local config = ConfigDataManager:getConfigData(ConfigData.FirecrackerConfig)
    local roleProxy = self:getProxy(GameProxys.Role)
    local chargeValue = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_today_charge)
    table.sort(config,function ( a,b )
        return a.ID < b.ID
    end)

    if chargeValue >= config[#config].recharge then
        n = 6
    elseif chargeValue <= 0 then
        n = 0
    else
        for k,v in pairs(config) do
            if chargeValue > config[k]["recharge"] and chargeValue < config[k + 1]["recharge"] then
                n = k
                break
            end
        end
    end
    --已经点了几个
    local posArray = self:getSquibPosInfos(activityId)
    local hasTouch = #posArray
    -- print(n)
    -- print(hasTouch)


    return n - hasTouch
end

function ActivityProxy:getLimitInfoByUitype(uitype)
    for k,v in pairs(self._limitActivityInfo) do
        if v.uitype == uitype then
            self.curActivityData = v
            return v
        end
    end
end
