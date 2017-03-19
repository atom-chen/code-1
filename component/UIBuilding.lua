--建筑升级 统一UI
UIBuilding = class("UIBuilding", BasicComponent)

function UIBuilding:ctor(parent, panel, tabsPanel)
    UIBuilding.super.ctor(self)
    local function initPanle(skin)
        self:initPanel(skin, panel, tabsPanel)
    end

    local function doLayout()
        self:doLayout(tabsPanel)
    end

    local uiSkin = UISkin.new("UIBuilding", initPanle, doLayout, panel:getModuleName() )
    uiSkin:setParent(parent)
    uiSkin:setTouchEnabled(false)

    
    self._uiSkin = uiSkin
    self._panel = panel
    self._parent = parent

    self:registerEventHandler()
    self:registerProxyEvent()
end

function UIBuilding:initPanel(uiSkin, panel, tabsPanel)
    self._mainPanel = uiSkin:getChildByName("mainPanelN")
    self._mainPanel:setTouchEnabled(false)
    
    self._topPanel = uiSkin:getChildByName("topPanel")

    self._nameTxt = self._topPanel:getChildByName("nameTxt")
    self._infoTxt = self._topPanel:getChildByName("infoTxt")
    self._maxLvTxt = self._topPanel:getChildByName("maxLvTxt")
    self._typeContainer = self._topPanel:getChildByName("typeContainer")
    self._timeTxt = self._topPanel:getChildByName("timeTxt")
    self._buildingCount = self._topPanel:getChildByName("buildingCount")
    self._buildingCount:setVisible(false)  --默认隐藏 已建造数量
    
    self._needListView = self._mainPanel:getChildByName("needListView")
    
    self._timeBarImg = self._mainPanel:getChildByName("timeBarImg")
    self._timeBar = self._mainPanel:getChildByName("timeBar")
    self._remainTxt = self._mainPanel:getChildByName("remainTxt")
    self._tipTxt = self._mainPanel:getChildByName("tipTxt")
        
    self._upBtn = self._mainPanel:getChildByName("upBtn")
    self._cancelBtn = self._mainPanel:getChildByName("cancelBtn")
    self._quickBtn = self._mainPanel:getChildByName("quickBtn")
    self._demolitBtn = self._mainPanel:getChildByName("demolitBtn")

end

function UIBuilding:doLayout(tabsPanel)
     -- 自适应
    -- tabsPanel = tabsPanel 即传入标签，自适应带标签
    -- tabsPanel = type(0) 即传入数字，自适应不带标签
    if tabsPanel then
        NodeUtils:adaptiveTopPanelAndListView(self._topPanel, self._mainPanel, nil, tabsPanel)
    end
end

function UIBuilding:finalize()
    
    if self._UIResourceBuy ~= nil then
        self._UIResourceBuy:finalize()
    end
    self._UIResourceBuy = nil
    local proxy = self._panel:getProxy(GameProxys.Building)
    proxy:removeEventListener(AppEvent.PROXY_UPDATE_ROLE_INFO, self, self.updateAllInfo)
    if self._uiAcceleration ~= nil then
        self._uiAcceleration:finalize()
    end
    self._uiSkin:finalize()
    UIBuilding.super.finalize(self)
end

--太学院快捷跳转后在切换要进行调整
function UIBuilding:adjustView(tabsPanel)
    if tabsPanel then
        NodeUtils:adaptiveTopPanelAndListView(self._topPanel, self._mainPanel, nil, tabsPanel)
    end
end

function UIBuilding:registerProxyEvent()
    local proxy = self._panel:getProxy(GameProxys.Building)
    proxy:addEventListener(AppEvent.PROXY_UPDATE_ROLE_INFO, self, self.updateAllInfo)
end

function UIBuilding:addUIAcceleration()
--    local parent = self._panel:getParent()
    local uiAcceleration = UIAcceleration.new(self._parent, self._panel,true)

    self._uiAcceleration = uiAcceleration
end

function UIBuilding:updateInfo(info, buildingInfo)
    self.info = info
    self.buildingInfo = buildingInfo
