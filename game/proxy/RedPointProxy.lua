
RedPointProxy = class("RedPointProxy", BasicProxy)

function RedPointProxy:ctor()
    RedPointProxy.super.ctor(self)
    self.proxyName = GameProxys.RedPoint
    self:_initInfo()
end

function RedPointProxy:resetAttr()
	self:_initInfo()
end

function RedPointProxy:registerNetEvents()

end

function RedPointProxy:unregisterNetEvents()

end

--初始化红点个数
function RedPointProxy:_initInfo()

	self._allRedPoint = {}

    self._RedPointInfo ={}
	for i=1, 14 do
		self._RedPointInfo[i] = {}
		self._RedPointInfo[i].num = 0
		self._RedPointInfo[i].type = i
	end
end

---toolbar---调用给所有小红点赋值
function RedPointProxy:setToolbarRedPonintInfo()
	self:checkDungeonRedPoint() 		 --1--
	self:checkTeamRedPoint()  			 --2-- 
	self:checkTaskRedPoint()  			 --3
	self:checkMailRedPoint()  			 --4
	self:checkBagRedPoint()				 --5 
	self:checkFriendRedPoint()			 --6  
	self:lotteryEquipRedPoint() 		 --7 
	self:checkEquiipRedPoint()			 --8 
	self:checkFreeFindBoxRedPoint()	   	 --9
	self:checkOrdmamceRedPoint()		 --10   
	self:checkActivityRedPoint()		 --11 
	self:checkThirtyRedPoint()			 --12
	self:checkActivityLimitRedPoint()	 --13
	self:checkArmyBigRewardRedPoint()	 --14
end


function RedPointProxy:getRedPointInfos()
	return self._RedPointInfo
end

function RedPointProxy:updateRedPointInfo(type, num)
	if self._RedPointInfo[type].num ~= num then
		self._RedPointInfo[type].num = num
		self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
	end
end

--关卡小红点数量计算    index = 1 没做更新
function RedPointProxy:checkDungeonRedPoint()
	local index, num = 1, 0 
	--计算历练和武将切磋次数
	local dungeonProxy = self:getProxy(GameProxys.Dungeon)
	for i=1, 2 do
		local times = dungeonProxy:getTimesById(i)
		if times ~= -1 then
			num = num + times
		end
	end
	--西域远征
	local limitExpProxy = self:getProxy(GameProxys.LimitExp)
	local limitExpInfos = limitExpProxy:getExinfos()
	if limitExpInfos ~= nil then
		if limitExpInfos.fightCount ~= 0 or limitExpInfos.backCount ~= 0 then
			num = num + 1
		end
	else
		local roleProxy = self:getProxy(GameProxys.Role)
		num = num + roleProxy:getlimitExp()
	end
	local playerProxy = self:getProxy(GameProxys.Role)
    local supportNum = playerProxy:getRoleAttrValue(PlayerPowerDefine.POWER_support) or 0
    num = num + supportNum
	self:updateRedPointInfo(index, num)
end

--部队小红点数量计算    index = 2     没做更新
function RedPointProxy:checkTeamRedPoint()
	local index, num = 2, 0 
	local soldierProxy = self:getProxy(GameProxys.Soldier)
	local taskTeamInfo = soldierProxy:getTaskTeamInfo()
	local badSoldierList = soldierProxy:getBadSoldiersList()
	for _,v in pairs(taskTeamInfo) do
		if v.type ~= 6 then
			num = num + 1
		end
	end
	for k,v in pairs(badSoldierList) do
		num = num + 1
	end
	self:updateRedPointInfo(index, num)
end

