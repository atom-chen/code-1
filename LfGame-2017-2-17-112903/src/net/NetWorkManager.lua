NetWorkManager = class("NetWorkManager")

local fileUtils = cc.FileUtils:getInstance()

local IP = "192.168.10.234"
local Port = 5050

function NetWorkManager:initSocket()
	local socket = SocketTCP.new()
	socket:setName("LuaSocket")
	socket:setTickTime(1)
	socket:setReconnTime(6)
	socket:setConnFailTime(4)

	self._socket = socket

	Notifier.register(SocketTCP.EVENT_DATA, self.recv, self)
	Notifier.register(SocketTCP.EVENT_CLOSE, self.close, self)
	Notifier.register(SocketTCP.EVENT_CLOSED, self.closed, self)
	Notifier.register(SocketTCP.EVENT_CONNECTED, self.connected, self)
	Notifier.register(SocketTCP.EVENT_CONNECT_FAILURE, self.connectedFail, self)

	self._socket:connect(IP, Port, true)
end

function NetWorkManager:registerProto(bId)
	if type(bId) ~= "number" then
		return false
	end
	local pbName = "P" .. bId .. ".pb" 
	local path = fileUtils:fullPathForFilename(pbName)
	if path == nil or path == "" then
		return false
	end
    local fileData = fileUtils:getStringFromFile(path)
    protobuf.register(fileData)
    return true
end

function NetWorkManager:sendProto(bId, mId, data)
	local isCanSend = self:registerProto(bId)
	if not isCanSend then	
		return
	end
	if self._lastTime ~= nil and self._oldProtoCode ~= nil then
		local Intervaltime = os.time() - self._lastTime
		Intervaltime = Intervaltime / 10
		local protoCode = "P" .. bId .. ".P" .. mId .. ".C2S"
		if Intervaltime <= 0.1 and self._oldProtoCode == protoCode then
			print("小于100毫秒重复发送同一条协议，禁止")
			return
		end
	end
	self._lastTime = os.time()
	self._oldProtoCode = "P" .. bId .. ".P" .. mId .. ".C2S"

	local buffer = protobuf.encode("P" .. bId .. ".P" .. mId .. ".C2S" , data)
	-- self._socket:send(buffer)
	local byteArray = ByteArray.new()


	byteArray:writeInt(string.len(buffer))
    byteArray:writeByte(bId)
    byteArray:writeInt(mId)
    byteArray:writeBytes(buffer)

    
    -- print("buffer===",string.len(buffer))

    -- local protoSize = byteArray:readInt()
    -- local protoSize = byteArray:readInt()
    -- local cmdId = byteArray:readByte()
    -- local moduleId = byteArray:readInt()
    -- local txt = byteArray:readBytes()
    
    -- print("cmdId==",cmdId)
    -- print("moduleId==",moduleId)
    -- print("protoSize==",protoSize)
    -- print("txt==",txt)

	self._socket:send(byteArray:toString())
end

--收到数据
function NetWorkManager:recv(byteArray)
	-- local responseSize = byteArray:readByte()
 --    local iscompress = byteArray:readByte()
    -- if iscompress == 1 then
    --     local cbytes = byteArray:readBytes()
    --     local len = string.len(cbytes)
    --     local newByes = uncompress(cbytes)
        
    --     byteArray = ByteArray.new()
    --     byteArray:writeBytes(newByes)
    -- end
    
    -- for i=1, responseSize do
    
    --     local protoSize = byteArray:readInt()
        
    --     local moduleId = byteArray:readInt()
    --     local cmdId = byteArray:readInt()
        
    --     local buffer = byteArray:readBytes(protoSize)
    --     local mId = moduleId
    --     local cmdId = cmdId
    --     self:registerProto(mId)

    --     local data = protobuf.decode("P" .. mId .. ".P" .. cmdId .. ".S2C", buffer, protoSize)
    --     self._recvQueue:push({mId = mId, cmdId = cmdId, data = data})
        
    -- end
    
    -- if responseSize == 0 then --只有一个数据包
    --     local moduleId = byteArray:readInt()
    --     local cmdId = byteArray:readInt()

    --     local buffer = byteArray:readBytes()
    --     local mId = moduleId
    --     local cmdId = cmdId
    --     self:registerProto(mId)

    --     local data = protobuf.decode("M" .. mId .. ".M" .. cmdId .. ".S2C", buffer)
    --     self._recvQueue:push({mId = mId, cmdId = cmdId, data = data})
    -- end
end

--连接成功
function NetWorkManager:connected()
	print("connect server success")
end

function NetWorkManager:connectedFail()

end

function NetWorkManager:close()

end

function NetWorkManager:closed()

end

function NetWorkManager:Destory()

end

--注册协议监听
function NetWorkManager:registerProtoEvent(bId, mId, callback, obj)
	local eventCode = "P" .. bId .. ".P" .. mId .. ".C2S"
	Notifier.register(eventCode, callback, obj)
end

--删除网络监听事件
function NetWorkManager:removeProtoEvent(bId, mId)
	local eventCode = "P" .. bId .. ".P" .. mId .. ".C2S"
	Notifier.remove(eventCode)
end