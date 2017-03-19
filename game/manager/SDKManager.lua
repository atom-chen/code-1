
--充值管理器
SDKManager = {}

SDKManager.orderId = 0

--获取商品ID，确保唯一性
--年月日时分秒+3位游戏代号+2位运营商代号+4位随机数 共23位
function SDKManager:getProductId(amount, chargeType)
    local platId = GameConfig.platformChanleId
    
    GameConfig.chargePlatId = 87

    if platId == 127 then  --三星渠道 直接写死1
        return 1
    end
    
    local productId = ConfigDataManager:getChargeProductId(amount,chargeType,platId)
    if productId ~= nil then
        return productId
    end

    local date = TimeUtils:getCurDateStr()
    local gameId = GameConfig.gameId
    local platformChanleId = string.format("%02d", platId)
    local r1 = math.random(0,9)
    local r2 = math.random(0,9)
    local r3 = math.random(0,9)
    local r4 = math.random(0,9)
    
    local productId = date .. gameId .. platformChanleId .. r1 .. r2 .. r3 .. r4
    return productId
end

function SDKManager:isChargeShow(rechargeInfo)
    local flag = true
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_IPHONE == targetPlatform or 
        cc.PLATFORM_OS_IPAD == targetPlatform then
        if rechargeInfo.money == 1998 then
            flag = false
        end
    end
    return flag
end


function SDKManager:setGameState(gameState)
    self._gameState = gameState
end

--amount  单位 元
function SDKManager:charge(amount, chargeType,name,code)

    if GameConfig.autoLoginDebug ==  true then
        print("=====GameConfig.autoLoginDebug ==  true  so return====")
        return
    end
    
--     if GameConfig.isOpenCharge == false and GameConfig.platformChanleId ~= 0 then --开启充值配置 非3K平台
-- --        component.SysMessage:show("充值功能暂未开启，敬请期待!")
--         print("============开启充值配置 非3K平台==================")
--         return
--     end

    if GameConfig.isOpenCharge == false then
        self._gameState:showSysMessage("充值功能暂未开启，敬请期待!")
        return
    end
    
    --IOS的充值
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_IPHONE == targetPlatform or 
        cc.PLATFORM_OS_IPAD == targetPlatform then
        GameConfig.chargePlatId = 187
        print("===========click button come to SDKManager:charge============")
        local info = {}
        info["roleId"] = StringUtils:fixed64ToNormalStr(GameConfig.actorid)--tostring(GameConfig.actorid)
        info["serverId"] = GameConfig.serverId
        info["serverName"] = GameConfig.serverName
        info["orderTitle"] = name--ConfigDataManager:getChargeProductName(amount,chargeType)
        info["notifyURL"] = GameConfig.payCallbackURL
        info["userInfo"] = tostring(chargeType)
        info["amount"] = amount
        info["productId"] = code--ConfigDataManager:getChargeProductId(amount,chargeType, GameConfig.chargePlatId) --商品ID，生成规则 "xuezuan60"--
        info["identifiers"] = ConfigDataManager:getChargeProductGroup(GameConfig.chargePlatId,"GCOL") --"xuezuan60,xuezuan300,xuezuan980,xuezuan1980,xuezuan3280,xuezuan6480"
        AppUtils:showChargeView(info)
        return
    end

    chargeType = chargeType or 0
    local infoTable = {}
    infoTable["amount"] = amount * 100 --SDK的单位为分
    infoTable["serverId"] = GameConfig.serverId
    infoTable["roleId"] = StringUtils:fixed64ToNormalStr(GameConfig.actorid)
    infoTable["roleName"] = tostring(GameConfig.actorName)
    infoTable["rate"] = 10 --待定
    infoTable["productName"] = ConfigDataManager:getChargeProductName(amount, chargeType) --"血钻"
    infoTable["serverName"] = GameConfig.serverName
    infoTable["callBackInfo"] = tostring(chargeType)
    infoTable["productId"] = self:getProductId(amount, chargeType) --商品ID，生成规则
    infoTable["callbackURL"] = GameConfig.payCallbackURL
    infoTable["lastMoney"] = "0"
    infoTable["roleLevel"] = tostring(GameConfig.level)
    infoTable["sociaty"] = "null"
    infoTable["vipLevel"] = tostring(GameConfig.vipLevel)
    
    self.orderId = infoTable["productId"]
    local iapId = ""
    if chargeType == 1 then
        iapId = "月卡"
    else
        iapId = "购买" .. (amount * 10) .. "元宝"
    end
    
    require("json")
    local infoJson = json.encode(infoTable)
    
    AppUtils:showChargeView(infoJson)
    
    
    if GameConfig.targetPlatform == cc.PLATFORM_OS_WINDOWS then
