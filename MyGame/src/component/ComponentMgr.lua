require "RichText"
ComponentMgr = class("ComponentMgr")


--[[
	创建富文本，返回富文本和真实宽度

	--imageview loadtexture模式默认读plist或者textureCache。
	--imageview loadtexture模式默认读plist或者textureCache。
	--imageview loadtexture模式默认读plist或者textureCache。

	参数：params嵌套的table   txt字段用于创建label fontSize字段用于设置lable尺寸 color字段用于设置label的颜色 
	pos字段用于下划线和当前控件的位置偏差，一般传cc.p(0,0)
	isUnderLine字段指定为1才能划线
	img字段用于创建imageview  
	data字段用于回调函数的参数
	所有控件统一回调函数，但是在回调函数里面可以根据参数不同做不同的操作。如果需要回调函数，必须要传data字段，不传默认不回调
	
	maxwidth:设置最大宽度，用于自动换行
	color:全局颜色参数，但是以每个table中的color为优先
	callback:回调函数，不置空必须要传data字段

	例子：
	local p1 = {}
 	p1.txt = "11dddddddd"
 	p1.data = "11撒旦是大事!@#$%^&*())__+''|:}{~!1**卧槽**11"
	p1.color = cc.c3b(200, 120, 0)
	p1.isUnderLine = 1
 	p1.pos = cc.p(0,0)
 	local p2 = {}
 	p2.img = "1-40.png"
 	p2.data = "1-40.png"

 	local p3 = {}
 	p3.txt = "11撒旦是大事!@#$%^&*())__+''|:}{~!1**卧槽**11"
 	p3.data = "11撒旦是大事!@#$%^&*())__+''|:}{~!1**卧槽**11"
	p3.color = cc.c3b(200, 120, 155)

	local params = {}
	params[1] = p1
	params[2] = p2
	params[3] = p3
	

	getRich(params, 300, cc.c3b(200, 120, 155), nil, nil)

	--imageview loadtexture模式默认读plist或者textureCache。
	--imageview loadtexture模式默认读plist或者textureCache。
	--imageview loadtexture模式默认读plist或者textureCache。
]]
function ComponentMgr:getRichLabel(params, maxwidth, color, callback, lineSize)
	local rich = RichLabel:create()
	rich:setData(params, maxwidth, color, lineSize)
	if callback then
		rich:setOnClickHandle(callback)
	end
	local lines = rich:getLines()
	local width = 0
	if lines == 1 then
		width = rich:getRealWidth()
	else
		width = maxwidth
	end
	return rich, width
end

function ComponentMgr:getEditBox(uiType, parent, size, bg, placeHolder, maxLenght, fontSize)
	bg = bg or "ui/input.png"
	fontSize = fontSize or 22
	placeHolder = placeHolder or "请输入："
	local bgSpr = cc.Scale9Sprite:create(bg)
	size = size or bgSpr:getContentSize()
	maxLenght = maxLenght or 5
	print("editBox maxLenght is : "..maxLenght)
	local editBox = cc.EditBox:create(size, bg, uiType)
	editBox:setPlaceHolder(placeHolder)
	editBox:setFontSize(fontSize)
	editBox:setMaxLength(maxLenght)
	parent:addChild(editBox)
	return editBox
end

function ComponentMgr:createNode(csb_name)
	cc.CSLoader:setIsUesPlist(true)
    local node = cc.CSLoader:createNode(csb_name)
    return node
end

function ComponentMgr:showMsgBox(data)
	MsgBox:create(data)
end

function ComponentMgr:addTouch(widget, callback, obj)
	widget:setTouchEnabled(true)
	widget:addTouchEventListener(function(sender, event)
		if event == ccui.TouchEventType.ended then
			if type(callback) == "function" then
				if obj ~= nil then
					callback(obj, widget)
				else
					callback(widget)
				end
			end
		end
	end)
end

function ComponentMgr:showAlert(data)
	Alert:create(data)
end

