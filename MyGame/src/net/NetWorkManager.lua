NetWorkManager = class( "NetWorkManager" )

local m_instance = nil

function NetWorkManager:getInstance()
	if m_instance == nil then
		m_instance = NetWorkManager.new()
	end
	return m_instance
end

function NetWorkManager:initNetWorkEvent()
	Notifier.register( "onRecv" , self.onRecv , self )
	Net:getInstance():initNetWork( IP , PORT )
end

function onRecive( data )
	print( data )
	Notifier.dispatch( "onRecv" , data )
end

function onLuaEvent( data )
	-- Notifier.dispatch( "reconnect" )
	local function reconnect()
		print("开始连接服务器")
		Net:getInstance():reConnect()
	end
	Notifier.dispatch( CmdName.MsgBox , { txt = "网络已断开，请检查网络后重新连接！" , sureBtnName = "连接" , sure = reconnect } )
end

function NetWorkManager:onRecv( data )
	-- local protoData = json.decode( data )
	-- local protoNo = protoData.id
	-- Notifier.dispatch( protoNo .. "NetEventFunc" , protoData )

	-- local buff = Utils.decode(data)
	-- local byteArray = ByteArray.new()
 --    byteArray:writeBytes(buff)
	-- local len = byteArray:readInt()
	-- local bId = byteArray:readInt()
	-- local mId = byteArray:readInt()
	-- local body = byteArray:readBytes()
	-- local protoData = protobuf.decode("P" .. bId .. ".P" .. mId .. ".C2S" , body)
end

function NetWorkManager:registerProto( bId )
	if type(bId) ~= "number" then
		return false
	end
	local fileUtils = cc.FileUtils:getInstance()
	local pbName = "P" .. bId .. ".pb" 
	local path = fileUtils:fullPathForFilename( pbName )
	if path == nil or path == "" then
		return false
	end
    local fileData = fileUtils:getStringFromFile( path )
    protobuf.register( fileData )
    return true
end

-- function NetWorkManager:sendProto(protoId , data)
function NetWorkManager:sendProto(mId , cmd , data)
	-- local isCanSend = self:registerProto(mId)
	-- print( isCanSend )
	-- if not isCanSend then	
	-- 	return
	-- end
	-- if self._lastTime ~= nil and self._oldProtoCode ~= nil then
	-- 	local Intervaltime = os.time() - self._lastTime
	-- 	Intervaltime = Intervaltime / 10
	-- 	local protoCode = "P" .. mId .. ".P" .. cmd .. ".C2S"
	-- 	if Intervaltime <= 0.1 and self._oldProtoCode == protoCode then
	-- 		print("小于100毫秒重复发送同一条协议，禁止")
	-- 		return
	-- 	end
	-- end
	-- self._lastTime = os.time()
	-- self._oldProtoCode = "P" .. mId .. ".P" .. cmd .. ".C2S"

	-- local snedData = {}
 --    snedData.moduleId = mId
 --    snedData.cmdId = cmd
 --    snedData.obj = data

	-- self.m_channel:onSend(snedData)

	-- local buffer = protobuf.encode("P" .. bId .. ".P" .. mId .. ".C2S" , data)
	-- print( buffer )


	-- local reqTime = math.abs(math.ceil(os.clock() * 100))
	-- local len = string.len(buffer)
 --    local sendCount = 1
 --    local byteArray = ByteArray.new()
 --    byteArray:writeInt(4 + 1 + (1 + 4 + 4) * sendCount + len)
 --    local curTime = math.abs(reqTime) 
 --    byteArray:writeInt(curTime)
 --    byteArray:writeByte(sendCount)
 --    byteArray:writeInt(string.len(buffer))
 --    byteArray:writeByte(bId)
 --    byteArray:writeInt(mId)
 --    byteArray:writeBytes(buffer)

    -- self._transceiver:send(byteArray:toString())

    -- self._curSendNetCount = self._curSendNetCount + 1

    -- self:addOneSendNet(cmdId)
    -- if self._curSendCount >= self._maxSendFrame then
    --     self._isCanSend = false --达到最大发送条数了
    --     self._curSendCount = 0
    -- end



	-- local byteArray = ByteArray.new()
	-- byteArray:writeInt(string.len(buffer))
 --    byteArray:writeInt(bId)
 --    byteArray:writeInt(mId)
 --    byteArray:writeBytes(buffer)

    -- local protoData = byteArray:toString()
    -- Net:getInstance():sendProto( protoData )



    -- local str = Utils.encode( protoData )


 	local w = {id = mId , name = "zlf" , pwd = "12345"}
	local str = json.encode( w )

	-- data.id = protoId
	-- local str = json.encode( data )
    Net:getInstance():sendProto( str , mId )
end

function NetWorkManager:registerNetEvent( id , func , obj )
	local funcName = id.."NetEventFunc"
	Notifier.register( funcName , func , obj )
end

function NetWorkManager:removeNetEvent(id)
	local funcName = id.."NetEventFunc"
	Notifier.remove( funcName )
end

function NetWorkManager:initWebSocket( ip , port )
	local link  = "ws://" .. ip .. ":" .. port
    self.socket = cc.WebSocket:create(link)
    
    local function wsSendBinaryOpen(strData)
    	print( "wsSendBinaryOpen",strData )
    end

    --接受到数据，进行解析
    local function wsSendBinaryMessage(buffer)
		print( "wsSendBinaryMessage",strData )
    end

    local function wsSendBinaryClose(strData)   
    	print( "wsSendBinaryClose",strData )
    end

    local function wsSendBinaryError(strData)
    	print( "wsSendBinaryError",strData )
    end

    if nil ~= self.socket then
        self.socket:registerScriptHandler(wsSendBinaryOpen,cc.WEBSOCKET_OPEN)
        self.socket:registerScriptHandler(wsSendBinaryMessage,cc.WEBSOCKET_MESSAGE)
        self.socket:registerScriptHandler(wsSendBinaryClose,cc.WEBSOCKET_CLOSE)
        self.socket:registerScriptHandler(wsSendBinaryError,cc.WEBSOCKET_ERROR)
    end
end

function NetWorkManager:send( protoid , data )
	local body = json.encode( data )
	local byteArray = ByteArray.new()
	byteArray:writeInt( protoid )
	byteArray:writeBytes( body )
	self.socket:sendString( byteArray:toString() )
end