

ShareProxy = class("ShareProxy", BasicProxy)

function ShareProxy:ctor()
    ShareProxy.super.ctor(self)
    self.proxyName = GameProxys.Share
    
    self._shareDataMap = {}
    
    self._shareDataMap[1] = {}
    self._shareDataMap[2] = {}
end

function ShareProxy:resetAttr()
    self._shareDataMap = {}
end

function ShareProxy:registerNetEvents( )
end

function ShareProxy:unregisterNetEvents()
end

function ShareProxy:onTriggerNet250000Resp(data)
    self:onShareInfoResp(data)
end

function ShareProxy:shareInfoReq(data)
    self:syncNetReq(AppEvent.NET_M25, AppEvent.NET_M25_C250000, data)
end

function ShareProxy:onShareInfoResp(data)
    if data.rs == 0 then
        local shareType = data.shareType
        local type = data.type
        local id = string.format("%s", tostring(data.id))


        if self._shareDataMap[shareType] == nil then
            self._shareDataMap[shareType] = {}
        end
        
        if self._shareDataMap[shareType][type] == nil then
            self._shareDataMap[shareType][type] = {}
        end

        local shareInfo

        if type == ChatShareType.SOLDIRE_TYPE then
            id = tostring(data.typeId)
            self._shareDataMap[shareType][type][id] = data.soldierInfo
            shareInfo = data.soldierInfo
        elseif type == ChatShareType.REPORT_TYPE then
            self._shareDataMap[shareType][type][id] = data.reportInfo
            shareInfo = data.reportInfo
        elseif type == ChatShareType.ARENA_TYPE then
            self._shareDataMap[shareType][type][id] = data.areanInfo
            shareInfo = data.areanInfo
        elseif type == ChatShareType.RECRUIT_TYPE then
            self._shareDataMap[shareType][type][id] = data.chat
            shareInfo = data.chat
        elseif type == ChatShareType.ADVISER_TYPE then
            self._shareDataMap[shareType][type][id] = data.adviserInfo
            shareInfo = data.adviserInfo
        elseif type == ChatShareType.GMNOTIFIER_TYPE then
            self._shareDataMap[shareType][type][id] = rawget(data, "noticeId") or 0
            shareInfo = rawget(data, "noticeId") or 0
        elseif type == ChatShareType.HERO_TYPE then
            self._shareDataMap[shareType][type][id] = data.heroInfo
            shareInfo = data.heroInfo
        elseif type == ChatShareType.PROP_TYPE then
            self._shareDataMap[shareType][type][id] = data.itemInfo
            shareInfo = data.itemInfo
        elseif type == ChatShareType.ORDNANCE_TYPE then
            self._shareDataMap[shareType][type][id] = data.ordnanceInfo
            shareInfo = data.ordnanceInfo
        elseif type == ChatShareType.RESOURCE_TYPE then
            shareInfo = data.posInfo
        end

        if data.chat ~= nil then
            local roleProxy = self:getProxy(GameProxys.Role)
            local myName = roleProxy:getRoleName()
            local shareName = data.chat.name
            if myName == shareName and type ~= ChatShareType.RECRUIT_TYPE and type ~= ChatShareType.GMNOTIFIER_TYPE then
                self:showSysMessage(TextWords:getTextWord(280174))
            end
        end

        self:sendToChat(data, id, shareInfo)
    end
end

function ShareProxy:sendToChat(shareData, id, shareInfo)
    local data = {}
    data.type = shareData.shareType
    local chats = {}
    local chat = shareData.chat
    
    chat.isShare = true
    chat.shareInfo = shareInfo
--    chat.context = string.format([[<a id="%d" name="%s"><font face="fn18" color="#80d313">%s</font></a>]],
--        shareData.type, tostring(id), chat.context)
    chat.shareId = shareData.type

    -- print("shareData.type===",shareData.type)
    -- print("shareData.type===",shareData.type)
    -- print("shareData.type===",shareData.type)
    chat.shareName = tostring(id)
    table.insert(chats, chat)
    data.chats = chats
    local chatProxy = self:getProxy(GameProxys.Chat)
    chatProxy:onTriggerNet140000Resp(data)
end

function ShareProxy:getShareData(shareType, type, id)
    -- self._shareDataMap[shareType][type][id]
    return self._shareDataMap[shareType][type][id]
end





