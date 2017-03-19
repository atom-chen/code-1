LotteryProxy = class("LotteryProxy", BasicProxy)

function LotteryProxy:ctor()
    LotteryProxy.super.ctor(self)
    self.proxyName = GameProxys.Lottery
    self._lotteryInfos = {}
    self._initInfos = true
    self._lastRefreshTime = 0
    self._heroGoldCount = 0     --战将幸运币
    self._HeroLotteryInfo = {}  --战将信息
    self._heroRewards = {}      --战将抽奖获得物品信息
    self._histories = {}        --战将最近20名信息
    self._historiesMap = {}     --包含奇兵/神兵的最近20名信息

    self.HERO_KEY = "HeroLottery"  --定时器的key

end

function LotteryProxy:resetAttr()
    self._lotteryInfos = {}
    self._lastRefreshTime = 0
    self._initInfos = true
    -- self._HeroLotteryInfo = {}   --战将信息
    self._heroRewards = {}          --战将抽奖获得物品信息
    self._histories = {}            --最近20名信息
    self._historiesMap = {}         --最近20名信息
end

function LotteryProxy:resetCountSyncData()
    self:setIsFreeTanbao(1,0)
end

function LotteryProxy:registerNetEvents()
    --self:registerNetEvent(AppEvent.NET_M2, AppEvent.NET_M2_C20000, self, self.onRoleInfoResp)
    -- self:registerNetEvent(AppEvent.NET_M15, AppEvent.NET_M15_C150000, self, self.onGetLotteryInfosResp)
    -- self:registerNetEvent(AppEvent.NET_M15, AppEvent.NET_M15_C150001, self, self.onBuyLotteryResp)
    self:addEventListener(AppEvent.PROXY_GET_ROLE_INFO, self, self.updateRoleInfoRsp)
    self:addEventListener(AppEvent.PROXY_UPDATE_ROLE_INFO, self, self.updateRoleInfoRsp)
end

function LotteryProxy:unregisterNetEvents()
    -- self:unregisterNetEvent(AppEvent.NET_M15, AppEvent.NET_M15_C150000, self, self.onGetLotteryInfosResp)
    -- self:unregisterNetEvent(AppEvent.NET_M15, AppEvent.NET_M15_C150001, self, self.onBuyLotteryResp)
    self:removeEventListener(AppEvent.PROXY_GET_ROLE_INFO, self, self.updateRoleInfoRsp)
    self:removeEventListener(AppEvent.PROXY_UPDATE_ROLE_INFO, self, self.updateRoleInfoRsp)
end

function LotteryProxy:updateRoleInfoRsp(data)
    local roleProxy = self:getProxy(GameProxys.Role)
    local currentLv = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_level)
    if currentLv >= 8  and self._initInfos then --TODO改成都配置表
        self:onTriggerNet150000Req({})
        self:onTriggerNet150001Req({})
        self._initInfos = false
    end
end

---------------------------------------------------------------------
-- 协议请求
---------------------------------------------------------------------
--请求抽奖数据刷新
function LotteryProxy:onTriggerNet150000Req(data)
    print("奇兵 150000 req")
    self:syncNetReq(AppEvent.NET_M15,AppEvent.NET_M15_C150000, {})
end

--请求抽奖
function LotteryProxy:onTriggerNet150001Req(data)
    print("神兵 150001 req")
    self:syncNetReq(AppEvent.NET_M15,AppEvent.NET_M15_C150001, {})
end

--请求战将信息
function LotteryProxy:onTriggerNet150004Req(data)
    print("150004 req")
    self:syncNetReq(AppEvent.NET_M15,AppEvent.NET_M15_C150004, {})
end

--请求战将开宝箱
function LotteryProxy:onTriggerNet150005Req(data)
    print("150005 req")
    self:syncNetReq(AppEvent.NET_M15,AppEvent.NET_M15_C150005, {})
end

--请求战将探宝刷新奖励
function LotteryProxy:onTriggerNet150006Req(data)
    print("150006 req")
    self:syncNetReq(AppEvent.NET_M15,AppEvent.NET_M15_C150006, {})