--    AudioManager:playEffect("yx02")
    local buildingProxy = self:getProxy(GameProxys.Building)
    self._buildingType = buildingInfo.buildingType
    self._index = buildingInfo.index
    
    local url = string.format("images/buildingIcon/building_%d.png", self._buildingType)
    TextureManager:updateImageView(self._typeContainer,url)
    
    ---显示提示
    if self._buildingType >=8 and self._buildingType <= 10 then
        self._tipTxt:setString(TextWords:getTextWord(18101+self._buildingType))
    else
        self._tipTxt:setString(TextWords:getTextWord(18112))
    end

    --判断是否已经达到最高等级了
    local need = StringUtils:jsonDecode(info.need)
    if #need == 0 then
        self._maxLvTxt:setVisible(true)
        self._mainPanel:setVisible(false)
    else
        self._maxLvTxt:setVisible(false)
        self._mainPanel:setVisible(true)
    end
    
    
    local isFieldBuilding = buildingProxy:isFieldBuilding(buildingInfo.buildingType)
    self._nameTxt:setString(info.name)
    self._isFieldBuilding = isFieldBuilding
    
    local rickLabel = self._rickLabel
    if rickLabel == nil then
        rickLabel = ComponentUtils:createRichLabel("", nil, nil, 2)
        rickLabel:setPosition(self._infoTxt:getPosition())
        self._infoTxt:getParent():addChild(rickLabel)
        self._rickLabel = rickLabel
    end
    rickLabel:setString(info.info)
    
    self._infoTxt:setVisible(false)
--    local enterStr = StringUtils:getStringAddBackEnter(info.info, 18)
--    self._infoTxt:setString(enterStr)
    
    local playerProxy = self._panel:getProxy(GameProxys.Role)
    local rate = playerProxy:getRoleAttrValue(PlayerPowerDefine.NOR_POWER_buildspeedrate)
    local time = TimeUtils:getTimeBySpeedRate(info.time,rate)
    local timeStr = TimeUtils:getStandardFormatTimeString6(time)
    self._timeTxt:setString(timeStr)
    self._upGradeTime = time
    
    self:showBuildingState(buildingInfo.levelTime)
    -- print("建筑升级时间啊啊啊啊",buildingInfo.levelTime)
    
--    self:update()
    --需求渲染
    local neednfos = {}
    
    local commandlv = info.commandlv
    if commandlv > 0 then
        local info = {}
        info.power = GamePowerConfig.Command
        info.typeid = 1
        info.num = commandlv
        table.insert(neednfos, info)
    end
    
    for _, v in pairs(need) do
        local info = {}
        info.power = GamePowerConfig.Resource
        info.typeid = v[1]
        info.num = v[2]
        table.insert(neednfos, info)
    end
    
    self._isFullRes = true
    local roleProxy = self._panel:getProxy(GameProxys.Role)
    for key, info in pairs(neednfos) do
        if info.power == GamePowerConfig.Resource then
            local haveNum = roleProxy:getRolePowerValue(info.power, info.typeid)
            if haveNum < info.num then
                self._isFullRes = false
                break
            end
    	end
    end
    
    if buildingInfo.level == 0 then
        self._upBtn:setTitleText(TextWords:getTextWord(801))
    else
        if self._isFullRes == false then
            self._upBtn:setTitleText(TextWords:getTextWord(819))
        else
            self._upBtn:setTitleText(TextWords:getTextWord(810))
        end
        
    end
    self._isFullLv = true
    self:renderListView(self._needListView, neednfos, self, self.renderNeetListView)
    self._needListView:setItemsMargin(0)

    self:updateBuildingCount(buildingInfo.buildingType)
end

function UIBuilding:showBuildingState(levelTime)

    self._panel["nextWidget"] = self._timeBarImg

    self._panel["nextAccWidget"] = self._timeBarImg
    if self._uiAcceleration ~= nil then
        if self._uiAcceleration:isVisible() then
            self._panel["nextAccWidget"] = nil  --界面还打开，还要引导
        end
    end

    if levelTime > 0 then --在升级
        self._timeBarImg:setVisible(true)
        self._timeBar:setVisible(true)
        self._remainTxt:setVisible(true)

        self._upBtn:setVisible(false)
        self._cancelBtn:setVisible(true)
        self._quickBtn:setVisible(true)
        self._demolitBtn:setVisible(false)

        self._isUpGradeing = true

        self:update()
    else
        self._timeBarImg:setVisible(false)
        self._timeBar:setVisible(false)
        self._remainTxt:setVisible(false)

        self._upBtn:setVisible(true)
        self._cancelBtn:setVisible(false)
        self._quickBtn:setVisible(false)

        if self._isFieldBuilding == true then
            self._demolitBtn:setVisible(true)
        else
            self._demolitBtn:setVisible(false)
        end

        self._isUpGradeing = false
    end
end


