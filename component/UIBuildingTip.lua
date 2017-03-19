UIBuildingTip = class("UIBuildingTip", BasicComponent)

-- type : type=1 表示太学院tip弹窗，默认为nil
function UIBuildingTip:ctor(parent, panel, type)
    UIBuildingTip.super.ctor(self)
    local uiSkin = UISkin.new("UIBuildingTip")
    uiSkin:setParent(parent)

    self._uiSkin = uiSkin
    self._panel = panel
    self.type = type or nil

    --[[
    new一个二级背景,将全部子节点clone到二级背景下，
    再删除旧的全部子节点    
    ]]
    --begin-------------------------------------------------------------------
    local secLvBg = UISecLvPanelBg.new(self._uiSkin:getRootNode(), self, nil, true)
    secLvBg:setContentHeight(540)
    secLvBg:setTitle("")
    self._secLvBg = secLvBg
    secLvBg:hideCloseBtn(false)

    local oldPanel = uiSkin:getChildByName("mainPanel")
    local mainPanel = secLvBg:getMainPanel()
    local panel = oldPanel:clone()
    panel:setName("panel")
    panel:setLocalZOrder(10)
    mainPanel:addChild(panel)
    oldPanel:setVisible(false)
    oldPanel:removeFromParent()

    secLvBg:setTouchEnabled(false)
    mainPanel:setTouchEnabled(false)
    self._mainPanel = mainPanel:getChildByName("panel")
    self._mainPanel:setTouchEnabled(false)
    -- --end-------------------------------------------------------------------


    self._nameTxt = self._mainPanel:getChildByName("nameTxt")
    self._infoTxt = self._mainPanel:getChildByName("infoTxt")
    self._needListView = self._mainPanel:getChildByName("needListView")
    self._timeTxt = self._mainPanel:getChildByName("timeTxt")
    self._iconImg = self._mainPanel:getChildByName("iconImg")  --建筑图标
    self._clock = self._mainPanel:getChildByName("Image_clock")  --时间图标
    
    self:registerEvents()
end

function UIBuildingTip:finalize()
    self._uiSkin:finalize()
    UIBuildingTip.super.finalize(self)
end

function UIBuildingTip:registerEvents()
    ComponentUtils:addTouchEventListener(self._uiSkin.root,self.onCloseTouch, nil, self)
end

function UIBuildingTip:onCloseTouch(sender)
    self._uiSkin:setVisible(false)
end

function UIBuildingTip:updateBuilding(info)

    self._uiSkin:setVisible(true)

    -- self._nameTxt:setString(info.name)