end

--请求战将探宝抽取奖励
function LotteryProxy:onTriggerNet150007Req(data)
    print("150007 req")
    self:setLastIndex(data.index)
    self:syncNetReq(AppEvent.NET_M15,AppEvent.NET_M15_C150007, data)
end

--请求战将探关闭探宝
function LotteryProxy:onTriggerNet150008Req(data)
    print("150008 req")
    self:syncNetReq(AppEvent.NET_M15,AppEvent.NET_M15_C150008, {})
end


---------------------------------------------------------------------
-- 协议返回
---------------------------------------------------------------------
--     message  S2C{
--        required int32 rs=1;
--        optional int32 itemCount=2;//剩余探宝币数量
--        repeated LotteryHistrory histories=3;//奖励历史记录20条
--     }
function LotteryProxy:onTriggerNet150000Resp(data)
    if data.rs == 0 then
        print("协议 150000 返回")
        -- self:sendNotification(AppEvent.PROXY_LOTTERY_INFOS_CHANGE,data)
        self:updateItemNum( data,4014 )
        self._historiesMap[1] = data.histories
        self:sendNotification(AppEvent.PROXY_HEROLOTTERY_UPDATE,{})
    end
end

function LotteryProxy:onTriggerNet150001Resp(data)
    if data.rs == 0 then
        print("协议 150001 返回")
        self:updateItemNum( data,4042 )
        self._historiesMap[2] = data.histories
        self:sendNotification(AppEvent.PROXY_HEROLOTTERY_UPDATE,{})
    end
end


--战将信息
function LotteryProxy:onTriggerNet150004Resp(data)
    print("150004 resp")
    if data.rs == 0 then
        self._lastIndex = 0
        self._heroGoldCount = rawget(data,"itemCount") or 0
        self._histories = rawget(data,"histories") or {}
        self:updateItemNum(data)
        self:updateHeroLotteryInfo( data )
        self:updateHeroRewardInfo( data )
        self:sendNotification(AppEvent.PROXY_HEROLOTTERY_UPDATE,{})
    end
end

--战将开宝箱
function LotteryProxy:onTriggerNet150005Resp(data)
    print("150005 resp")
    if data.rs == 0 then
        self._heroRewards = {}
        self._heroGoldCount = rawget(data,"itemCount") or 0
        self:updateItemNum(data)
        self:updateHeroLotteryInfo( data )
        self:sendNotification(AppEvent.PROXY_HEROLOTTERY_UPDATE,{})
    end
end

--战将探宝刷新奖励
function LotteryProxy:onTriggerNet150006Resp(data)
    print("150006 resp")
    if data.rs == 0 then
        self._heroGoldCount = rawget(data,"itemCount") or 0
        self:updateItemNum(data)
        self:updateHeroLotteryInfo( data )
        self:sendNotification(AppEvent.PROXY_HEROLOTTERY_UPDATE,{})
    end
end


--战将探宝抽取奖励
function LotteryProxy:onTriggerNet150007Resp(data)
    print("150007 resp")
    if data.rs == 0 then
        self._heroGoldCount = rawget(data,"itemCount") or 0
        self:updateItemNum(data)
        self:updateHeroLotteryInfo( data )
        self:updateHeroRewardInfo( data )
        self:sendNotification(AppEvent.PROXY_HEROLOTTERY_UPDATE,{})
    end
end

--战将探关闭探宝
function LotteryProxy:onTriggerNet150008Resp(data)
    print("150008 resp",data.rs)
    if data.rs == 0 then
        print("战将探关闭探宝 lasttime,status=",data.info.lasttime,data.info.status)
        self:updateHeroLotteryInfo( data )
        self:sendNotification(AppEvent.PROXY_HEROLOTTERY_UPDATE,{})
    end
end

