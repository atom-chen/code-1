ChatProxy = class("ChatProxy", BasicProxy)
require "modules.chat.panel.ChatCommon"

local maxChatLen = 50

function ChatProxy:ctor()
    ChatProxy.super.ctor(self)
    self.proxyName = GameProxys.Chat
    self._chatInfoList = {}

    self.MAX_CHAT_LINE = 9
    self._chatSelfInfoList = {} --私聊中一个人的信息
    self._totalInfoList = {}  --总的私聊信息
    self._totalInfoMyselfList = {}  --发送之前的信息
    self._legionChatList = {}  --军团聊天信息
    self.isFromOther = false
    self.myType = 0
    self.oldTime = 0
    self.isComeFromShare = false
end

function ChatProxy:resetAttr()
    self._chatInfoList = {}
    self._chatSelfInfoList = {} --私聊中一个人的信息
    self._totalInfoList = {}  --总的私聊信息
    self._totalInfoMyselfList = {}  --发送之前的信息
    self._legionChatList = {}


end

function ChatProxy:initSyncData(data)
    ChatProxy.super.initSyncData(self, data)

    -- local chatProxy = self:getProxy(GameProxys.Chat)
    self:setReset(true, "isClearWorldChatView")
    self:setReset(true, "isClearLegionChatView")
    self:setReset(true, "isClearPrivateChatView")
    self:sendNotification(AppEvent.CLEAR_TOOLBAR_CMD)

    self._chatInfoList = {}
    self._chatSelfInfoList = {} --私聊中一个人的信息
    self._totalInfoList = {}  --总的私聊信息
    self._totalInfoMyselfList = {}  --发送之前的信息
    self._legionChatList = {}
end

function ChatProxy:registerNetEvents( )
end   
function ChatProxy:unregisterNetEvents( )
end

function ChatProxy:setReset(isreset, key)
    self._isReset = self._isReset or {}
    self._isReset[key] = isreset
end

function ChatProxy:getReset(key)
    self._isReset = self._isReset or {}
    return self._isReset[key]
end

ChatProxy.LegUpdate = false

function ChatProxy:getChats(data)
    return data
--     local result = {}
--     local test = {}
--     for k,v in pairs(data) do
--         test[v.playerId] = {}
--     end
--     for k,v in pairs(data) do
--         test[v.playerId][v.context] = {}
--     end
--     for i=1,#data do
--         if not test[data[i].playerId][data[i].context][data[i].time] then
--             test[data[i].playerId][data[i].context][data[i].time] = true
--             table.insert(result, data[i])
--         else
--             print("有重复数据===",data[i].context)
--         end
--     end
-- --    table.sort( result, function(a,b) return a.time < b.time end )
--     return result
end


function ChatProxy:onTriggerNet140000Req(data)
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140000, data)
end

function ChatProxy:onTriggerNet140100Req(data)
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140100, data)
end

function ChatProxy:onTriggerNet140001Req(data)
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140001, data)
end

function ChatProxy:onTriggerNet140002Req(data)
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140002, data)
end

function ChatProxy:onTriggerNet140003Req(data)
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140003, data)
end

function ChatProxy:onTriggerNet140004Req(data, isChat)
    self._isChat = isChat
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140004, data)
end

function ChatProxy:onTriggerNet140005Req(data)
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140005, data)
end

function ChatProxy:onTriggerNet140006Req(data)
    self.checkShieldType = data.type
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140006, data)
end

function ChatProxy:onTriggerNet140007Req(data)
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140007, data)
end

function ChatProxy:onTriggerNet140009Req(data)
    self:syncNetReq(AppEvent.NET_M14, AppEvent.NET_M14_C140009, data)
end

---------------
function ChatProxy:onTriggerNet140000Resp(data)

    if data.rs ~= nil and data.rs < 0 then
        return  --发送的聊天不符合
    end

    local chats = data.chats
    local worldChatList = {}
    local legionChatList = {}
    for _, chat in pairs(chats) do
        if chat.type == 1 then
            self:addWorldChatInfo(chat)  --添加世界聊天
            table.insert(worldChatList, chat)
        elseif chat.type == 2 then
            self:addLegionChatInfo(chat) --添加军团聊天
            table.insert(legionChatList, chat)
        end
    end

    if #worldChatList > 0 then
        self:sendNotification(AppEvent.PROXY_GET_CHAT_INFO, {type = 1, chats = worldChatList})
    end

    if #legionChatList > 0 then
        self:sendNotification(AppEvent.PROXY_GET_CHAT_INFO, {type = 2, chats = legionChatList})
    end
    
