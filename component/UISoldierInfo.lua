UISoldierInfo = class("UISoldierInfo")

function UISoldierInfo:ctor(parent, panel)
    local uiSkin = UISkin.new("UISoldierInfo")
    uiSkin:setParent(parent)
    uiSkin:setName(GlobalConfig.uitopWin.UISoldierInfo)
    
    self._parent = parent
    self._panel = panel
    self._uiSkin = uiSkin
    uiSkin:setLocalZOrder(4000)


    --[[
    new一个二级背景,将全部子节点clone到二级背景下，
    再删除旧的全部子节点    
    ]]
    --begin-------------------------------------------------------------------
    local secLvBg = UISecLvPanelBg.new(self._uiSkin:getRootNode(), self, nil, true)
    secLvBg:setContentHeight(672)
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

    -- 从UISoldilerMainPos拿坑位UI，然后clone加载到当前panel
    local tt = UISoldilerMainPos.new(self._mainPanel)
    self._commonImgPanel = tt:getChildByName("imgPos")
    tt:finalize()  -- UI已经多余了，自杀

    local modelPanel = self._mainPanel:getChildByName("modelPanel")
    local x,y = modelPanel:getPosition()
    modelPanel:setVisible(false)

    self._modelPanel = self._commonImgPanel:clone()
    self._modelPanel:setVisible(true)
    self._modelPanel:setPosition(x,y)
    self._mainPanel:addChild(self._modelPanel)
    -- --end-------------------------------------------------------------------


    ComponentUtils:addTouchEventListener(uiSkin.root, self.onHideTouch, nil, self)
    
    local worldShareBtn = self._mainPanel:getChildByName("worldShareBtn")
    ComponentUtils:addTouchEventListener(worldShareBtn, self.onWorldShareBtnTouch, nil, self)
end

function UISoldierInfo:finalize()
    if self._uiSharePanel ~= nil then
        self._uiSharePanel:finalize()
    end
    self._uiSkin:finalize()
end

function UISoldierInfo:onHideTouch()
    self._uiSkin:setVisible(false)
end

function UISoldierInfo:onWorldShareBtnTouch(sender)
    if self._uiSharePanel == nil then
        self._uiSharePanel = UISharePanel.new(sender, self._panel)
    end
    
    local data = {}
    data.type = ChatShareType.SOLDIRE_TYPE
    data.typeId = self._curTypeid
    self._uiSharePanel:showPanel(sender, data)
end

function UISoldierInfo:updateSoldierInfo(typeid, soldierInfo, isShare)
    self._curTypeid = typeid
    self:renderSoldierBaseInfo(typeid)
    
    local worldShareBtn = self._mainPanel:getChildByName("worldShareBtn")
    local numTxt = self._mainPanel:getChildByName("numTxt")
    if isShare == true then
        worldShareBtn:setVisible(false)
        numTxt:setVisible(false)
    else
        worldShareBtn:setVisible(true)
        numTxt:setVisible(true)

        local soldierProxy = self._panel:getProxy(GameProxys.Soldier)
        local num = soldierProxy:getSoldierCountById(typeid)

        if num == nil or num == 0 then
            NodeUtils:setEnable(worldShareBtn,false)
            numTxt:setVisible(false)
        else
            NodeUtils:setEnable(worldShareBtn,true)
        end
    end


    self:renderSoldierPower(typeid, soldierInfo, isShare)
end

function UISoldierInfo:renderSoldierBaseInfo(typeid)
    self._uiSkin:setVisible(true)
    
    local soldierProxy = self._panel:getProxy(GameProxys.Soldier)
    local num = soldierProxy:getSoldierCountById(typeid)
    
    -- local modelPanel = self._mainPanel:getChildByName("modelPanel")
    
    local showNum = num
    if num == 0 then
        showNum = nil
    end
    ComponentUtils:updateSoliderPos(self._modelPanel,typeid, showNum, nil, nil, nil, false)
    ComponentUtils:setTeamSelectStatusByTeam(self._modelPanel,false)
    
    local info = ConfigDataManager:getConfigById(ConfigData.ArmKindsConfig,typeid)
    
    local nameTxt = self._mainPanel:getChildByName("nameTxt")
    local restrainTxt1 = self._mainPanel:getChildByName("restrainTxt1")
    local restrainTxt2 = self._mainPanel:getChildByName("restrainTxt2")
    local auarTxt1 = self._mainPanel:getChildByName("auarTxt1")
    local auarTxt2 = self._mainPanel:getChildByName("auarTxt2")
    local numTxt = self._mainPanel:getChildByName("numTxt")
    -- local nameCurrentNum = self._mainPanel:getChildByName("nameTxt_1") --当前数量

    nameTxt:setString(info.name)
    nameTxt:setColor(ColorUtils:getColorByQuality(info.color))
    restrainTxt1:setString(info.restrain1 or "")
    restrainTxt2:setString(info.restrain2 or "")
    auarTxt1:setString(info.auar1 or "")
    auarTxt2:setString(info.auar2 or "")
    
    local nameSize = nameTxt:getContentSize()
    numTxt:setPositionX(nameTxt:getPositionX() + nameSize.width + 8)
    numTxt:setString("*"..num)

    if num <= 0 then
        numTxt:setVisible(false)
        -- nameCurrentNum:setVisible(false)
    else
        numTxt:setVisible(true)
        -- nameCurrentNum:setVisible(true)
    end