--    local enterStr = StringUtils:getStringAddBackEnter(info.info, 27)
--    self._infoTxt:setString(enterStr)
    
    -- local iconInfo = {}
    -- iconInfo.power = GamePowerConfig.Building
    -- iconInfo.typeid = info.buildingType
    -- iconInfo.num = 0

    
    local iconInfo = {}
    local neednfos = {}
    local nameStr
    local timeStr
    if self.type ~= nil and self.type == 1 then --太学院tip弹窗
        local scienceinfo = info.info
        local need = info.need
        self._infoTxt:setVisible(true)
        self._infoTxt:setString(scienceinfo.configData.desc)

        --名字等级
        nameStr = string.format("%s Lv.%d",scienceinfo.configData.name,scienceinfo.scienceLv)
        timeStr = TimeUtils:getStandardFormatTimeString6(need.time)
        --图标
        iconInfo.power = GamePowerConfig.Other
        iconInfo.typeid = scienceinfo.configData.icon
        iconInfo.num = 0


        local scienceLv = scienceinfo.scienceLv
        local configData = ConfigDataManager:getInfoFindByTwoKey(ConfigData.ScienceLvConfig
            , "scienceType",scienceinfo.scienceType, "reqPrestigeLv", scienceLv + 1) 
        if configData == nil then
            configData= ConfigDataManager:getInfoFindByTwoKey(ConfigData.ScienceLvConfig
                , "scienceType",scienceinfo.scienceType, "reqPrestigeLv", scienceLv) 
        end

        --需求列表
        local listInfo = {}
        local reqSCenterLv = configData.reqSCenterLv
        listInfo.power = GamePowerConfig.Building
        listInfo.typeid = 8
        listInfo.num = reqSCenterLv
        table.insert(neednfos, listInfo)
        
        local reqPrestigeLv = need.reqPrestigeLv
        local listInfo = {}
        listInfo.power = GamePowerConfig.Resource
        listInfo.typeid = PlayerPowerDefine.POWER_prestigeLevel
        listInfo.num = reqPrestigeLv
        table.insert(neednfos, listInfo)

        for _, v in pairs(need.resource) do
            local listInfo = {}
            listInfo.power = v[1]
            listInfo.typeid = v[2]
            listInfo.num = v[3]
            table.insert(neednfos, listInfo)
        end

    else
        local rickLabel = self._rickLabel
        if rickLabel == nil then
            rickLabel = ComponentUtils:createRichLabel("", nil, nil, 2)
            rickLabel:setPosition(self._infoTxt:getPosition())
            self._infoTxt:getParent():addChild(rickLabel)
            self._rickLabel = rickLabel
        end
        rickLabel:setString(info.info)
        self._infoTxt:setVisible(false)        
        
        nameStr = info.name
        timeStr = TimeUtils:getStandardFormatTimeString6(info.time)
        -- 图标
        iconInfo.power = GamePowerConfig.Building
        iconInfo.typeid = info.buildingType or info.type
        iconInfo.num = 0
    
        local need = StringUtils:jsonDecode(info.need)
        
        --需求渲染
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

    end
    
    self._nameTxt:setString(nameStr)
    self._timeTxt:setString(timeStr)

    -- 时间向左对齐名字
    local size = self._nameTxt:getContentSize()
    local x = self._nameTxt:getPositionX()
    self._clock:setPositionX(x + size.width + 40)
    self._timeTxt:setPositionX(self._clock:getPositionX()+40)


    local icon = self._iconImg.icon
    if icon == nil then
        icon = UIIcon.new(self._iconImg,iconInfo,false)
        self._iconImg.icon = icon
    else
        icon:updateData(iconInfo)
    end

    self:renderListView(self._needListView, neednfos, self, self.renderNeetListView)

end

function UIBuildingTip:renderNeetListView(itemPanel, info, index)
    itemPanel:setVisible(true)

    local iconContainer = itemPanel:getChildByName("iconContainer")

    local data = info

    local icon = iconContainer.icon

    if icon == nil then
        icon = UIIcon.new(iconContainer, data, false)
        iconContainer.icon = icon
    else
        icon:updateData(data)
    end
    icon:setScale(GlobalConfig.ResIconScale)  --资源icon缩放大小 ？

    local nameTxt = itemPanel:getChildByName("nameTxt")
    local needTxt = itemPanel:getChildByName("needTxt")
    local haveTxt = itemPanel:getChildByName("haveTxt")

    local power = data.power
    if power == GamePowerConfig.Command then
        needTxt:setString(string.format("Lv.%d",data.num))
    else
        needTxt:setString(StringUtils:formatNumberByK(data.num, data.typeid))
    end

    local nameStr = icon:getName()
    if index == 0 then
        if self.type ~= nil and self.type == 1 then
            nameStr = TextWords:getTextWord(8311)
        end
    end
    nameTxt:setString(nameStr)

    local roleProxy = self._panel:getProxy(GameProxys.Role)
    local haveNum = roleProxy:getRolePowerValue(data.power, data.typeid)
    local buildingProxy = self._panel:getProxy(GameProxys.Building)
    if data.power == GamePowerConfig.Building then  --建筑类型特殊处理
        haveNum = buildingProxy:getBuildingMaxLvByType(data.typeid)
    end
    local fnum = ""
    if power == GamePowerConfig.Command then
        fnum = string.format("Lv.%d", haveNum)
    else
        fnum = StringUtils:formatNumberByK(haveNum, data.typeid)
    end

    --算出一个最大可以使用的数量
    local str = ""
    if haveNum >= data.num  then --资源够
        haveTxt:setColor(ColorUtils.wordColorDark03)
        str = string.format("√%s", fnum)
    else
        haveTxt:setColor(ColorUtils.wordColorDark04)
        str = string.format("×%s", fnum)
    end
    haveTxt:setString(str)

end

