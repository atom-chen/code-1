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
	bg = bg or "editBg.png"
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

function ComponentMgr:addTouch(widget, callback, param)
	widget:setTouchEnabled(true)
	widget:addTouchEventListener(function(sender, event)
		if event == ccui.TouchEventType.ended then
			if type(callback) == "function" then
				callback(param)
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