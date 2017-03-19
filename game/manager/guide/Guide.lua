Guide = class("Guide")

function Guide:ctor(gameState)
    self._rootNode = {action = nil, nextNode = nil}
    self._actionNodeList = {}
    self._actionNameList = {}
    
    self.id = 1
    self.triggerType = 0 --触发类型 1事件开始 2事件结束 3宝箱触发
    self.triggerArg = 0 --触发参数 事件id、宝箱次数等
    
    self.name = ""
	self._step = 0
	self.actionStep = 0
	self.isTrigger = true --该引导是否被触发
    self.gameState = gameState
    
end

function Guide:getKey()
    local id = self.id

    local key = "guide" .. id  
    return key
end

function Guide:getKeyState()
    local key = self:getKey()
    local bool = LocalDBManager:getValueForKey(key)
    return bool
end

function Guide:addActionName(name)
    table.insert(self._actionNameList, name)
end

function Guide:addActionList()
    for _, actionName in pairs(self._actionNameList) do
        local GuideAction = require("guideData.action." .. actionName)
        self:addAction(GuideAction.new(self))
    end
end

function Guide:addAction(action)
    table.insert(self._actionNodeList, action)
    action.actionStep = #self._actionNodeList
    if self._rootNode.action == nil then
        self._rootNode.action = action
    else
        local newNode = {action = action, nextNode = nil}
        local curNode = self._rootNode
        while curNode.nextNode ~= nil do
            curNode = curNode.nextNode
        end
        curNode.nextNode = newNode
    end
end

function Guide:onEnter(step, isAlway)

    --TODO 判断该引导是否已经引导过了
    local key = self:getKey()
    local bool =  LocalDBManager:getValueForKey(key)

    if bool ~= nil and isAlway ~= true then --已经引导过了
        self:endAction(true)
        return false
    else
        logger:error("引导开始缓存本地数据")
        LocalDBManager:setValueForKey(key, "true")
    end
    
    self:addActionList()
--    self.gameState:resetInitState() --会关闭所有的free模块
    self:show()
    
    --TODO 引导开始日志
--    game.log.GuideLog:onBeginGuide(self.id)    --引导开始
--    self:sendNotification(AppEvent.GUIDE_MAIN_EVENT,AppEvent.GUIDE_START_EVENT,{})
    
    step = step or 1 --之前停留的步数
    self.actionStep = step - 1
    
    local curNode = self._rootNode
    local curStep = 1
    while curStep < step do
        if curNode == nil then
            
            break
        end
        curNode = curNode.nextNode
        curStep = curStep + 1
    end
    
    self._curNode = curNode
    
    if self._curNode == nil then
        self:endAction()
        return
    end
    
    self:onEnterAction(self._curNode.action, self._curNode)
end

function Guide:getNextActionData()
    local nextNode = self._curNode.nextNode
    return nextNode.action
end

function Guide:nextAction()
    local oldNode = self._curNode
    self._curNode = self._curNode.nextNode
    if self._curNode ~= nil then
        self:onEnterAction(self._curNode.action, oldNode)
    else
    ------------
        self:endAction()
        --引导结束
        --TODO 引导结束日志
--        game.log.GuideLog:onCompleteGuide(self.id) 
    end
end

--跳过引导
function Guide:skipAction()
    self:endAction()
    self:getView():resetView()
    self:guideLog(self.id, 999) --999证明跳过了
    -- self.id = 1
    --TODO 引导跳过日志
--    game.log.GuideLog:onCompleteGuide(self.id, self._step) -- 跳过引导
end

--重置引导视图
function Guide:resetGuideView()
    self:getView():resetView()
end

function Guide:endAction(isAlrGuid)
    
    if isAlrGuid == true then --已经引导过的
    else
        local infos = {}
--        game.log.MissionLog:onCompleted(self.name)
    end
    
    for _, action in pairs(self._actionNodeList) do
        action:finalize()
        action = nil
    end

    -- 跳过引导要清除干净action
    if self._rootNode and self._rootNode.action then
        self._rootNode.action:finalize()
        self._rootNode.action = nil
    end
    -- 跳过引导要清除干净action
    if self._curNode and self._curNode.nextNode and self._curNode.nextNode.action then
        self._curNode.nextNode.action:finalize()
        self._curNode.nextNode.action = nil
        self._curNode.nextNode = nil
    end
    -- print(".... 跳过引导 self.id",self.id)

    self:hide()
    
    GuideManager:endGuide(self)
    LocalDBManager:setValueForKey("guideSnapshot", "")
    
    --TODO
--    self:sendNotification(AppEvent.GUIDE_MAIN_EVENT,AppEvent.GUIDE_END_EVENT,{})
end