end 

--获取到
function ChatProxy:onTriggerNet140100Resp(data)
    if data.rs == 0 then --TODO 需要映射到具体的控件列表上
        AudioManager:playRecorderSound(data.chatClientId, data.context, data.audioSec)
    end
end

function ChatProxy:onTriggerNet140001Resp(data)
    if data.rs == 0 then
        self:sendNotification(AppEvent.PROXY_GET_CHATPERSON_INFO,data)
    end
end

function ChatProxy:onTriggerNet140002Resp(data)
    self:sendNotification(AppEvent.PROXY_PRIVATECHAT_INFO, data)
end

function ChatProxy:onTriggerNet140003Resp(data)
    self.privateData = data
    self:onUpdateSelfInfo(data)
    self:sendNotification(AppEvent.PROXY_CHAT_RESP,data.chatInfo)
end

function ChatProxy:getIsChat()
    return self._isChat
end

function ChatProxy:onTriggerNet140004Resp(data)
    --区分别处来的还是自己搜索
    if data.rs == 0 and (not self.isFromOther) then
        self:sendNotification(AppEvent.PROXY_PRIVATECHAT,data.info)
    end
    if data.rs == 0 and self.isFromOther then
        self:sendAppEvent(AppEvent.MODULE_EVENT,AppEvent.MODULE_CLOSE_EVENT,{moduleName = ModuleName.ChatModule})
        self.isFromOther = false
        local isChatShow = self:isModuleShow(ChatModule)
        if isChatShow then return end
        local tmp = {}
        tmp["moduleName"] = ModuleName.ChatModule
        tmp["extraMsg"] = {}
        tmp["extraMsg"]["type"] = "privateChat"
        tmp["extraMsg"]["isCloseModule"] = true
        tmp["extraMsg"]["data"] = self.otherPlayerData
        self:sendAppEvent(AppEvent.MODULE_EVENT,AppEvent.MODULE_OPEN_EVENT,tmp)
    end
end

--添加到屏蔽列表
function ChatProxy:onTriggerNet140005Resp(data)
    if data.rs == 0 then
        self:showSysMessage("添加屏蔽成功")
    end
end

function ChatProxy:onTriggerNet140006Resp(data)
    if data.rs == 0 then
        data.type = self.checkShieldType
        self:sendNotification(AppEvent.PROXY_SHIELDCHAT_INFO,data)
    end
end

function ChatProxy:enterPrivate(data)  --进入私聊界面
    -- self:sendNotification(AppEvent.ENTER_PRIVATE,data)   --原本的

    local isOpen = self:isModuleShow(ModuleName.ChatModule)
    if isOpen then
        self.isFromOther = false  --聊天模块已打开
    else
        self.isFromOther = true   --聊天模块未打开
    end

    self.otherPlayerData = data
    local tmpData = {}
    tmpData.type = 0
    tmpData.playerId = data.info.playerId
    self:onTriggerNet140004Req(tmpData)
    -- self:sendServerMessage(AppEvent.NET_M14,AppEvent.NET_M14_C140004, tmpData)
end

function ChatProxy:enterWriteMsg(data)  --写信
    if data["extraMsg"] ~= nil then
        self:sendAppEvent(AppEvent.MODULE_EVENT,AppEvent.MODULE_CLOSE_EVENT,{moduleName = ModuleName.ChatModule})
        self:sendAppEvent(AppEvent.MODULE_EVENT,AppEvent.MODULE_OPEN_EVENT,data)
    else
        self:sendNotification(AppEvent.PROXY_SELF_WRITEMAIL,data)
    end
end

function ChatProxy:onTriggerNet140007Resp(data)  --移除收到
    local type = self.checkShieldType
    self:onShieldPlayerListReq(type)
