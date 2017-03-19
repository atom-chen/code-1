
MsgCenter = class("MsgCenter")

function MsgCenter:ctor()
    self._listeners = {}
end

function MsgCenter:finalize()
    self._listeners = {}
end

function MsgCenter:reset()
    self._listeners = {}
end

function MsgCenter:addEventListener(mainevent, subevent, object, fun)

    if mainevent == nil or subevent == nil then
        logger:error("cMsgCenter:addEventListener, mainevent or subevent is null!" .. debug.traceback())
        return
    end

    if self._listeners[mainevent] == nil then
        self._listeners[mainevent] = {}
    end
    if self._listeners[mainevent][subevent] == nil then
        self._listeners[mainevent][subevent] = {}
    end
    local listeners = self._listeners[mainevent][subevent]

    for key,value in pairs(listeners) do
        if value.object == object then
            if value.fun == fun then
                return false
            end
        end
    end

    local listener = {}
    listener.object = object
    listener.fun    = fun
    table.insert(listeners, listener)
    return true
end

function MsgCenter:removeEventListener(mainevent, subevent, object, fun)

    if mainevent == nil or subevent == nil then
        logger:error("MsgCenter:removeEventListener, mainevent or subevent is null!")
        return
    end

    if self._listeners[mainevent] == nil or
        self._listeners[mainevent][subevent] == nil then
        return false
    end
    local listeners = self._listeners[mainevent][subevent]

    for key,value in pairs(listeners) do
        if value.object == object then
            if value.fun == fun then
                table.remove(listeners, key)
                return true
            end
        end
    end

    return false
end

function MsgCenter:sendNotification(mainevent, subevent, data)
    if mainevent == nil or subevent == nil then
        logger:error("MsgCenter:sendNotification, mainevent or subevent is null!" .. debug.traceback())
        return
    end

    if self._listeners[mainevent] ~= nil and
        self._listeners[mainevent][subevent] ~= nil then

        local listeners = self._listeners[mainevent][subevent]

        for key, listener in pairs(listeners) do
            local object    = listener.object
            local fun       = listener.fun
            fun(object, data)
        end
    end
end