function UIBuilding:renderNeetListView(itemPanel, info, index)
    itemPanel:setVisible(true)

    local bgImg = itemPanel:getChildByName("bgImg")
    if index % 2 == 0 then
        bgImg:setVisible(true)
    else
        bgImg:setVisible(false)
    end

    local iconContainer = itemPanel:getChildByName("iconContainer")

    local data = info

    local icon = iconContainer.icon

    if icon == nil then
        icon = UIIcon.new(iconContainer, data, false)
        iconContainer.icon = icon
        icon:setScale(0.6)
    else
        icon:updateData(data)
    end
    
    local nameTxt = itemPanel:getChildByName("nameTxt")
    local needTxt = itemPanel:getChildByName("needTxt")
    local haveTxt = itemPanel:getChildByName("haveTxt")

    local power = data.power
    if power == GamePowerConfig.Command then
        needTxt:setString(string.format("Lv.%d",data.num))
    else
        needTxt:setString(StringUtils:formatNumberByK(data.num, data.typeid))
    end

    nameTxt:setString(icon:getName())

    local roleProxy = self._panel:getProxy(GameProxys.Role)
    local haveNum = roleProxy:getRolePowerValue(data.power, data.typeid)
    local fnum = ""
    if power == GamePowerConfig.Command then
        fnum = string.format("Lv.%d", haveNum)
    else
        fnum = StringUtils:formatNumberByK(haveNum, data.typeid)
    end
    
    -- local yesImg = itemPanel:getChildByName("yesImg")
    -- local noImg = itemPanel:getChildByName("noImg")
    local addBtn = itemPanel:getChildByName("addBtn")
    
    -- self._isFullRes = true
    --算出一个最大可以使用的数量
    
    local str = ""
    if haveNum >= data.num  then --资源够
        haveTxt:setColor(ColorUtils.wordColorLight03)
        str = string.format("√%s", fnum)
        -- yesImg:setVisible(true)
        -- noImg:setVisible(false)
        addBtn:setVisible(false)
    else
        haveTxt:setColor(ColorUtils.wordColorLight04)
        str = string.format("×%s", fnum)
        -- yesImg:setVisible(false)
        -- noImg:setVisible(true)
        if power ~= GamePowerConfig.Command then
            self._isFullRes = false --false=资源不足
        else
            self._isFullLv = false --false=官邸等级不足
        end
        addBtn:setVisible(true)
    end
    haveTxt:setString(str)
    addBtn.data = info
    addBtn.index = index
    ComponentUtils:addTouchEventListener(addBtn, self.onClickAdd, nil, self)
end

function UIBuilding:renderCountDown(remainTime)
    local timeStr = TimeUtils:getStandardFormatTimeString6(remainTime)
    self._remainTxt:setString(timeStr)
    
    local normalUrl = "images/gui/Btn_C_none.png"
    local pressedUrl = "images/gui/Btn_C_down.png"
    local percent = (self._upGradeTime - remainTime) / self._upGradeTime * 100
    if percent < 0 then
        percent = 0
    end
    local roleProxy = self:getProxy(GameProxys.Role)
    self._timeBar:setPercent(percent)
    local str = TextWords:getTextWord(8403)
    self._panel["nextWidget"] = nil
    local freeTime = roleProxy:getFreeTime()
    if remainTime <= freeTime then
        str = TextWords:getTextWord(8404)
        self._panel["nextWidget"] = self._remainTxt

        normalUrl = "images/gui/Btn_A_none.png"
        pressedUrl = "images/gui/Btn_A_down.png"
    else
        local legionHelpProxy = self:getProxy(GameProxys.LegionHelp)
        
        if roleProxy:hasLegion() and legionHelpProxy:isBuildingHelped(self._index, self._buildingType) then
            str = TextWords:getTextWord(8405)
        end
    end
    self._quickBtn:setTitleText(str)

    TextureManager:updateButtonNormal(self._quickBtn, normalUrl)
    TextureManager:updateButtonPressed(self._quickBtn, pressedUrl)
--    if remainTime == 0 then
--        self:showBuildingState(0)
--    end
end

function UIBuilding:registerEventHandler()
    
    ComponentUtils:addTouchEventListener(self._upBtn, self.onUpBtnTouch, nil, self)
    
    ComponentUtils:addTouchEventListener(self._cancelBtn, self.onCancelBtnTouch, nil, self)
    ComponentUtils:addTouchEventListener(self._quickBtn, self.onQuickBtnTouch, nil, self)
    ComponentUtils:addTouchEventListener(self._demolitBtn, self.onDemolitBtnTouch, nil, self)
end

function UIBuilding:onUpBtnTouch(sender)
    AudioManager:playEffect("yx02")
    self:onUpHandler(sender)
end

function UIBuilding:onCancelBtnTouch(sender)
    self:onCancelHandler()
end

function UIBuilding:onQuickBtnTouch(sender, value)
    self:onQuickHandler(value)
end