end
---------------------
--请求查看玩家数据
function ChatProxy:watchPlayerInfoReq(data)
    self:sendServerMessage(AppEvent.NET_M14,AppEvent.NET_M14_C140001, data)
end
--请求屏蔽玩家
function ChatProxy:onShieldPlayerReq(Type,PlayerId)--{type//0:邮件，1：聊天   &   PlayerId}
    self:onTriggerNet140005Req({type = Type, playerId = PlayerId})
end
--屏蔽列表请求
function ChatProxy:onShieldPlayerListReq( Type ) -- 0:邮件，1：聊天
    local data = {type = Type}
    self:onTriggerNet140006Req(data)
end

ChatProxy.chatIsUpdate = false

--添加世界聊天数据
function ChatProxy:addWorldChatInfo(chat)
    -- print("~~~~~ChatProxy:addWorldChatInfo~~~~~~~")
    self.chatIsUpdate = true
    table.insert(self._chatInfoList, chat)
    while #self._chatInfoList > maxChatLen do  --数据内存只缓存20条
        table.remove(self._chatInfoList, 1)
    end
end

function ChatProxy:addLegionChatInfo(chat)
    table.insert(self._legionChatList, chat)
    while #self._legionChatList > maxChatLen do  --数据内存只缓存20条
        table.remove(self._legionChatList, 1)
    end
end

function ChatProxy:getPrivateChatInfo()
    local chatList = {}
    local roleProxy = self:getProxy(GameProxys.Role)
    self._ID = roleProxy:getPlayerId()
    for _,chatInfo in pairs(self._totalInfoList) do
        if chatInfo.playerId == self._ID then
            rawset(chatInfo,"isRender",true)
        end
        if rawget(chatInfo,"isRender") ~= true then
            table.insert(chatList, chatInfo)
            rawset(chatInfo,"isRender",true)
        end
    end
    return chatList
end

function ChatProxy:onUpdateSelfInfo(data)
    -- for _, chat in pairs(data.chats) do
    table.insert(self._totalInfoList, data.chatInfo)
    -- end

    self._totalInfoList = self:getChats(self._totalInfoList)
    while #self._totalInfoList > maxChatLen do  --数据内存只缓存20条
        table.remove(self._totalInfoList, 1)
    end   
end

--获取所有的未读数量
function ChatProxy:getAllNotRenderChatNum()
    return self:getNotRenderWorldChatNum() + self:getNotRenderLegionChatNum() + self:getNotRenderPrivateChatNum()
end

function ChatProxy:getNotRenderPrivateChatNum()   --私聊未读信息总和
    local roleProxy = self:getProxy(GameProxys.Role)
    self._ID = roleProxy:getPlayerId()
    local num = 0
    for _, chatInfo in pairs(self._totalInfoList) do
        if chatInfo.playerId == self._ID then
            rawset(chatInfo,"isRender",true)
        end
        if rawget(chatInfo,"isRender") ~= true then
            num = num + 1
        end
    end
    
    return num
end
function ChatProxy:getNotRenderWorldChatNum()  --世界里未读的信息
    local roleProxy = self:getProxy(GameProxys.Role)
    self._ID = roleProxy:getPlayerId()
    local num = 0
    for _, chatInfo in pairs(self._chatInfoList) do
        --chatInfo.playerId == self._ID and chatInfo.extendValue ~= 1  判断是不是红包
        if chatInfo.playerId == self._ID and chatInfo.extendValue == 0 and rawget(chatInfo,"isShare") ~= true then
            rawset(chatInfo,"isRender",true)
        end
        if rawget(chatInfo,"isRender") ~= true then
            num = num + 1
        end
    end
    return num
end

function ChatProxy:getNotRenderLegionChatNum()  --世界里未读的信息
    local roleProxy = self:getProxy(GameProxys.Role)
    self._ID = roleProxy:getPlayerId()
    local num = 0
    for _, chatInfo in pairs(self._legionChatList) do
        if chatInfo.playerId == self._ID and rawget(chatInfo,"isShare") ~= true then
            rawset(chatInfo,"isRender",true)
        end
        if rawget(chatInfo,"isRender") ~= true then
            num = num + 1
        end
    end
    return num
end

function ChatProxy:getNotRenderWorldChat(firstEnterSelfPanel) --世界里未读的聊天信息 包括分享
    local chatList = {}
    local roleProxy = self:getProxy(GameProxys.Role)
    local playerId = roleProxy:getPlayerId()
    local num = 0
    local allChat = {}

    for _, chatInfo in pairs(self._chatInfoList) do
        if firstEnterSelfPanel or rawget(chatInfo,"isRender") ~= true then
            table.insert(chatList, chatInfo)
            rawset(chatInfo,"isRender",true)
        end 
    end
    return chatList
end

function ChatProxy:getNotRenderLegionChat(firstEnterSelfPanel) --军团里未读的聊天信息 包括分享
    local chatList = {}
    local roleProxy = self:getProxy(GameProxys.Role)
    local playerId = roleProxy:getPlayerId()
    local num = 0
    for _, chatInfo in pairs(self._legionChatList) do
        if rawget(chatInfo,"isRender") ~= true or firstEnterSelfPanel == true then
            table.insert(chatList, chatInfo)
        end
    end
    return chatList
end

function ChatProxy:getNoeRenderSomeBodyChatNum(index) --获取某人未读的信息 index表示第几个人
    local roleProxy = self:getProxy(GameProxys.Role)
    self._ID = roleProxy:getPlayerId()
    local num = 0
    for k, list in pairs(self._totalInfoList) do
        for _, chatInfo in pairs(list) do
            if chatInfo.playerId == self._ID then
               rawset(chatInfo,"isRender",true)
            end
            if rawget(chatInfo,"isRender") ~= true and index == k then
                num = num + 1
            end
        end
    end
    return num
end

--获取最后一个聊天信息
function ChatProxy:getLastChatInfo()
    local pLen = #self._totalInfoList
    if  pLen > 0 then
        return self._totalInfoList[pLen]
    end
    pLen = #self._legionChatList
    if  pLen > 0 then
        return self._legionChatList[pLen]
    end
    pLen = #self._chatInfoList
    if  pLen > 0 then
        return self._chatInfoList[pLen]
    end
end

function ChatProxy:getChatPrivateInfoList(index)
    return self._totalInfoList
end

function ChatProxy:getPrivateData()
    return self.privateData
end

function ChatProxy:saveSelfWorldMsg(data)  --保存自己发的世界信息
    table.insert(self._chatInfoList,data) 
end

function ChatProxy:getPrivateBeforeInfo()
    return self._totalInfoMyselfList
end

function ChatProxy:getLegionChatList()
    return self._legionChatList
end

function ChatProxy:getNotRenderLegionChatNum()  --军团里未读的信息
    local roleProxy = self:getProxy(GameProxys.Role)
    self._ID = roleProxy:getPlayerId()
    local num = 0
    for _, chatInfo in pairs(self._legionChatList) do
        if chatInfo.playerId == self._ID and rawget(chatInfo,"isShare") ~= true then
            rawset(chatInfo,"isRender",true)
        end
        if rawget(chatInfo,"isRender") ~= true then
            num = num + 1
        end
    end
    return num
end

function ChatProxy:enterLegionChat(data) --从军团大厅进入聊天
    if data["extraMsg"] ~= nil then
        -- self:sendAppEvent(AppEvent.MODULE_EVENT,AppEvent.MODULE_CLOSE_EVENT,{moduleName = ModuleName.ChatModule})
        self:sendAppEvent(AppEvent.MODULE_EVENT,AppEvent.MODULE_OPEN_EVENT,data)
    else
        -- self:sendNotification(AppEvent.PROXY_SELF_WRITEMAIL,data)
    end
end

function ChatProxy:onTriggerNet140009Resp(data)
    self.myType = data.type
end

function ChatProxy:getMyType()
    local type = self.myType
    return type
end

function ChatProxy:getlastTime(nowTime) --两次发送的时间差
    local tmpTime = self.oldTime
    if (nowTime - self.oldTime) >= 5 then
        self.oldTime = nowTime
    end
    return nowTime - tmpTime
end