---------------------------------------------------------------------
-- 数据处理
---------------------------------------------------------------------
-- 更新战将信息
function LotteryProxy:updateHeroLotteryInfo( data )
    -- body
    local infos = rawget(data,"info")
    if infos ~= nil then
        print("更新战将信息.... lasttime,opentimes,status = ",infos.lasttime,infos.opentimes,infos.status)

        if infos.status == 0 then
            -- 宝箱关闭状态
            infos.lasttime = 0
            infos.lotterytimes = 0
            infos.refreshtimes = 0
        end

        -- self._candidates = self:randomPreviewRewards( infos.candidates )

        self._HeroLotteryInfo = infos
        self:setHeroRemainTime(infos.lasttime)

    end

end

-- 更新已抽取奖励
function LotteryProxy:updateHeroRewardInfo( data )
    for k,index in pairs(self._HeroLotteryInfo.indexes) do
        index = index + 1
        self._heroRewards[index] = self._HeroLotteryInfo.rewards[k]
    end

    for index,reward in pairs(self._heroRewards) do
        self._HeroLotteryInfo.candidates[index] = reward
            print("已抽到 index,power,typeid = ", index,reward.power,reward.typeid)
    end

    -- print("抽到奖励更新 _lastIndex",self._lastIndex)
end

function LotteryProxy:updateItemNum( data,itemID )
    -- body
    itemID = itemID or 4043 --战宝币4043,神宝币4042,奇宝币4014
    local number = rawget(data,"itemCount")
    if number == type(0) then
        local proxy = self:getProxy(GameProxys.Item)
        proxy:setItemNumByType(itemID, number)  
    end
end

function LotteryProxy:setLastIndex(index)
    -- body 最近一次抽奖的下标
    self._lastIndex = index
end

function LotteryProxy:getLastIndex()
    -- body 最近一次抽奖的下标
    return self._lastIndex
end


function LotteryProxy:setLotteryInfos(equipLotterInfos)
    self._lastRefreshTime = os.time()
    self._lotteryInfos = equipLotterInfos

    for key,v in pairs(equipLotterInfos) do
        if v.freeTimes <= 0 then
            self:pushRemainTime("Lottery_infos"..v.type,v.time)
        else
            self:pushRemainTime("Lottery_infos"..v.type,0)
        end
    end
    self:updateRedPoint()
end

--小红点更新
function LotteryProxy:updateRedPoint()
    local redPointProxy = self:getProxy(GameProxys.RedPoint)
    redPointProxy:checkFreeFindBoxRedPoint() 
    redPointProxy:lotteryEquipRedPoint()
end


-- 预览奖励做随机排序
function LotteryProxy:randomPreviewRewards( rewards )
    -- body
    local randomRewards = {}
    local size = table.size(rewards)
    if size > 0 then
        math.randomseed(os.time())

        for k,v in pairs(rewards) do
            v.isDone = false
        end

        while table.size(randomRewards) < size do
            local randomIndex = math.random(size)
            -- print("随机下标 randomIndex=",randomIndex)
            local reward = rewards[randomIndex]
            if reward.isDone == false then
                reward.isDone = true
                table.insert(randomRewards,reward)
            end
        end
    end

    return randomRewards
end

---------------------------------------------------------------------
-- 对外接口
---------------------------------------------------------------------
function LotteryProxy:setHeroRemainTime( remainTime )
    print("战将探宝剩余时间 LotteryProxy:setHeroRemainTime( remainTime )", remainTime)
    -- body 战将探宝剩余时间
    -- self:pushRemainTime(self.HERO_KEY, remainTime, AppEvent.NET_M15_C150004, nil, self.onTriggerNet150004Req)
    self:setHeroRemainTimeCopy(remainTime)
    self:pushRemainTime(self.HERO_KEY, remainTime, AppEvent.NET_M15_C150004, nil, self.onRemainTimeCallBack)
end

function LotteryProxy:onRemainTimeCallBack(data)
    self:setHeroRemainTimeCopy(0)
    self:onTriggerNet150004Req(data)
end


function LotteryProxy:getHeroRemainTime()
    local remainTime = self:getRemainTime(self.HERO_KEY)
    return remainTime