function UIBuilding:onDemolitBtnTouch(sender)
    self:onDemolitHandler()
end

--建筑升级按钮
function UIBuilding:onUpHandler(sender)
    local buildingProxy = self:getProxy(GameProxys.Building)
    local buildingInfo = buildingProxy:getCurBuildingInfo()

    local data = {}
    data.index = buildingInfo.index
    data.buildingType = buildingInfo.buildingType
    local type = 1
    local function buildingUpgradeReq()
        if type == 1 then
            data.type = type
            buildingProxy:onTriggerNet280001Req(data)
        else
            local info = buildingProxy:getCurBuildingConfigInfo()
            local function callFunc()
                -- 请求元宝升级建筑
                data.type = type
                -- buildingProxy:buildingUpgradeReq(data)
                buildingProxy:onTriggerNet280001Req(data)
            end
            sender.callFunc = callFunc
            sender.money = info.gold
            self:isShowRechargeUI(sender)
        end
    end
    
    if self._isFullRes == false then  --元宝升级
        if self._isFullLv == false then
            -- 官邸等级不足
            local function okCallBack()
                -- body
                sender.index = 0
                self:onClickAdd(sender)
            end
            local content = TextWords:getTextWord(823)
            self._panel:showMessageBox(content, okCallBack)
        else
            -- 资源不足
            type = 2
            local info = buildingProxy:getCurBuildingConfigInfo()
            local content = string.format(TextWords:getTextWord(818), info.gold)
            self._panel:showMessageBox(content, buildingUpgradeReq)
        end

    else --普通升级
       if self._isFullLv == false then
            -- 官邸等级不足
            local function okCallBack()
                -- body
                sender.index = 0
                self:onClickAdd(sender)
            end
            local content = TextWords:getTextWord(823)
            self._panel:showMessageBox(content, okCallBack)
        else 
            type = 1
            buildingUpgradeReq()
        end
    end
end


-- 是否弹窗元宝不足
function UIBuilding:isShowRechargeUI(sender)
    -- body
    local needMoney = sender.money

    local roleProxy = self:getProxy(GameProxys.Role)
    local haveGold = roleProxy:getRoleAttrValue(PlayerPowerDefine.POWER_gold) or 0--拥有元宝

    if needMoney > haveGold then
        local parent = self._panel:getParent()
        -- local parent = self._parent
        local panel = parent.panel
        if panel == nil then
            local panel = UIRecharge.new(parent, self)
            parent.panel = panel
        else
            panel:show()
        end

    else
        sender.callFunc()
    end

end

--取消升级
function UIBuilding:onCancelHandler()
    local function okCallback()
        local buildingProxy = self:getProxy(GameProxys.Building)
        local buildingInfo = buildingProxy:getCurBuildingInfo()
        local data = {}
        -- data.order = -1
        data.buildingType = buildingInfo.buildingType
        data.index = buildingInfo.index

        buildingProxy:onTriggerNet280003Req(data)
        -- buildingProxy:buildingCancelUpgradeReq(data)
    end
    self._panel:showMessageBox(TextWords:getTextWord(808), okCallback)
end

function UIBuilding:onDemolitHandler()
    local function okCallback()
        local buildingProxy = self:getProxy(GameProxys.Building)
        local buildingInfo = buildingProxy:getCurBuildingInfo()
        local data = {}
        -- data.buildingType = buildingInfo.buildingType
        data.index = buildingInfo.index

        buildingProxy:onTriggerNet280005Req(data)
        -- buildingProxy:buildingDemolitionReq(data)
        
        if self._panel.onDemolitHandler ~= nil then
            self._panel:onDemolitHandler()
        end
    end
    self._panel:showMessageBox(TextWords:getTextWord(809), okCallback)
end

--打开加速面板
function UIBuilding:onQuickHandler(value)
    

    local buildingProxy = self:getProxy(GameProxys.Building)
    local buildingInfo = buildingProxy:getCurBuildingInfo()

    local remainTime = buildingProxy:getBuildingUpReTime(self._buildingType, self._index)
    local roleProxy = self:getProxy(GameProxys.Role)
    local freeTime = roleProxy:getFreeTime()
    if remainTime <= freeTime or value == true then
        local data = {}
        data.index = buildingInfo.index
        data.useType = 1
        data.buildingType = buildingInfo.buildingType
        buildingProxy:onTriggerNet280004Req(data)
        return
    else
        local legionHelpProxy = self:getProxy(GameProxys.LegionHelp)
        
        if roleProxy:hasLegion() and legionHelpProxy:isBuildingHelped(self._index, self._buildingType) then
            local buildingProxy = self:getProxy(GameProxys.Building)
            buildingProxy:onTriggerNet280017Req(self._buildingType, self._index)
            legionHelpProxy:showHelp()
            return
        end
    end

    self._panel["nextAccWidget"] = nil --打开了

        -- self._buildingType, self._index
    if self._uiAcceleration == nil then
        self:addUIAcceleration()
    end
    self._uiAcceleration:show(buildingInfo, nil, nil,self._upGradeTime)
    
