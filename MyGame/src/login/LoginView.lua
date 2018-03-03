LoginView = class("LoginView", LayerBase)

LoginView.animation = true
LoginView.config = LayerConfig.life

function LoginView:create()
	local ret = LoginView.new()
	return ret
end

function LoginView:init()
	
	local bgImg = ccui.ImageView:create()
	bgImg:loadTexture("ui/main_bg.jpg")
	bgImg:setPosition(display.cx, display.cy)
	self:addChild(bgImg)

	-- NetWorkManager:getInstance():registerNetEvent( 100 , function(data)
	-- 	print(data , data.id , data.name , data.pwd)
	-- end )

	local function wsSendTextOpen(strData)
		print( "open" )
        -- sendTextStatus:setString("Send Text WS was opened.")
    end

    local function wsSendTextMessage(strData)
   	 	print( strData )
        -- receiveTextTimes= receiveTextTimes + 1
        -- local strInfo= "response text msg: "..strData..", "..receiveTextTimes    
        -- sendTextStatus:setString(strInfo)
    end

    local function wsSendTextClose(strData)
    	self.socket:close()
    	
        print("_wsiSendText websocket instance closed.")
        -- sendTextStatus = nil
        -- wsSendText = nil
    end

    local function wsSendTextError(strData)
        -- print("sendText Error was fired")
    end

	-- local link      = "ws://" .. IP .. ":" .. PORT
 --    self.socket     = cc.WebSocket:create(link)

 --    if nil ~= self.socket then
 --        self.socket:registerScriptHandler(wsSendTextOpen,cc.WEBSOCKET_OPEN)
 --        self.socket:registerScriptHandler(wsSendTextMessage,cc.WEBSOCKET_MESSAGE)
 --        self.socket:registerScriptHandler(wsSendTextClose,cc.WEBSOCKET_CLOSE)
 --        self.socket:registerScriptHandler(wsSendTextError,cc.WEBSOCKET_ERROR)
 --    end
 -- 	local function reconnect()
	-- 	print("开始连接服务器")
	-- 	-- Net:getInstance():reConnect()
	-- end
	-- Notifier.dispatch( CmdName.MsgBox , { txt = "网络已断开，请检查网络后重新连接！" , sureBtnName = "连接" , sure = reconnect } )

	ComponentMgr:addTouch( bgImg , function( sender )
	-- 	print( "~!!~~~" )
		-- local link      = "ws://" .. IP .. ":" .. PORT
  --   	self.socket     = cc.WebSocket:create(link)
		-- self.socket:sendString( "~~~~~" )
		NetWorkManager:getInstance():sendProto( 1 , 100 , {name = "zlf" , pwd = "12345"} )
	end )

	-- TimerManager.addTimer( 1000 , function()
		-- self:close()
	-- end , false )
end

function LoginView:open()
end

function LoginView:close()
	NetWorkManager:getInstance():removeNetEvent( 100 )
	LayerCtrol:getInstance():close(self.name)
end