--任务小红点数量计算    index = 3
function RedPointProxy:checkTaskRedPoint()
	local index, num = 3, 0 
	local RoleProxy = self:getProxy(GameProxys.Role)
	local isLock = RoleProxy:isFunctionUnLock(10, false)
	--战功任务未开启，不显示小红点
	if not isLock then
		self:updateRedPointInfo(index, num)
		return
	end

	local taskProxy = self:getProxy(GameProxys.Task)
	local mainList = taskProxy:getMainTaskList()
	local dailyList = taskProxy:getDailyTaskList()
	local activeState = taskProxy:getActiveState()
	local activeMaxID = taskProxy:getActiveMaxID()
	for _, v in pairs(mainList) do
		if v.state == 1 then
			num = num + 1
		end
	end
	-- for k,v in pairs(dailyList) do
	-- 	if v.state == 1 then
	-- 		num = num + 1
	-- 	end
	-- end
	local num2 = taskProxy:getCont2()
    --策划需求第一次打开战功小红点开启
	if not self._init and num2 == 0 then
		-- num = num + 1
		--self:setTaskInit(true)
	else
		num = num + num2
	end
	-- if activeMaxID == 5 then  --活跃奖励已领取完毕		
	-- elseif activeState or self._init then
	-- 	num = num + 1
	-- 	self:setTaskInit(false)
	-- end
	self:updateRedPointInfo(index, num)
end

function RedPointProxy:setTaskInit(isInit)
    self._init = isInit
end

--邮件小红点数量计算    index = 4   
function RedPointProxy:checkMailRedPoint()
	local index, num = 4, 0 
	--TODO根据数据计算num
	local mailProxy = self:getProxy(GameProxys.Mail)
	local mails = mailProxy:getAllShortData()
	for _,v in pairs(mails) do
		if v.state == 0 then
			num = num + 1
		end
	end
	self:updateRedPointInfo(index, num)
end

--背包小红点数量计算    index = 5     
function RedPointProxy:checkBagRedPoint()
	local index, num = 5, 0 
	--TODO根据数据计算num
	local itemProxy = self:getProxy(GameProxys.Item)
	local items = itemProxy:getAllItemList()
	for _, v in pairs(items) do 
		if itemProxy:isCanUse(v.typeid) then
			num = num + 1
		end
	end
	self:updateRedPointInfo(index, num)
end

--好友祝福小红点数量计算  index = 6    
function RedPointProxy:checkFriendRedPoint()
	local index, num = 6, 0 
	local friendProxy = self:getProxy(GameProxys.Friend)
	local blessInfos = friendProxy:getBlessInfos()
	for _, v in pairs(blessInfos) do
		if v.getState == 0 then
			num = num + 1
		end
	end
	self:updateRedPointInfo(index, num)
end

--装备抽奖(武将)小红点数量计算 index = 7 
function RedPointProxy:lotteryEquipRedPoint()
	local index, num = 7, 0 
	local lotteryProxy = self:getProxy(GameProxys.Lottery)
	local lotteryInfos = lotteryProxy:getNetInfos()
	for k,v in pairs(lotteryInfos) do
		if v.freeTimes then
			num = num + v.freeTimes
		end
	end
	self:updateRedPointInfo(index, num)	
end

-- （阵容）小红点数量计算 index = 8  
function RedPointProxy:checkEquiipRedPoint()
	local index, num = 8, 0 	
	--TODO根据数据计算num
	local heroProxy = self:getProxy(GameProxys.Hero)
	local unAdd = heroProxy:getUnAddHero()
	for _, v in pairs(unAdd) do
		num = num + 1 -- 有几个可上阵的武将
	end
    local canAddCount = heroProxy:getCanAddCount()-- 可上阵坑位
    -- 取空闲英雄数和可上阵坑位数的较小值
    if num > canAddCount then 
        num = canAddCount
    end
	self:updateRedPointInfo(index, num)
end

--免费探宝小红点数量计算      index = 9
function RedPointProxy:checkFreeFindBoxRedPoint()
	local index, num = 9, 0 
	local LotteryProxy = self:getProxy(GameProxys.Lottery)
	local data = LotteryProxy:getisFreeTanbao()
	for k,v in pairs(data) do
		num = v.times + num 
	end
	self:updateRedPointInfo(index, num)
end

--军械仓库小红点数量计算     index = 10    
function RedPointProxy:checkOrdmamceRedPoint()
	local index, num = 10, 0 
	--TODO根据数据计算num
	local partsProxy = self:getProxy(GameProxys.Parts)
	local notWearingPartsInfos = (partsProxy:getOrdnanceUnEquipInfos()) or {}
	--计算未装备军械数量
	for _, v in pairs(notWearingPartsInfos) do
		num = num + 1
	end
	self:updateRedPointInfo(index, num)	
end