end


--倒计时 升级倒计时
function UIBuilding:update()
    if self._isUpGradeing == true then
        local buildingProxy = self:getProxy(GameProxys.Building)
        local remainTime = buildingProxy:getBuildingUpReTime(self._buildingType, self._index)
        
        self:renderCountDown(remainTime)
        
    end
    
    if self._uiAcceleration ~= nil then
        self._uiAcceleration:update()
    end
end

function UIBuilding:getProxy(name)
    return self._panel:getProxy(name)
end

function UIBuilding:dispatchEvent(event, data)
    self._panel:dispatchEvent(event, data)
end

function UIBuilding:onClickAdd(sender)
    if self.buildingInfo.buildingType == 1 then
        sender.index = sender.index + 1
    end
    if sender.index == 0 then
        local buildingProxy = self._panel:getProxy(GameProxys.Building)
        local buildingInfo = buildingProxy:getCurBuildingInfo()
        local buildingType, index = buildingInfo.buildingType, buildingInfo.index

        -- logger:info("buildingType=%d, index=%d", buildingType, index)

        local moduleName = nil
        local panelName = nil
        if buildingType >= 2 and buildingType <= 6 then
            -- 资源建筑
            moduleName = "MainSceneModule"
            panelName = BuildingUpPanel.NAME

        else
            -- 功能建筑
            local info = ConfigDataManager:getInfoFindByTwoKey(ConfigData.BuildOpenConfig, "type", 
                buildingType, "ID", index)
            moduleName = info.moduleName
        end


        local function upClose()
            -- print("upClose----------------buildingType, index, moduleName, panelName", buildingType, index, moduleName, panelName)
            buildingProxy:setBuildingPos(buildingType, index)
            local buildingInfo = buildingProxy:getCurBuildingInfo()

            if moduleName == ModuleName.WarehouseModule then --仓库，还是跳回来的
                ModuleJumpManager:jump(ModuleName.MainSceneModule,BuildingUpPanel.NAME)
            else
                ModuleJumpManager:jump(moduleName, panelName)
            end
            
        end

        if moduleName ~= ModuleName.WarehouseModule then
            self._panel:dispatchEvent("hide_self_event")
        end
        
        buildingProxy:setBuildingPos(1, 1)
        local panel = self._panel:getModulePanel(ModuleName.MainSceneModule,BuildingUpPanel.NAME)
        panel:show(upClose)  --通过回调的方式处理这些Panel关系

    else
        if self._UIResourceBuy == nil then --判nil防止重复创建面板
            -- local UIResourceBuy = UIResourceBuy.new(self._uiSkin, self, false)--false：创建但不显示
            local UIResourceBuy = UIResourceBuy.new(self._panel:getParent(), self._panel, false)--false：创建但不显示
            self._UIResourceBuy = UIResourceBuy
        end    
        self._UIResourceBuy:show(sender.index + 1)--显示
    end
end

function UIBuilding:showMessageBox(content,okCallBack)
    self._panel:showMessageBox(content,okCallBack)
end

function UIBuilding:getLayer(name)
    return self._panel:getLayer(name)
end


--资源购买面板的按键请求
function UIBuilding:onItemReq(data)
    local buildingProxy = self._panel:getProxy(GameProxys.Building)
    buildingProxy:buyResourceReq(data)
end

function UIBuilding:updateAllInfo(data)

    if self._uiSkin:isVisible() ~= true then
        return
    end
    local info = self.info
    local buildingInfo = self.buildingInfo
    
    self:updateInfo(info, buildingInfo)
end

-- 显示已建造的数量
function UIBuilding:updateBuildingCount(buildingType)
    local types = {
        4,      --铁
        5,      --石
        3       --木
    }

    for k,type in pairs(types) do
        if type == buildingType then
            local buildingProxy = self:getProxy(GameProxys.Building)
            local number = buildingProxy:getOneTypeBuildingInfo(buildingType)
            if number == nil then
                number = 0
            else
                number = table.size(number)
            end
            local str = string.format(TextWords:getTextWord(8607),number)
            self._buildingCount:setString(str)
            self._buildingCount:setVisible(true)
            return
        else
            self._buildingCount:setVisible(false)
        end
    end

end
