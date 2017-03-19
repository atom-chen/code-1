TalentProxy = class("TalentProxy", BasicProxy)

function TalentProxy:ctor()
    TalentProxy.super.ctor(self)
    self.proxyName = GameProxys.Talent


    --服务器数据  = M39.WarBookInfo
    self.talentInfo = {}

    --自定义数据 某个兵的属性加成 { [兵id] = {propertyJson, propertyJson}, ... }
    self.extraSoldierPower = {}

end

--//国策信息

-- message TalentInfo{
--   required int32 talentId = 1;//天赋id
--   required int32 talentLv = 2;//对应的天赋等级
-- }

function TalentProxy:initSyncData(data)
    TalentProxy.super.initSyncData(self, data)
    if data.talentInfo ~= nil then
        local tempData = {}
        tempData.talentInfo = data.talentInfo
        tempData.rs = 0
        self:onTriggerNet390000Resp(tempData)
    end
end

--===============================================================
--协议返回
--===============================================================
function TalentProxy:onTriggerNet390000Resp(data)
	if data.rs == 0 then
		self.talentInfo = data.talentInfo or {} --默认值
		self:_renderTalentPower()
		self:sendNotification( AppEvent.PROXY_TALENT_UPDATE )
	end
end

function TalentProxy:onTriggerNet390001Resp(data)
    if data.rs==0 then
		--self.warBookInfo.existTalentPoint = data.talentPoint
		--手动设置升一级
		self:_setTalentLvup( data.talentId )
    	self:_renderTalentPower()
    	self:sendNotification( AppEvent.PROXY_TALENT_UPDATE )
    end
end

function TalentProxy:onTriggerNet390002Resp(data)
	if data.rs==0 then
		-- self.warBookInfo.existTalentPoint = data.talentPoint
		-- self.warBookInfo.talentPointLimit = data.talentPointLimit
		self.talentInfo = {}

		self:_renderTalentPower()
		self:sendNotification( AppEvent.PROXY_TALENT_UPDATE )
	end
end
-- function TalentProxy:onTriggerNet390003Resp(data)
-- 	-- self.warBookInfo.existTalentPoint = data.existTalentPoint
-- 	-- self.warBookInfo.talentPointLimit = data.talentPointLimit
-- 	self:sendNotification( AppEvent.PROXY_TALENT_UPDATE, data )
-- end


--设置等级
function TalentProxy:_setTalentLvup( talentId )
	local isNew = true
	for i,v in ipairs(self.talentInfo) do
		if v.talentId==talentId then
			isNew = false
			v.talentLv = v.talentLv + 1
			print("v.talentLv升一级", v.talentLv)
		end
	end
	if isNew then
		table.insert( self.talentInfo, {
			talentId=talentId,
			talentLv = 1
		} )
			print("新的等级")
	end
end
--设置兵法Power加成
function TalentProxy:_renderTalentPower()
	local map = {}
	for i,v in ipairs(self.talentInfo) do
		if v.talentLv and v.talentLv>0 then
			local conf = self:getWarBookUpgradeByIdLv( v.talentId, v.talentLv ) or {}
			local ArmGradaArr = StringUtils:jsonDecode( conf.ArmGrada or "[]" )

			for _, soldierId in ipairs(ArmGradaArr) do
				map[ soldierId ] = map[ soldierId ] or {}
				table.insert( map[ soldierId ], conf.property )
			end
		end
	end
	self.extraSoldierPower = map
end
--============================================
--============================================
--获得某个天赋信息  M39.TalentInfo
function TalentProxy:getTalentInfoById( talentId )
	for i,v in ipairs(self.talentInfo) do
		if v.talentId==talentId then
			return v
		end
	end
	return nil
end
--获得天赋等级
function TalentProxy:getTalentLvById( talentId )
	for i,v in ipairs(self.talentInfo) do
		if v.talentId==talentId then
			return v.talentLv
		end
	end
	return 0
end
--获得兵力属性加成
function TalentProxy:getSoldierPowerMap( soldierId )
	local map = {}
	local jsons = self.extraSoldierPower[ soldierId ] or {}
    for _, json in ipairs( jsons ) do
        local propertyDatas = StringUtils:jsonDecode( json )
        for i, property in ipairs(propertyDatas) do
	        if property[1] then
	            local key = property[1]
	            local value = property[2]
	            map[key] = map[key] or 0
	            map[key] = map[key] + value
	        end
	    end
    end
	return map
end


--===============================================================
--协议请求
--===============================================================
--国策信息
function TalentProxy:onTriggerNet390000Req()
    self:syncNetReq(AppEvent.NET_M39, AppEvent.NET_M39_C390000, {})
end
--天赋升级 { TalentInfo, talentClass }
function TalentProxy:onTriggerNet390001Req(data)
    self:syncNetReq(AppEvent.NET_M39, AppEvent.NET_M39_C390001, data)
end
--天赋重置
function TalentProxy:onTriggerNet390002Req()
    self:syncNetReq(AppEvent.NET_M39, AppEvent.NET_M39_C390002, {})
end


--===============================================================
--配置表
--===============================================================
function TalentProxy:getWarBookConf()
	local conf = ConfigDataManager:getConfigData( ConfigData.WarBookTalent )
	return conf
end
function TalentProxy:getWarBookConfById( id )
	local ret = ConfigDataManager:getInfoFindByOneKey( ConfigData.WarBookTalent, "ID", id)
	return ret
end
--阶级上限
function TalentProxy:getUnlockNumByClass( class )
	local ret = ConfigDataManager:getInfoFindByOneKey( ConfigData.WarBookClass, "talentClass", class) or {}
	return ret.unlockNum
end
--升级表
function TalentProxy:getWarBookUpgradeByIdLv( id, lv )
	local ret = nil
	if lv>0 then
		ret = ConfigDataManager:getInfoFindByTwoKey( ConfigData.WarBookUpgrade, "talentID", id, "level", lv )
	else
		ret = self:getWarBookConfById( id )
	end
	return ret
end
--重设价格
function TalentProxy:getWarBookParameter()
	local conf = ConfigDataManager:getInfoFindByOneKey( ConfigData.WarBookParameter, "ID", 1)
	return conf.resetPrice
end


--============================================
--============================================

--将表数据按 talentClass 分组
function TalentProxy:getWarBookConfigRowList()
	local conf = self:getWarBookConf()
	local ret = {}
	for i,v in pairs( conf ) do
		local key = v.talentClass
		ret[key] = ret[key] or {}
		table.insert(ret[key], v)
	end
	local newRet = {}
	for _,v in pairs(ret) do
		table.insert( newRet , v )
	end
	return newRet
end