--活动可领取小红点数量计算         index = 11
function RedPointProxy:checkActivityRedPoint()
	local index, num = 11, 0 
	--TODO根据数据计算num
	local activityProxy = self:getProxy(GameProxys.Activity)
	local data = activityProxy:getActivityInfo()
	for i=1,#data do
		if type(data[i].effectInfos) == "table" then
			for k,v in pairs(data[i].effectInfos) do
				if v.iscanget == 1 then
					num = num + 1
				end
			end
		end
		if type(data[i].buttons) == "table" then
			for k,v in pairs(data[i].buttons) do
				if v.type == 2 and data[i].uitype ~= 2 then
					num = num + 1
				end
			end
		end
	end
	self:updateRedPointInfo(index, num)
end

--30天活动小红点数量计算      index = 12  
function RedPointProxy:checkThirtyRedPoint()
	local index, num = 12, 0 
	--TODO根据数据计算num
	local roleProxy = self:getProxy(GameProxys.Role)
	local openServerList = roleProxy:getOpenServerList()
	for _, v in pairs(openServerList) do
		if v.state == 2 then
			num = num + 1
		end
	end
	local severData = roleProxy:getOpenServerData()
	if severData.allDay == 0 then
		num = num + 1
	end
	self:updateRedPointInfo(index, num)
end

--限时活动小红点数量计算      index = 13   待测
function RedPointProxy:checkActivityLimitRedPoint()
	local index, num = 13, 0 
	--TODO根据数据计算num
	-- local activityProxy = self:getProxy(GameProxys.Activity)
	-- local shareData = activityProxy:returnInfo()
	-- local labaData = activityProxy.labaXinxi
	-- num = #shareData
	-- for k,v in pairs(labaData) do
	-- 	if v.free == 1 then
	-- 		num = num + 1
	-- 	end
	-- end
	-- local info = activityProxy:getAllRedPint()
	-- for k,v in pairs(info) do
	-- 	num = num + v
	-- end
	for k,v in pairs(self._allRedPoint) do
		num = num + v
	end
	self:updateRedPointInfo(index, num)
end

--军团大礼小红点数量计算      index = 14
function RedPointProxy:checkArmyBigRewardRedPoint()
	local index, num = 14, 0 
	--TODO根据数据计算num
	print("军团红点===",num)
	local activityProxy = self:getProxy(GameProxys.Activity)
	local flag,data = activityProxy:getDataByCondition(ActivityDefine.LEGION_JOIN_CONDITION)
	if flag then
		-- for k,v in pairs(data) do
			if data.buttons then
				for key,value in pairs(data.buttons) do
					if value.type == 2 then
						num = num + 1
					end
				end
			end
		-- end
	end
	self:updateRedPointInfo(index, num)
end

--记录每个限时活动的小红点
function RedPointProxy:setRedPoint(id, num)
	self._allRedPoint[id] = num
end

function RedPointProxy:getRedPointById(id)
	return self._allRedPoint[id] or 0
end

function RedPointProxy:getAllRedData()
	return self._allRedPoint or {}
end

