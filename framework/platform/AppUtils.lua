
AppUtils = {}

function AppUtils:restartApp()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local result = false
        local args = {"restart"}
        local sigs = "(Ljava/lang/String;)Z"
        local luaj = require "luaj"
        local className = "com/cocos2dx/znlGame/LuaJavaBridgeTest"
        local ok,ret  = luaj.callStaticMethod(className,"restartApplication",args,sigs)
    end
end

function AppUtils:exitApp()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local result = false
        local args = {}
        local sigs = "()Z"
        local luaj = require "luaj"
        local className = "com/cocos2dx/znlGame/LuaJavaBridgeTest"
        local ok,ret  = luaj.callStaticMethod(className,"exitApp",args,sigs)
     elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local args = nil
        local luaoc = require "luaoc"
        local className = "LuaObjectCBridge"
        local ok,ret  = luaoc.callStaticMethod(className,"exitApp",args)
        if not ok then
        else
            print("========openAppStore=========")
        end
    end
end

function AppUtils:openURL(url)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local result = false
        local args = {url}
        local sigs = "(Ljava/lang/String;)Z"
        local luaj = require "luaj"
        local className = "com/cocos2dx/znlGame/LuaJavaBridgeTest"
        local ok,ret  = luaj.callStaticMethod(className,"openURL",args,sigs)
        if not ok then
            logger:error("luaj error: %s", tostring(ret))
        else
            if ret == true then

            end
        end
    end
end

--强更时，打开对应的AppStore IOS平台
function AppUtils:openAppStore(info)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local args = info
        local luaoc = require "luaoc"
        local className = "LuaObjectCBridge"
        local ok,ret  = luaoc.callStaticMethod(className,"openAppStore",args)
        if not ok then
        else
            print("========openAppStore=========")
        end
    end
end

function AppUtils:loadGameComplete()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local result = false
        local args = {url}
        local sigs = "()Z"
        local luaj = require "luaj"
        local className = "com/cocos2dx/znlGame/LuaJavaBridgeTest"
        local ok,ret  = luaj.callStaticMethod(className,"loadGameComplete",args,sigs)
        if not ok then
            logger:error("luaj error: %s", tostring(ret))
        else
            if ret == true then

            end
        end
    end
end

--注意，信息里面不要用#符号
function AppUtils:onEventTCAgent(eventId, eventLabel, infos)
    do 
        return
    end

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local infostr = ""
        
        infostr = infostr .. eventId .. "#" .. eventLabel
        infos = infos or {}
        
        local accountName = GameConfig.accountName
        local serverName = GameConfig.serverName
        local level = GameConfig.level
        if accountName ~= "" then
            infos["accountName"] = accountName
        else
            infos["accountName"] = "未登陆用户"
        end
        if serverName ~= "" then
            infos["serverName"] = serverName
        end
        
        if level > 0 then
            infos["level"] = level
        end
        
        local time = framework.utils.TimeUtils:getDateStrFromCurTime()
        infos["time"] = time
        
--        for key, value in pairs(infos) do
--        	infostr = infostr .. "#" .. key .. "#" .. value
--        end
--        
--        local result = false
--        local args = {infostr}
--        local sigs = "(Ljava/lang/String;)Z"
--        local luaj = require "luaj"
--        local className = "com/cocos2dx/znlGame/LuaJavaBridgeTest"
--        local ok,ret  = luaj.callStaticMethod(className,"onEventTCAgent",args,sigs)
--        if not ok then
--            logger:error("luaj error: %s", tostring(ret))
--        else
--            if ret == true then
--
--            end
--        end
        
--        if _G["TalkingDataGA"] ~= nil then
--            local    eventData  =   {} 
--            eventData["key1"] = eventLabel
--            eventData["key2"] = accountName
--            eventData["key3"] = serverName
--            eventData["key4"] = level
--            eventData["key5"] = time
--            TalkingDataGA:onEvent(eventId, eventData)
--        end
        
        
    end
end

function AppUtils:showWebHtmlView(url)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    local isLocalUrl = string.find(url,"http://") == nil
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        if isLocalUrl == true then
            url = "file:///android_asset/" .. url
        end
        AndroidAppUtils:showWebHtmlView(url)
    end

    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        IosAppUtils:showWebHtmlView(url)
    end
end

--打开语音对话框
function AppUtils:showBaiduASRDigitalDialog()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:showBaiduASRDigitalDialog()
    end
end

--关闭语音对话框
function AppUtils:hideBaiduASRDigitalDialog()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:hideBaiduASRDigitalDialog()
    end
end

function AppUtils:cancelBaiduASRDigitalDialog()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:cancelBaiduASRDigitalDialog()
    end
end

function AppUtils:setMaxRecorderTime(maxTime)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:setMaxRecorderTime(maxTime)
    end
end

-------------------------------------------------------------------
--是否SDK初始化完毕
function  AppUtils:isInitSDKFinish()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        return AndroidAppUtils:isInitSDKFinish()
    end
    return true
end

function AppUtils:initSDKInfo(info)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or 
        (cc.PLATFORM_OS_IPAD == targetPlatform) then

        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        IosAppUtils:initSDKInfo(info)
    end
end

function AppUtils:showLoginView()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:showLoginView()
    elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        IosAppUtils:showLoginView()
    end
end

function AppUtils:showReLogionView()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:showReLogionView()
    elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        IosAppUtils:showLoginView()
    end
end

function AppUtils:sdkLogOut()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:sdkLogOut()
    elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        IosAppUtils:sdkLogOut()
    end
end

function AppUtils:showChargeView(infoJson)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:showChargeView(infoJson)
    elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        IosAppUtils:showChargeView(infoJson)
    end
end

function AppUtils:initSDKExtendData(infoTable)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:initSDKExtendData(infoTable)
    elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        IosAppUtils:initSDKExtendData(infoTable)
    end
end

function AppUtils:sendExtendDataRoleCreate(infoTable)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:sendExtendDataRoleCreate(infoTable)
    elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        IosAppUtils:sendExtendDataRoleCreate(infoTable)
    end
end

function AppUtils:sendExtendDataRoleLevelUp(infoTable)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:sendExtendDataRoleLevelUp(infoTable)
    elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        IosAppUtils:sendExtendDataRoleLevelUp(infoTable)
    end
    
end


function AppUtils:getPhoneInfo()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    local phoneInfo = ""
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        phoneInfo = AndroidAppUtils:getPhoneInfo()
    elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        phoneInfo = IosAppUtils:getPhoneInfo()
    end

    phoneInfo = string.gsub(phoneInfo, "\\/", "/")
    return phoneInfo
end

function AppUtils:canShowFloatIcon(flag)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        local IosAppUtils = require("framework.platform.ios.IosAppUtils")
        IosAppUtils:canShowFloatIcon(flag)
    end
end

--计算MD5值
function AppUtils:calcMD5(str)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    local md5 = ""
--    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
--        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
--        md5 = AndroidAppUtils:calcMD5(str)
--    end
--    if(cc.PLATFORM_OS_WINDOWS == targetPlatform) then
        if generateMD5 ~= nil then
            md5 = generateMD5(str)
        end
--    end
    return md5
    
end

--设置帧率，只有Android有效
function AppUtils:setAnimationInterval(interval)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
   if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:setAnimationInterval(interval)
   end
end

--设置帧率，只有Android有效
function AppUtils:setPushTags(tagsJson)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
   if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:setPushTags(tagsJson)
   end
end

function AppUtils:gameLogout()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
   if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local AndroidAppUtils = require("framework.platform.android.AndroidAppUtils")
        AndroidAppUtils:gameLogout()
   end
end