--        component.SysMessage:show("进入测试充值沙箱")
        logger:error("充值数据：amount:%d, chargeType:%d", amount, chargeType)
--        self:testSendServerCharge(infoTable)
        
--        self:testCharge(infoTable)
    end
--    if game.const.GameConfig.targetPlatform == cc.PLATFORM_OS_WINDOWS then
--        self:testCharge(infoTable)
    if GameConfig.targetPlatform == cc.PLATFORM_OS_ANDROID then--下面是 测试代码 模拟一段时间后充值成功
--        TimerManager:addOnce(3000,self.testSendServerCharge,self,infoTable)
        if GameConfig.serverId == 9999 then
--             framework.coro.CoroutineManager:startCoroutine(self.delayTestCharge,self, infoTable)
        end
    end
    
end

------------java回调回来-------------------
function sdkChargeOnFinish(result)
    local chargeData = json.decode(result)

    local statusCode = chargeData.statusCode
    local desc = chargeData.desc
    
end
-----------------------------

function SDKManager:delayTestCharge(infoTable)
--    component.SysMessage:show("充值测试,3秒后直接充值成功")
    coroutine.yield(180)
    self:testCharge(infoTable)
end

--直接发送到对应的服务器充值测试 发的是充值钻石
function SDKManager:testSendServerCharge(infoTable)

    local url =  GameConfig.payCallbackURL
    local params = {}
    
    params["amount"] = infoTable["amount"] / 100
    params["callback_info"] = infoTable["callBackInfo"]
    params["order_id"] = infoTable["productId"]
    params["role_id"] = infoTable["roleId"]
    params["server_id"] = infoTable["serverId"]
    params["status"] = 1
    params["timestamp"] = os.time()
    params["type"] = 1
    params["user_id"] = 1
    
    local flagStrAry = {}
    table.insert(flagStrAry,params["amount"]) 
    table.insert(flagStrAry,params["callback_info"]) 
    table.insert(flagStrAry,params["order_id"] ) 
    table.insert(flagStrAry,params["role_id"]) 
    table.insert(flagStrAry,params["server_id"]) 
    table.insert(flagStrAry,params["status"]) 
    table.insert(flagStrAry,params["timestamp"]) 
    table.insert(flagStrAry,params["type"]) 
    table.insert(flagStrAry,params["user_id"]) 
    table.insert(flagStrAry,"4872a0d20c60f0906ac4aef9131a4da31111")
    
    local flagStr = table.concat(flagStrAry, "#") 
    local sige = AppUtils:calcMD5(flagStr)
    
    params["sign"] = sige
    
    local function sucess(self, data)
        print(":::testSendServerCharge:::::" .. data, flagStr, sige)
    end
    HttpRequestManager:send(url,params, self, sucess)

--    local server = string.format("http://%s:%d", GameConfig.server, 9978)
--    local url = string.format("%s/change_money?amount=%d&order_id=%s&player_id=%s&callback_info=%s", server,
--        infoTable["amount"] / 100 , 
--        infoTable["productId"],
--        infoTable["roleId"], infoTable["callBackInfo"])
--        
--    local xhr = cc.XMLHttpRequest:new()
--    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
--    xhr:open("GET", url)
--
--    local function onReadyStateChange()
--        if xhr.status == 200 then --接受数据成功
--            local response   = xhr.response
----            if response == "SUCCESS" then
----                component.SysMessage:show("充值测试提示：充值成功")
----            else
----                component.SysMessage:show("充值测试提示：" .. response)
----            end
--        end
--    end
--
--    xhr:registerScriptHandler(onReadyStateChange)
--    xhr:send()
end

function SDKManager:testCharge(infoTable)
    local testUrl = GameConfig.testPayCallbackURL
    local url = string.format("%s?server_id=%s&callback_info=%s&amount=%s&account=%s"
        ,testUrl, tostring(infoTable["serverId"]), tostring(infoTable["callBackInfo"]), tostring(infoTable["amount"] / 100), tostring(infoTable["roleId"]))

    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    local web_server = GameConfig.web_server
    xhr:open("GET", url)

    local function onReadyStateChange()
        if xhr.status == 200 then --接受数据成功
            local response   = xhr.response
            if response == "SUCCESS" then
--                component.SysMessage:show("充值测试提示：充值成功")
            else
--                component.SysMessage:show("充值测试提示：" .. response)
            end
        end
    end

    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
end

function SDKManager:initSDKInfo(info)

    if GameConfig.autoLoginDebug ==  true then
        return
    end
    
    AppUtils:initSDKInfo(info)
end

function SDKManager:showLoginView()

    if GameConfig.autoLoginDebug ==  true then
        return
    end
    
    AppUtils:showLoginView()
end

function SDKManager:showReLogionView()

    if GameConfig.autoLoginDebug ==  true then
        return
    end
    
    AppUtils:showReLogionView()