end

function LotteryProxy:setHeroRemainTimeCopy(time)
    self._remainTimeCopy = time
end

function LotteryProxy:getHeroRemainTimeCopy()
    return self._remainTimeCopy
end

function LotteryProxy:getHeroLotteryInfo(  )
    -- body 战将信息
    return self._HeroLotteryInfo
end

function LotteryProxy:getRandomCandidates(  )
    -- body 随机后的奖励信息
    return self._candidates
end

function LotteryProxy:getHeroRewards(  )
    -- body 战将探宝的奖励信息
    return self._heroRewards
end

function LotteryProxy:getHeroGoldCount(  )
    -- body 战将探宝币数量
    return self._heroGoldCount
end

function LotteryProxy:getHistories(  )
    -- body 最近20条玩家探宝信息
    return self._histories
end

function LotteryProxy:getHistoriesMap(index)
    -- body 奇兵index=1/神兵index=2,最近20条玩家探宝信息
    return self._historiesMap[index]
end


-- 是否有免费探宝
function LotteryProxy:getisFreeTanbao()
    return self._freeTanbao
end

--获得抽奖数据
function LotteryProxy:getNetInfos()
    return self._lotteryInfos
end

function LotteryProxy:setIsFreeTanbao(norTimes,spcTimes)
    local freeData = {}
    freeData[1] = {times = norTimes, type = 1}
    freeData[2] = {times = spcTimes, type = 2}
    self._freeTanbao = freeData
    self:updateRedPoint()
end

function LotteryProxy:getIsFree()
    local freeTaobao = self:getisFreeTanbao()
    for k,v in pairs(freeTaobao) do
        if v.times > 0 then
            return true
        end
    end
    return false
end

function LotteryProxy:onGetUpdateTimeInfos(index)
    local temp = clone(self._lotteryInfos)

    local function call( type)
        for _,v in pairs(temp) do
            if type == v.type then
                return v
            end
        end
    end

    for i = 1,3 do
        local remainTime = self:getRemainTime("Lottery_infos"..i)
        local info = call(i)
        info.time = remainTime
    end
    if index == nil then
        return temp
    else
        return call(index)
    end
    self:updateRedPoint()
end

-- 判定战将探宝是否已开放，未开放则飘字提示
function LotteryProxy:isUnlockLotteryByID(id,isShowMsg)
    if id == nil then
        return false
    end

    local info = ConfigDataManager:getConfigById("NewFunctionOpenConfig", id)

    if info.type == 1 then  --type = 1 判定主公等级
        local unLockLevel = info.need
        local roleProxy = self:getProxy(GameProxys.Role)
        local currentLv = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_level)

        if currentLv < unLockLevel then
            if isShowMsg then
                self:showSysMessage(string.format(TextWords:getTextWord(340000),info.need,info.name))
            end
            return false
        end
        return true
    else
        return false
    end

end

-- 判定奇兵探宝是否已开放，未开放则飘字提示
function LotteryProxy:isUnlockNorLottery(isShowMsg)
    return self:isUnlockLotteryByID(5,isShowMsg)
end

-- 判定神兵探宝是否已开放，未开放则飘字提示
function LotteryProxy:isUnlockSpeLottery(isShowMsg)
    return self:isUnlockLotteryByID(9,isShowMsg)
end

-- 判定战将探宝是否已开放，未开放则飘字提示
function LotteryProxy:isUnlockHeroLottery(isShowMsg)
    return self:isUnlockLotteryByID(11,isShowMsg)
end

-- -- 判定战将探宝是否已开放，未开放则飘字提示
-- function LotteryProxy:isUnlockHeroLottery()
--     self.unLockLevel = 20 --20级开放战将探宝
--     local roleProxy = self:getProxy(GameProxys.Role)
--     local playerLv = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_level)
--     if playerLv < self.unLockLevel then
--         self:showSysMessage(TextWords:getTextWord(1867))
--         return false
--     end
--     return true
-- end

