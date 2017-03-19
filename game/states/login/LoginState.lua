LoginState = class("LoginState",GameBaseState)
function LoginState:ctor()
    LoginState.super.ctor(self)
end

function LoginState:initialize()
    LoginState.super.initialize(self)
    
    AudioManager:playMusic("BGM_login")
    self:openLoginModule()
end

function LoginState:registerModules()
    LoginState.super.registerModules(self)
    
    self:addModuleConfig(ModuleName.LoginModule, "modules.login.LoginModule")
--    self:addModuleConfig(ModuleName.CreateRoleModule, "modules.createRole.CreateRoleModule")
end

function LoginState:addEventHandler()
    LoginState.super.addEventHandler(self)
    self:addProxyEventListener(GameProxys.System, AppEvent.PROXY_SYSTEM_OTHERLOGIN, self, self.onOtherLoginResp)
end

function LoginState:removeHandler()
    LoginState.super.removeHandler(self)
    self:removeProxyEventListener(GameProxys.System, AppEvent.PROXY_SYSTEM_OTHERLOGIN, self, self.onOtherLoginResp)
end

function LoginState:onOtherLoginResp(data)
    local function callback()
        self:sendNotification(AppEvent.NET_EVENT, AppEvent.NET_AUTO_CLOSE_CONNECT, {}) 
    end
    local reason = data.reason
    if reason == "" then
        reason = TextWords:getTextWord(10 + data.rs)
    end
    self:showMessageBox(reason, callback, callback)
end


function LoginState:openLoginModule()
    local data = {}
    data["moduleName"] = ModuleName.LoginModule
    data["isPerLoad"] = true
    self:sendNotification(AppEvent.MODULE_EVENT, AppEvent.MODULE_OPEN_EVENT, data)
    
    AppUtils:loadGameComplete()
end