function Guide:enterActionByStep(step)

    local oldStep = step
    local guideId = self.id
    local info = ConfigDataManager:getInfoFindByTwoKey(ConfigData.GuideActionConfig, "guideId", guideId, "step", step)
    if info ~= nil then
        local roleProxy = self:getProxy(GameProxys.Role)
        local isReConnect = roleProxy:getReConnectState()
        if isReConnect then
            local reconnectStep = rawget(info,"reconnectStep") or 0
            if reconnectStep > 0 then
                step = reconnectStep  --断线重连返回的引导
                roleProxy:setReConnectState(false)
            end
        else
            step = info.returnStep  --登陆返回的引导
        end
    end

    -- print("~~~还原快照~~~~~enterActionByStep~~~~~~~~~", oldStep, "return:", step)

    if oldStep == 10 then  --这是一步引导加速招兵，需要做特殊逻辑，如果有10只刀兵，就直接跳到下一步
        local soldierProxy = self:getProxy(GameProxys.Soldier)
        local num = soldierProxy:getSoldierCountById(101)
        if num == 10 then
            step = 12 --写死了。引导有改，一定要改这里 直接跳到打剿匪
        end
    end

    if oldStep == 57 then  --这是一步引导加速招兵，需要做特殊逻辑，如果大于10只刀兵，就直接跳到下一步
        local soldierProxy = self:getProxy(GameProxys.Soldier)
        local num = soldierProxy:getSoldierCountById(101)
        if num > 10 then
            step = 59 --写死了。引导有改，一定要改这里 直接跳到离开兵营
        end
    end

    if oldStep == 80 then  --这是一步引导加速招兵，需要做特殊逻辑，如果大于20只枪兵，就直接跳到下一步
        local soldierProxy = self:getProxy(GameProxys.Soldier)
        local num = soldierProxy:getSoldierCountById(102)
        if num >= 20 then
            step = 82 --写死了。引导有改，一定要改这里 直接跳到离开兵营
        end
    end

    self:onEnter(step, true)
    
    if self._curNode ~= nil then
        local action = self._curNode.action
        if action ~= nil then
            local moduleName = action.moduleName
            local panelName = action.panelName
            if moduleName ~= nil then
                if moduleName == ModuleName.DungeonModule then
                    local dungeonProxy = self:getProxy(GameProxys.Dungeon)
                    dungeonProxy:onExterInstanceSender(0)
                elseif moduleName == ModuleName.MainSceneModule and panelName == "BuildingUpPanel" then
                    --升级引导，直接写死了，主城的升级，只有引导到升级官邸的，其他的其他模块
                    local buildingProxy = self:getProxy(GameProxys.Building)
                    buildingProxy:setBuildingPos(1, 1)
                    ModuleJumpManager:jump(moduleName, panelName)
                else
                    ModuleJumpManager:jump(moduleName, panelName)
                end
               
--                self:sendNotification(AppEvent.MODULE_EVENT, AppEvent.MODULE_OPEN_EVENT, {moduleName = moduleName})
            end
        end
    end
end

function Guide:onEnterAction(action, oldNode)
    local delayTime = 0.03
    if oldNode == nil then
    else
        local oldAction = oldNode.action
        delayTime = oldAction.delayTime or 0.03
        delayTime = delayTime <= 0 and 0.03 or delayTime
    end

    -- print("~~~~~~~~~action, oldNode~~~~~~~~~", delayTime)
    
    
    LocalDBManager:setValueForKey("guideSnapshot", self.id .. "-" .. (self.actionStep + 1)) --提前记录
    
--    framework.coro.CoroutineManager:startCoroutine(self.delayEnterAction,self,delayTime, action)
    TimerManager:addOnce(delayTime * 1000, self.delayEnterAction,self,delayTime, action)
end

function Guide:delayEnterAction(delayTime, action)
    self.actionStep = self.actionStep + 1
    logger:error("------进入下一引导回合----id:%d--actionStep:%d", self.id, self.actionStep)
    
    self:guideLog(self.id, self.actionStep)
    --TODO 引导日志
--    GuideLog:onGuideing(self.id, self.actionStep)
    action:onEnter(self)
end

function Guide:guideLog(guideId, step)
    local eventId = tonumber(string.format("%d%03d", guideId, step))
    self.gameState:gameEventLog(eventId)
end

function Guide:show()
    local data = {}
    data["moduleName"] = ModuleName.GuideModule
    data["isPerLoad"] = true
    self:sendNotification(AppEvent.MODULE_EVENT, AppEvent.MODULE_OPEN_EVENT, data)
end

function Guide:hide()
    local data = {}
    data["moduleName"] = ModuleName.GuideModule
    self:sendNotification(AppEvent.MODULE_EVENT, AppEvent.MODULE_CLOSE_EVENT, data)
end

function Guide:hideModule(moduleName)
    local data = {}
    data["moduleName"] = moduleName
    self:sendNotification(AppEvent.MODULE_EVENT, AppEvent.MODULE_CLOSE_EVENT, data)
end

function Guide:showModule(moduleName)
    local data = {}
    data["moduleName"] = moduleName
    self:sendNotification(AppEvent.MODULE_EVENT, AppEvent.MODULE_OPEN_EVENT, data)
end

function Guide:hidePanel(moduleName, panelName)
    local module = self.gameState:getModule(moduleName)
    local panel = module:getPanel(panelName)
    panel:hide()
end

function Guide:getModule(moduleName)
    local module = self.gameState:getModule(moduleName)
    return module
end

function Guide:sendNotification(mainevent, subevent, data)
    self.gameState:sendNotification(mainevent, subevent, data)
end

function Guide:getView()
    local module = self.gameState:getModule(ModuleName.GuideModule)
    return module:getView()
end

function Guide:getWidget(moduleName, panelName, widgetName, backdoor)
    
    local widget = nil
    local localPos = nil
    local module = self.gameState:getModule(moduleName)
    if module == nil then
        return widget
    end
    
    widget = module:getWidget(panelName, widgetName, backdoor)
    return widget
end

function Guide:resetWidget(moduleName, panelName, widgetName, backdoor)

    local widget = nil
    local localPos = nil
    local module = self.gameState:getModule(moduleName)
    if module == nil then
        return widget
    end

    module:resetWidget(panelName, widgetName, backdoor)
end

function Guide:getPanel(moduleName, panelName)
    local module = self.gameState:getModule(moduleName)
    if module == nil then
        return nil
    end
    return module:getPanel(panelName)
end

function Guide:getProxy(name)
    return self.gameState:getProxy(name)
end





