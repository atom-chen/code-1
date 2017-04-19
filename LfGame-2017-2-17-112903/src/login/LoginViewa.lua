LoginView = class("LoginView", LayerBase)

require "BlurNode"
LoginView.animation = true
LoginView.closeType = LayerConfig.Delay

function LoginView:create()
	local ret = LoginView.new()
	return ret
end

function LoginView:init()
	local bgImg = ccui.ImageView:create("bg/index_bg.jpg")
	bgImg:setPosition(display.cx, display.cy)
	self:addChild(bgImg)

  

  -- local ag = ccui.ImageView:create("bg/index_bg.jpg")
  -- bgImg:addChild(ag)
  -- print("删除前===",tolua.isnull(ag), ag)
  -- bgImg:removeFromParent(true)
  -- -- bgImg:setVisible(true)
  -- -- self:removeFromParent()
  -- TimerManager.addTimer(1000, function()
  --   print("删除后===",tolua.isnull(ag), ag)
  -- end, false)
  
  -- self:addChild(bgImg)

  -- local x = os.clock()

  -- local function afterCaptured(succeed, outputFile)
  --       if succeed then
  --         print("截屏耗时===",os.clock() - x)
  --       else
  --           cclog("Capture screen failed.")
  --       end
  --   end
  --   local fileName = "CaptureScreenTest.png"
  --   cc.utils:captureScreen(afterCaptured, fileName)


	-- self:addBlurSprite()

end


function LoginView:initSocket()

	-- print()
	NetWorkManager:initSocket()
	-- local time = SocketTCP.getTime()
	-- print("socket time:" .. time)

	-- local socket = SocketTCP.new()
	-- socket:setName("TestSocketTcp")
	-- socket:setTickTime(1)
	-- socket:setReconnTime(6)
	-- socket:setConnFailTime(4)

	-- Notifier.register(SocketTCP.EVENT_DATA, self.tcpData, self)
	-- Notifier.register(SocketTCP.EVENT_CLOSE, self.tcpClose, self)
	-- Notifier.register(SocketTCP.EVENT_CLOSED, self.tcpClosed, self)
	-- Notifier.register(SocketTCP.EVENT_CONNECTED, self.tcpConnected, self)
	-- Notifier.register(SocketTCP.EVENT_CONNECT_FAILURE, self.tcpConnectedFail, self)
	-- self.socket_ = socket
	-- -- local ba = ByteArray.new()
	-- -- ba:writeInt(32)
	-- -- ba:readUTF8("32")
	-- -- print(ba:toString())--:getPack())
	-- -- print(Utils.bin2hex("我是谁"))
	-- self:ConnectTest()
end

function LoginView:onSend(sender)
	-- print(self, self.socket_)
	-- self.socket_:send("testData")
end

function LoginView:ConnectTest()
	self.socket_:connect("192.168.10.139", 12345, true)
end

function LoginView:SendDataTest()
	local data = {}
	data.name = "zlf"
	data.pwd = "123456"
	NetWorkManager:sendProto(1, 100, data)
end

-- function LoginView:CloseTest()
-- 	if self.socket_.isConnected then
-- 		self.socket_:close()
-- 	end
-- end

-- function LoginView:tcpData(event)
-- 	-- print("SocketTCP receive data:" , event.data)
-- 	-- print("SocketTCP receive partial:" , event.partial)
-- 	-- print("SocketTCP receive body:" , event.body)
-- 	print("=====",Utils.hex2bin(event.data))
-- end

-- function LoginView:tcpClose()
-- 	print("SocketTCP close")
-- end

-- function LoginView:tcpClosed()
-- 	print("SocketTCP closed")
-- end

-- function LoginView:tcpConnected()
-- 	print("SocketTCP connect success")
-- end

-- function LoginView:tcpConnectedFail()
-- 	print("SocketTCP connect fail")
-- end

--节点变灰和变正常处理
--reset传true  图片为正常模式   nil或者false这是灰化处理
--sprite可以直接传  NodeUtils:showGreyView(sprite, reset) 
--imageview传  NodeUtils:showGreyView(imageview:getVirtualRenderer(), reset) 
function LoginView:showGreyView(node, reset) 
    local vertDefaultSource = "\n"..
                           "attribute vec4 a_position; \n" ..
                           "attribute vec2 a_texCoord; \n" ..
                           "attribute vec4 a_color; \n"..                                                    
                           "#ifdef GL_ES  \n"..
                           "varying lowp vec4 v_fragmentColor;\n"..
                           "varying mediump vec2 v_texCoord;\n"..
                           "#else                      \n" ..
                           "varying vec4 v_fragmentColor; \n" ..
                           "varying vec2 v_texCoord;  \n"..
                           "#endif    \n"..
                           "void main() \n"..
                           "{\n" ..
                            "gl_Position = CC_PMatrix * a_position; \n"..
                           "v_fragmentColor = a_color;\n"..
                           "v_texCoord = a_texCoord;\n"..
                           "}"
 
    --变灰
    local psGrayShader = "#ifdef GL_ES \n" ..
                            "precision mediump float; \n" ..
                            "#endif \n" ..
                            "varying vec4 v_fragmentColor; \n" ..
                            "varying vec2 v_texCoord; \n" ..
                            "void main(void) \n" ..
                            "{ \n" ..
                            "vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
                            "gl_FragColor.xyz = vec3(0.299*c.r + 0.587*c.g +0.114*c.b); \n"..
                            "gl_FragColor.w = c.w; \n"..
                            "}"			


    local pszRemoveGrayShader = "#ifdef GL_ES \n" ..  
        "precision mediump float; \n" ..  
        "#endif \n" ..  
        "varying vec4 v_fragmentColor; \n" ..  
        "varying vec2 v_texCoord; \n" ..  
        "void main(void) \n" ..  
        "{ \n" ..  
        "gl_FragColor = texture2D(CC_Texture0, v_texCoord); \n" ..  
        "}"   

    local shader = reset and pszRemoveGrayShader or psGrayShader

    local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource, shader)
    
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
    pProgram:link()
    pProgram:use()
    pProgram:updateUniforms()
    node:setGLProgram(pProgram)

    local size = node:getTexture():getContentSizeInPixels()
	node:getGLProgramState():setUniformVec2("resolution", cc.p(size.width, size.height))
	node:getGLProgramState():setUniformFloat("blurRadius", 8)
    node:getGLProgramState():setUniformFloat("sampleNum", 8)
end

function LoginView:addBlurSprite()
	self._bgContentHeight = 1
    if self._bgContentHeight > 0 then
        if self:getChildByName("blur_sprite") then
            self:getChildByName("blur_sprite"):removeFromParent()
        end

        local winSize = cc.Director:getInstance():getWinSize()
        local renderTexture = BlurNode:screenshot()
        local photoTexture = renderTexture:getSprite():getTexture()
        local blurSprite = cc.Sprite:createWithTexture(photoTexture)
        blurSprite:setPosition(winSize.width/2, winSize.height/2)
        BlurNode:nodeBlur(blurSprite)


        local renderTexture1 = cc.RenderTexture:create(winSize.width, winSize.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, gl.DEPTH24_STENCIL8_OES)
        renderTexture1:begin()
        blurSprite:visit() -- 渲染
        renderTexture1:endToLua()
        local photoTexture1 = renderTexture1:getSprite():getTexture()
        local spritePhoto1 = cc.Sprite:createWithTexture(photoTexture1)
        

        self:addChild(spritePhoto1, 0)
        spritePhoto1:setName("blur_sprite")
        spritePhoto1:setPosition(winSize.width/2, winSize.height/2)
    end

end