--单独计算每个限时活动的小红点，放在一起算比较浪费
--有福同享
function RedPointProxy:setChargeShareRed()
	local activityProxy = self:getProxy(GameProxys.Activity)
	local shareData = activityProxy:returnInfo()--有福同享的红点

	--todo  有福同享  待优化
	local allActivityInfo = activityProxy:getLimitActivityInfo()
	for k,v in pairs(allActivityInfo) do
		if v.uitype == ActivityDefine.LIMIT_ACTION_LEGIONSHARE_ID then
			self:setRedPoint(v.activityId, #shareData)
			break
		end
	end
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end

--拉霸
function RedPointProxy:setPullBarRed()
	local activityProxy = self:getProxy(GameProxys.Activity)
	local labaData = activityProxy.labaXinxi--拉霸的红点
	for k,v in pairs(labaData) do
		if v.free == 1 then
			self:setRedPoint(v.activityId, 1)
		else
			self:setRedPoint(v.activityId, 0)
		end
	end
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end

--vip总动员
function RedPointProxy:setVipRebateRed()
	local vipRebateProxy = self:getProxy(GameProxys.VipRebate)
	local vipNum = vipRebateProxy:getRedPoint()
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end

--转盘
function RedPointProxy:setDayTrunRed()
	local activityProxy = self:getProxy(GameProxys.Activity)
	local info = activityProxy:getAllRedPint()
	for k,v in pairs(info) do
		self:setRedPoint(k, v)
	end	
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end

--皇帝的新衣
function RedPointProxy:setEmperorRed()
	local EmperorProxy = self:getProxy(GameProxys.EmperorAward)
	local emperorNum = EmperorProxy:getAllRedPoint()
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end

--天降奇兵
function RedPointProxy:setSoldierRed()
	local proxy = self:getProxy(GameProxys.GeneralAndSoldier)
	local soldierNum = proxy:getAllRedPoint()
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end

--金鸡蛋黄派
function RedPointProxy:setSmashEggRed()
	local activityProxy = self:getProxy(GameProxys.Activity)
	local activityData = activityProxy:getLimitActivityDataByUitype( ActivityDefine.LIMIT_SMASHEGG_ID )
	if activityData then
		local number = activityProxy:getSmashEggNumber()
		self:setRedPoint( activityData.activityId, number )
		self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
	end
end

--迎春集福
function RedPointProxy:setCollectBlessRed()
	local activityProxy = self:getProxy(GameProxys.Activity)
	local activityData = activityProxy:getLimitActivityDataByUitype( ActivityDefine.LIMIT_COLLECTBLESS_ID )
	if activityData then
		local number = activityProxy:getCollectBlessFullNumber()
		print("刷新迎春红点", number)
		self:setRedPoint( activityData.activityId, number )
		self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
	end
end
--爆竹酉礼小红点
function RedPointProxy:setSpringSquibRed()
	local activityProxy = self:getProxy(GameProxys.Activity)
	local squibInfos = activityProxy:getSquibInfos()
	for k,v in pairs(squibInfos) do
		local redNum = activityProxy:getSquibCanTouchTime(v.activityId)
		self:setRedPoint(v.activityId, redNum)
	end	
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end
--武学讲堂小红点
function RedPointProxy:setMartialRed()
	local activityProxy = self:getProxy(GameProxys.Activity)
	local martialInfos = activityProxy:getMartialInfos()
	for k,v in pairs(martialInfos) do
		local redNum = activityProxy:getMartialFreeTime(v.activityId)
		self:setRedPoint(v.activityId, redNum)
	end	
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end


function RedPointProxy:setPartsGodRed()
	local activityProxy = self:getProxy(GameProxys.Activity)
	local partsGodInfo = activityProxy:getPartsGodInfos()
	if partsGodInfo == nil then
		return
	end
	if rawget(partsGodInfo, "ordnanceTime") ~= nil then
		self:setRedPoint(partsGodInfo.activityId, 1)
	else
		self:setRedPoint(partsGodInfo.activityId, 0)
	end
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end

function RedPointProxy:setAllLimitActivity()
	self:setPartsGodRed()
	self:setSoldierRed()
	self:setEmperorRed()
	self:setDayTrunRed()
	self:setVipRebateRed()
	self:setPullBarRed()
	self:setChargeShareRed()
	self:setSmashEggRed()
	self:setCollectBlessRed()
	self:setSpringSquibRed()
	self:setMartialRed()

	local proxy = self:getProxy(GameProxys.BattleActivity)
	proxy:setActivityRedPoint()
	
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end

function RedPointProxy:getAllLimitRedNum()
	local activityProxy = self:getProxy(GameProxys.Activity)
	local data = activityProxy:getLimitActivityInfo()
	local function findData(id)
		for k,v in pairs(data) do
			if v.activityId == id then
				return v
			end
		end
	end

	local num = 0
	for k,v in pairs(self._allRedPoint) do
		if findData(k) ~= nil then
			num = num + v
		end
	end
	return num
end

function RedPointProxy:updateServerActivity()
	local proxy = self:getProxy(GameProxys.BattleActivity)
	proxy:setActivityRedPoint()
	self:sendNotification(AppEvent.PROXY_REDPOINT_UPDATE, {})
end

function RedPointProxy:getServerActivityRedNum()
	local proxy = self:getProxy(GameProxys.BattleActivity)
	local data = proxy:getRedPointInfo()
	local num = 0
	for k,v in pairs(data) do
		num = num + v
	end
	return num
end

return RedPointProxy
