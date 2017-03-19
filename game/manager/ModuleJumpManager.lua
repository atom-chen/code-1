--模块跳转管理器
ModuleJumpManager = {}

function ModuleJumpManager:init(gameState)
    self._gameState = gameState
end

function ModuleJumpManager:finalize()

end

function ModuleJumpManager:jump(moduleName, panelName, isPerLoad)

    if table.indexOf(LegionModuleList, moduleName) >= 0 then --
        local roleProxy = self:getProxy(GameProxys.Role)
        if not roleProxy:hasLegion() then --没有军团，提示不能跳转
            self:showSysMessage(TextWords:getTextWord(915))
            return
        end
    end

    local buildingProxy = self:getProxy(GameProxys.Building)
    local buildingConfigInfo, name = buildingProxy:getBuildConfigByModuleName(moduleName)
    if buildingConfigInfo == nil and  name == nil then
        self:showSysMessage(TextWords:getTextWord(356))
        return 
    end
    if buildingConfigInfo ~= nil then
        buildingProxy:setBuildingPos(buildingConfigInfo.type, buildingConfigInfo.ID)
        moduleName = name
    end
    
    if panelName == "ArenaMainPanel" then
        local soldier = self:getProxy(GameProxys.Arena)
        if not soldier:onGetIsSquire() then
            panelName = "ArenaSqurePanel"
        end
    end

    if moduleName == ModuleName.RankModule then
        local roleProxy = self:getProxy(GameProxys.Role)
        local isOpen = roleProxy:isFunctionUnLock(48)
        if not isOpen then
            return
        end
    end

    if moduleName == ModuleName.PartsModule then
        local roleProxy = self:getProxy(GameProxys.Role)
        local isOpen = roleProxy:isFunctionUnLock(12)
        if not isOpen then
            return
        end
    end

    local data = {}
    data.moduleName = moduleName
    data.extraMsg = {}
    data.extraMsg.panelName = panelName
    if isPerLoad ~= nil then
        data.isPerLoad = isPerLoad
    end
    self:sendNotification(AppEvent.MODULE_EVENT, AppEvent.MODULE_OPEN_EVENT, data)
    
    if moduleName == ModuleName.MainSceneModule then
        self._gameState:openModulePanel(moduleName, panelName)
    end
    return true
end

function ModuleJumpManager:sendNotification(mainevent, subevent, data)
    self._gameState:sendNotification(mainevent, subevent, data)
end

function ModuleJumpManager:getProxy(name)
    return self._gameState:getProxy(name)
end

function ModuleJumpManager:showSysMessage(content, color, font)
    self._gameState:showSysMessage(content, color, font)
end