end

function SDKManager:sdkLogOut()

    if GameConfig.autoLoginDebug ==  true then
        return
    end
    
    AppUtils:sdkLogOut()
end

function SDKManager:initSDKExtendData(userMoney)

    if GameConfig.autoLoginDebug ==  true then
        return
    end
    
    local infoTable = {}
    local roleName = tostring(GameConfig.actorName)
    if roleName == "" then
        roleName = "不存在"
    end
    if GameConfig.roleCreateTime == 0 then
        return --没有创建时间就不统计了
    end
    infoTable["roleId"] = StringUtils:fixed64ToNormalStr(GameConfig.actorid)
    infoTable["roleName"] = roleName
    infoTable["roleLevel"] = tostring(GameConfig.level)
    infoTable["serverId"] = GameConfig.serverId
    infoTable["serverName"] = GameConfig.serverName
    infoTable["vipLevel"] = tostring(GameConfig.vipLevel)
    infoTable["userMoney"] = tostring(userMoney)
    infoTable["serverTime"] = math.ceil(GameConfig.serverTime)
    infoTable["roleCreateTime"] = GameConfig.roleCreateTime
    
--    require("json")
--    local infoJson = json.encode(infoTable)
    AppUtils:initSDKExtendData(infoTable)
end

function SDKManager:sendExtendDataRoleCreate(userMoney)

    if GameConfig.autoLoginDebug ==  true then
        return
    end
    
    local infoTable = {}
    infoTable["roleId"] = StringUtils:fixed64ToNormalStr(GameConfig.actorid)
    infoTable["roleName"] = tostring(GameConfig.actorName)
    infoTable["roleLevel"] = tostring(GameConfig.level)
    infoTable["serverId"] = GameConfig.serverId
    infoTable["serverName"] = GameConfig.serverName
    infoTable["vipLevel"] = tostring(GameConfig.vipLevel)
    infoTable["userMoney"] = tostring(userMoney)
    infoTable["serverTime"] = math.ceil(GameConfig.serverTime)
    infoTable["roleCreateTime"] = GameConfig.roleCreateTime
    
--    require("json")
--    local infoJson = json.encode(infoTable)
    AppUtils:sendExtendDataRoleCreate(infoTable)
end

function SDKManager:sendExtendDataRoleLevelUp(userMoney)
    if GameConfig.autoLoginDebug ==  true then
        return
    end

    local infoTable = {}
    infoTable["roleId"] = StringUtils:fixed64ToNormalStr(GameConfig.actorid)
    infoTable["roleName"] = tostring(GameConfig.actorName)
    infoTable["roleLevel"] = tostring(GameConfig.level)
    infoTable["serverId"] = GameConfig.serverId
    infoTable["serverName"] = GameConfig.serverName
    infoTable["vipLevel"] = tostring(GameConfig.vipLevel)
    infoTable["userMoney"] = tostring(userMoney)
    infoTable["serverTime"] = math.ceil(GameConfig.serverTime)
    infoTable["roleCreateTime"] = GameConfig.roleCreateTime

--    require("json")
--    local infoJson = json.encode(infoTable)
    AppUtils:sendExtendDataRoleLevelUp(infoTable)
end

function SDKManager:canShowFloatIcon(flag)
    AppUtils:canShowFloatIcon(flag)
end

function SDKManager:showWebHtmlView(url)
    AppUtils:showWebHtmlView(url)
end

--打开语音面板
function SDKManager:showASRDigitalDialog()
    AppUtils:showBaiduASRDigitalDialog()
end

--关闭语音面板--完成一次录音
function SDKManager:hideASRDigitalDialog()
    AppUtils:hideBaiduASRDigitalDialog()
end

--取消语音 关闭面板
function SDKManager:cancelASRDigitalDialog()
    AppUtils:cancelBaiduASRDigitalDialog()
end

function SDKManager:setMaxRecorderTime(maxTime)
    AppUtils:setMaxRecorderTime(maxTime)
end

--退出APP
function SDKManager:exitApp()
    AppUtils:exitApp()
end

--是否SDK初始化完毕
function SDKManager:isInitSDKFinish()
    return AppUtils:isInitSDKFinish()
end

--设置帧率
function SDKManager:setAnimationInterval(interval)
    AppUtils:setAnimationInterval(interval)
    cc.Director:getInstance():setAnimationInterval(1.0 / interval)
end

--设置push tags
function SDKManager:setPushTags(tags)
    require("json")
    local tagsJson = json.encode(tags)
    AppUtils:setPushTags(tagsJson)

end

--点击url链接跳转
function SDKManager:openURL(url)
    AppUtils:openURL(url)
end

function SDKManager:gameLogout()
    AppUtils:gameLogout()
end