end

function UISoldierInfo:renderSoldierPower(typeid, soldierInfo, isShare)

    local powerList = nil
    local soldierProxy = self._panel:getProxy(GameProxys.Soldier)
    --不是自己的兵，不能加成
    if soldierInfo == nil and (not isShare) then
        powerList = soldierProxy:getPowerListValue(typeid, true)
    else
        powerList = soldierProxy:getPowerListValue(typeid)
    end
    --分享，直接拿服务端发过来的Powerlist
    if isShare then
        -- powerList = soldierInfo.powerInfo
        powerList = {}
        for k,v in pairs(soldierInfo.powerInfo) do
            powerList[v.powerId] = v.value
        end
    end

    local info = ConfigDataManager:getConfigById(ConfigData.ArmKindsConfig,typeid)
    local basePowerMap = {}
    basePowerMap[SoliderPowerDefine.POWER_hpMax] = info.hpmax
    basePowerMap[SoliderPowerDefine.POWER_atk]   = info.atk
    basePowerMap[SoliderPowerDefine.POWER_hitRate] = info.hitRate
    basePowerMap[SoliderPowerDefine.POWER_dodgeRate] = info.dodgeRate
    basePowerMap[SoliderPowerDefine.POWER_critRate] = info.critRate
    basePowerMap[SoliderPowerDefine.POWER_defRate] = info.defRate
    basePowerMap[SoliderPowerDefine.POWER_wreck] = info.wreck
    basePowerMap[SoliderPowerDefine.POWER_defend] = info.defend
    basePowerMap[SoliderPowerDefine.weight] = info.load
    basePowerMap[SoliderPowerDefine.skill] = info.skillinfo
    
    local powerPanel = self._mainPanel:getChildByName("powerPanel")
    for power, value in pairs(basePowerMap) do
    	local gridPanel = powerPanel:getChildByName("gridPanel" .. power)
    	local nameTxt = gridPanel:getChildByName("nameTxt")
    	local valueTxt = gridPanel:getChildByName("valueTxt")
        local extraTxt = gridPanel:getChildByName("valueTxt_0")  --额外的属性
    	
        if power == 30 then
            local window = gridPanel:getChildByName("window")
            local attImg = window:getChildByName("Image_16")
            local url = string.format("images/littleIcon/"..info.type..".png")
            if url and attImg then
                TextureManager:updateImageView(attImg, url)
            end
        end

    	if powerList ~= nil then
    	    value = powerList[power]
    	end
    	if value == nil then
            value = basePowerMap[power]
    	end
        local extraValue = 0
        if powerList[power] ~= nil and basePowerMap[power] ~= nil then
            extraValue = powerList[power] - basePowerMap[power]
            -- print("power",power, powerList[power], extraValue)
        end

    	local name = TextWords:getTextWord(7000 + power) or ""
    	nameTxt:setString(name)
        valueTxt:setString(basePowerMap[power])
        if power > 3 and power < 8 then
            local tmpValue = basePowerMap[power]/100
            valueTxt:setString(tmpValue.."%")
        elseif power == 8 or power == 9 then
            local tmpValue = basePowerMap[power]/100
            valueTxt:setString(tmpValue)
        elseif power == 3 then
            -- valueTxt:setString(soldierInfo.attack)
            valueTxt:setString(basePowerMap[power])
        elseif power == 1 then
            valueTxt:setString(basePowerMap[power])
            -- valueTxt:setString(soldierInfo.hp)
        end

        if extraValue > 0 then
            if power > 3 and power < 8 then
                local tmpValue = extraValue/100
                extraTxt:setString("+"..tmpValue.."%")
            elseif power==8 or power==9 then
                local tmpValue = extraValue/100
                extraTxt:setString("+"..tmpValue)
            -- elseif power == 3 then
            --     local tmpValue = soldierInfo.attack-basePowerMap[power]
            --     extraTxt:setString("+"..tmpValue)
            -- elseif power == 1 then
            --     local tmpValue =  soldierInfo.hp - basePowerMap[power]
            --     extraTxt:setString("+"..tmpValue)
            else
                 extraTxt:setString("+"..extraValue)
            end
        else
            extraTxt:setString(" ")
        end
        ------kkk 攻击，生命特殊处理
        if power == 3 then
            local attack
            local tmpValue = basePowerMap[power]
            if powerList[power] ~= nil then
                tmpValue = powerList[power] - basePowerMap[power]
            end
            if tmpValue > 0 then
                extraTxt:setString("+"..tmpValue)
            else
                extraTxt:setString(" ")
            end  
        end
        if power == 1 then
            local tmpValue = basePowerMap[power]
            if powerList[power] ~= nil then
                tmpValue = powerList[power] - basePowerMap[power]
            end
            if tmpValue > 0 then
                extraTxt:setString("+"..tmpValue)
            else
                extraTxt:setString(" ")
            end  
        end
        ------kkk
        local xxxx = valueTxt:getContentSize()
        local eneen = valueTxt:getPosition()
        extraTxt:setPositionX(eneen+xxxx.width+5)
    end
end


-- function UISoldierInfo:getChildByName(name)
--     return self._uiSkin:getChildByName(name)
-- end

function UISoldierInfo:getChildByName(name)
    return self._mainPanel:getChildByName(name)
end