function ComponentMgr:getRichText(param, maxwidth, callback, this, auto, rowSpace)
	local ret = RichText:create()
	ret:setDrawType(auto or 1)
	ret:setRowSpace(rowSpace or 0)
	ret:init(param, maxwidth, callback, this)
	return ret
end

function ComponentMgr:getButton(text, normal, selectUI, disable, uitype)
	normal = normal or ""
	selectUI = selectUI or ""
	disable = disable or ""
	uitype = uitype or CmdName.useLocal
	local btn = ccui.Button:create(normal, selectUI, disable, uitype)
	btn:setTitleText(text or "")
	return btn
end

function ComponentMgr:setTouch(widget, bool)
	widget:setTouchEnabled(bool)
	local color = bool and cc.c3b(255,255,255) or cc.c3b(150,150,150)
	widget:setColor(color)
end

function ComponentMgr:addBlurBg()
	local parent = LayerMgr:getWinLayer()
	local blurSprite = parent:getChildByName("blur_sprite")
	if blurSprite ~= nil then
		parent:removeChildByName("blur_sprite")
	end
	local winSize = cc.Director:getInstance():getWinSize()
	local renderTexture = ComponentMgr:screenshot()
    local photoTexture = renderTexture:getSprite():getTexture()
    local blurSprite = cc.Sprite:createWithTexture(photoTexture)
    blurSprite:setPosition(winSize.width/2, winSize.height/2)
    blurSprite:visit()
    ComponentMgr:nodeBlur(blurSprite)

    local render_texture1 = cc.RenderTexture:create(winSize.width, winSize.height)
    render_texture1:begin()
    blurSprite:visit() -- 获取
    render_texture1:endToLua()
    local photo_texture1 = render_texture1:getSprite():getTexture()
    local sprite_photo1 = cc.Sprite:createWithTexture(photo_texture1)
        

    blurSprite:removeFromParent()
    sprite_photo1:visit()
    parent:addChild(sprite_photo1)
    sprite_photo1:setName("blur_sprite")
    sprite_photo1:setPosition(winSize.width/2, winSize.height/2)
end

function ComponentMgr:nodeBlur(node, blurRadius, sampleNum)
	--模糊处理
    local vertDefaultSource = "\n".."\n" ..
        "attribute vec4 a_position;\n" ..
        "attribute vec2 a_texCoord;\n" ..
        "attribute vec4 a_color;\n\n" ..
        "\n#ifdef GL_ES\n" .. 
        "varying lowp vec4 v_fragmentColor;\n" ..
        "varying mediump vec2 v_texCoord;\n" ..
        "\n#else\n" ..
        "varying vec4 v_fragmentColor;" ..
        "varying vec2 v_texCoord;" ..
        "\n#endif\n" ..
        "void main()\n" ..
        "{\n" .. 
        "   gl_Position = CC_MVPMatrix * a_position;\n"..
        "   v_fragmentColor = a_color;\n"..
        "   v_texCoord = a_texCoord;\n" ..
        "} \n"
        
    local fileUtiles = cc.FileUtils:getInstance()
    local size = node:getTexture():getContentSizeInPixels()
    local fragSource = fileUtiles:getStringFromFile("shader/example_Blur.fsh")
    local program = cc.GLProgram:createWithByteArrays(vertDefaultSource, fragSource)
    local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(program)
    node:setGLProgramState(glProgramState)
    --设置模糊参数
    node:getGLProgramState():setUniformVec2("resolution", cc.p(size.width, size.height))
    node:getGLProgramState():setUniformFloat("blurRadius", tonumber(sampleNum) or 9)
    node:getGLProgramState():setUniformFloat("sampleNum", tonumber(sampleNum)  or 9)
end

function ComponentMgr:screenshot()
	local winSize = cc.Director:getInstance():getWinSize()
    local renderTexture = cc.RenderTexture:create(winSize.width, winSize.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, gl.DEPTH24_STENCIL8_OES)
    renderTexture:begin()
    SceneCtrol:getInstance():getCurScene():visit()
    renderTexture:endToLua()

    return renderTexture
end