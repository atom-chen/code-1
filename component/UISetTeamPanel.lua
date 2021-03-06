--
-- Author: zlf
-- Date: 2016年10月12日13:51:45
-- 通过读取/保存阵型面板

--panel 要带getProxy函数

UISetTeamPanel = class("UISetTeamPanel")

function UISetTeamPanel:ctor(panel, data)
	local uiSkin = UISkin.new("UISetTeamPanel")
	local parent = panel:getParent()
    uiSkin:setParent(parent)
    uiSkin:setLocalZOrder(100)

    
    self.secLvBg = UISecLvPanelBg.new(uiSkin:getRootNode(), self)
    self.secLvBg:setContentHeight(650)
    self.secLvBg:setBackGroundColorOpacity(120)
    self.secLvBg:setTitle("阵型记录")
    
    local mainPanel = uiSkin:getChildByName("mainPanel")
    mainPanel:setLocalZOrder(101)

    self._parent = panel
    self._uiSkin = uiSkin
    self.proxy = self._parent:getProxy(GameProxys.Soldier)

    self._teamName = {"一", "二", "三", "四"}

    self:addEvent()

    self:show(data)
end

function UISetTeamPanel:addEvent()
	self.proxy:addEventListener(AppEvent.PROXY_SETTEAM_UPDATE, self, self.hide)
end

function UISetTeamPanel:finalize()
	self.proxy:removeEventListener(AppEvent.PROXY_SETTEAM_UPDATE, self, self.hide)
	self._uiSkin:finalize()
	self._uiSkin = nil
end

function UISetTeamPanel:show(data)
	self._uiSkin:setVisible(true)
	self._teamData = data

	local teaminfo = self.proxy:getTeamDataMap() or {}
	for i=1,4 do
		local panel = self:getChildByName("mainPanel/Panel"..i)
		panel.index = i
		self:updateTeamData(panel, teaminfo[i])
	end
	
end

function UISetTeamPanel:updateTeamData(panel, data)
	panel:setVisible(true)

	local addBtn = panel:getChildByName("addBtn")
	--检查阵型的正确性，空数据或者0数量，不能添加和覆盖
	ComponentUtils:addTouchEventListener(addBtn, self.addTeamInfo, nil,self)
	addBtn:setVisible(data == nil)
	addBtn.id = panel.index
	if addBtn.x == nil then
		addBtn.x = addBtn:getPositionX()
	end

	local readBtn = panel:getChildByName("readBtn")
	ComponentUtils:addTouchEventListener(readBtn, self.readTeamInfo, nil,self)
	readBtn:setVisible(data ~= nil)
	readBtn.data = data
	if readBtn.x == nil then
		readBtn.x = readBtn:getPositionX()
	end


	local coverBtn = panel:getChildByName("coverBtn")
	ComponentUtils:addTouchEventListener(coverBtn, self.addTeamInfo, nil,self)
	coverBtn:setVisible(data ~= nil)
	coverBtn.id = panel.index
	coverBtn.isTips = true
	if coverBtn.x == nil then
		coverBtn.x = coverBtn:getPositionX()
	end

	local teamName = data == nil and "阵型"..self._teamName[panel.index] or data.name

	local inputPanel = panel:getChildByName("infoPanel")
	local editBox = panel.editBox
	local function callback()
		if panel.editBox ~= nil then
			local text = panel.editBox:getText()
			addBtn.text = text
			coverBtn.text = text
		end
    end
	if editBox == nil then
		editBox = ComponentUtils:addEditeBox(inputPanel, inputPanel:getContentSize().width, teamName, callback)
		panel.editBox = editBox
	end
	editBox:setOpacity(0)
	editBox:setFontColor(ColorUtils:color16ToC3b("#eed6aa"))
	--默认名字
	editBox:setText(teamName)
	addBtn.text = teamName
	coverBtn.text = teamName

	self:justBtnPos(coverBtn, addBtn, readBtn, data)
end

function UISetTeamPanel:justBtnPos(coverBtn, addBtn, readBtn, data)
	--读取阵型数据，上面有数据，只能出现选择按钮
	-- if self._type == 1 and data ~= nil then
	-- 	readBtn:setPositionX(addBtn.x)
	-- elseif (self._type == 1 and data == nil) or self._type == 2 then
	-- 	--保存阵型，所有的按钮都还原本来的位置或者选择按钮没出现
	-- 	readBtn:setPositionX(readBtn.x)
	-- end
	
end

function UISetTeamPanel:getChildByName(name)
	return self._uiSkin:getChildByName(name)
end

--设置阵型
function UISetTeamPanel:addTeamInfo(sender)
	if self:checkData() then
		self.proxy:showSysMessage("当前阵形没有部队，无法添加")
		return
	end
	local function callback()
		local sendData = {}
		sendData.info = {}
		sendData.info.type = sender.id
		sendData.info.name = sender.text

		--避免字段过多报错
		sendData.info.members = {}
		local allKey = {"typeid", "num", "post", "adviserId"}
		for k,v in pairs(self._teamData) do
			local data = {}
			for _,key in pairs(allKey) do
				if rawget(v, key) ~= nil then
					data[key] = rawget(v, key)
				end
			end
			table.insert(sendData.info.members, data)
		end
		self.proxy:onTriggerNet70002Req(sendData)
	end

	if sender.isTips ~= nil then
		self.proxy:showMessageBox("是否覆盖该阵型记录", callback)
	else
		callback()
	end
end

--读取阵型
function UISetTeamPanel:readTeamInfo(sender)
	local isNull = self:checkData(sender.data.members)
	if isNull then
		self.proxy:showSysMessage("出战部队有误，请重新选择")
		return
	end
	self.proxy:sendNotification(AppEvent.PROXY_TEAMPOS_UPDATE, sender.data.members)
	self:hide()
end

function UISetTeamPanel:hide()
	self._uiSkin:setVisible(false)
end

function UISetTeamPanel:checkData(data)
	data = data or self._teamData
	local isNull = true
	if data == nil then
		return isNull
	end
	for k,v in pairs(data) do
		if isNull then
			if v.num > 0 then
				isNull = false
				break
			end
		end
	end
	return isNull
end