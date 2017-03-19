-- /**
--  * @Author:	  fzw
--  * @DateTime:	2015-12-25 15:07:30
--  * @Description: 玩家技能数据(即战法)
--  */

SkillProxy = class("SkillProxy", BasicProxy)

function SkillProxy:ctor()
    SkillProxy.super.ctor(self)
    self.proxyName = GameProxys.Skill

	self._skillConf = ConfigDataManager:getConfigDataBySortId(ConfigData.SkillConfig)
    self._skillInfos = {}
    self._skillUpData = {}
    self._skillUpConf = {}
    self._skillResetData = {}
end

function SkillProxy:resetAttr()
    self._skillInfos = {}
    self._skillUpData = {}
    self._skillUpConf = {}
    self._skillResetData = {}
end

----------------------------
function SkillProxy:initSyncData(data)
    SkillProxy.super.initSyncData(self, data)
    local tempData = {}
    tempData.skillInfos = data.skillInfos
    tempData.rs = 0
    self:onTriggerNet120000Resp(tempData)
end

-----------------------------------------------------------
-- 请求协议
-----------------------------------------------------------
function SkillProxy:onTriggerNet120000Req(data)
	-- body 列表信息
	self:syncNetReq(AppEvent.NET_M12,AppEvent.NET_M12_C120000, data)
end

function SkillProxy:onTriggerNet120001Req(data)
	-- body 升级
	self:syncNetReq(AppEvent.NET_M12,AppEvent.NET_M12_C120001, data)
end

function SkillProxy:onTriggerNet120002Req(data)
	-- body 重置
	self:syncNetReq(AppEvent.NET_M12,AppEvent.NET_M12_C120002, data)
end

-----------------------------------------------------------
-- 接收协议
-----------------------------------------------------------
function SkillProxy:onTriggerNet120000Resp(data)
	-- body
	if data.rs == 0 and #data.skillInfos > 0 then
		self:setSkillListData(data.skillInfos)
		self:sendNotification(AppEvent.PROXY_SKILL_INFO_UPDATE, {120000})
	end
end

-- 升级
function SkillProxy:onTriggerNet120001Resp(data)
	-- body
	if data.rs == 0 then
		local info = data.skillInfo
		local id = self:getSelectedSkillID()
		if info.skillId ~= nil and id ~= nil and info.skillId == id then

			local conf = self._skillConf[info.skillId]
			self:setSkillUpData(info, conf)

			for k,v in pairs(self._skillInfos) do
				if v.skillId == info.skillId then
					self._skillInfos[k] = info
					break
				end
			end

			self:sendNotification(AppEvent.PROXY_SKILL_INFO_UPDATE, {120001})
		end
	end
end

-- 重置
function SkillProxy:onTriggerNet120002Resp(data)
	-- body
	if data.rs == 0 then
		if #data.skillInfo > 0 then
	    	table.sort(data.skillInfo, function (a,b)return (a.skillId < b.skillId)end)
	    	self:setSkillListData(data.skillInfo)
			self:sendNotification(AppEvent.PROXY_SKILL_INFO_UPDATE, {120002})
		end
	end
end

-----------------------------------------------------------
-- 实例变量
-----------------------------------------------------------
-- 初始化
function SkillProxy:setSkillListData(data)
	-- body
	self._skillInfos = data	
end

-- 升级数据
function SkillProxy:setSkillUpData(data,conf)
	-- body
	self._skillUpData = data	
	self._skillUpConf = conf
end

-- 重置数据
function SkillProxy:setSkillResetData(data)
	-- body
	self._skillResetData = data	
end

--缓存选中升级技能ID
function SkillProxy:setSelectedSkillID(skillID)
	-- body
	self._selectedSkillID = skillID	
end

--获取升级技能ID
function SkillProxy:getSelectedSkillID()
	-- body
	return self._selectedSkillID
end

-----------------------------------------------------------
-- 公共接口
-----------------------------------------------------------
-- 获取技能配表skillconfig数据
function SkillProxy:getSkillConfData()
	-- body
	return self._skillConf
end

-- 获取技能列表数据
function SkillProxy:getSkillListData()
	-- body
	return self._skillInfos
end

-- 获取升级数据
function SkillProxy:getSkillUpData()
	-- body
	return self._skillUpData, self._skillUpConf
end

-- 获取重置数据
function SkillProxy:getSkillResetData()
	-- body
	return self._skillResetData
end
