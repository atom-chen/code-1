--
-- 军师信息通用弹窗

UIAdviserInfo = class("UIAdviserInfo")

function UIAdviserInfo:ctor(panel, data, type)
	local uiSkin = UISkin.new("UIAdviserInfo")
    uiSkin:setParent(panel)
    uiSkin:setLocalZOrder(100)

    self.secLvBg = UISecLvPanelBg.new(uiSkin:getRootNode(), self)
    self.secLvBg:setBackGroundColorOpacity(120)
    self.secLvBg:setContentHeight( 460 )

    self._showType = type
    self.proxy = panel:getProxy(GameProxys.Role)

    self._uiSkin = uiSkin
    self._panel = panel

    self.typeId = nil

    local mainPanel = self:getChildByName("Panel_Info")
    mainPanel:setTouchEnabled(false)
    mainPanel:setLocalZOrder(101)

    self._text_info = self:getChildByName("Panel_Info/Panel_57/text_getInfo")
	self.panel_pro = self:getChildByName("Panel_Info/Panel_57/panel_pro")

    self:show(data)
end

function UIAdviserInfo:finalize()
	self._uiSkin:finalize()
	self._uiSkin = nil
end

function UIAdviserInfo:show(info)

	self.secLvBg:setTitle(info.title or TextWords:getTextWord(270018))

	local data = info.adviserInfo
	self:renderView( data )

	self._uiSkin:setVisible(true)

	local btnData = info.tBtnfn
	if btnData == nil then
		for i=1,3 do
			local btn = self:getChildByName("Panel_Info/Panel_57/btn_"..i)
			btn:setVisible(false)
		end
		self._text_info:setVisible(true)
		return
	else
		self._text_info:setVisible(false)
	end

	local btnName = {
		{"btn_2", "btn_1", "btn_3"},
		{"btn_1", "btn_3", "btn_2"},
		{"btn_1", "btn_2", "btn_3"},
	}
	btnName = btnName[#btnData] or {}

	for i=1,3 do
		local btn = self:getChildByName("Panel_Info/Panel_57/"..(btnName[i] or ""))
		btn:setVisible(btnData[i] ~= nil)
		if btnData[i] ~= nil then
			local isRed = btnData[i].isRed and "B" or "A"
			btnData[i].isBright = btnData[i].isBright or false
			btn:loadTextureNormal( "images/gui/Btn_"..isRed.."_Mini_none.png", ccui.TextureResType.plistType )
			btn:loadTexturePressed( "images/gui/Btn_"..isRed.."_Mini_down.png", ccui.TextureResType.plistType )
			btn:setTitleText(btnData[i].name)
			ComponentUtils:addTouchEventListener(btn, function()
				local ret = true
				if btnData[i].click then
					ret = btnData[i].click(info.obj, info.callbackId, btn)
				end
				if ret==true then
					self:hide()
				end
			end, nil,self)
		end
	end
end

function UIAdviserInfo:btnClick(sender)
	
end

function UIAdviserInfo:renderView( data )

	local img_icon = self:getChildByName("Panel_Info/Panel_57/Panel_icon") 
	local bgImg = self:getChildByName("Panel_Info/Panel_57/Image_58")
	local text_des = self:getChildByName("Panel_Info/Panel_57/text_des")

	self.typeId = rawget(data, "typeId")

	logger:error("当前军师id:"..self.typeId)

	local lv = rawget(data, "lv")
	ComponentUtils:renderConsigliereItem( img_icon, self.typeId, lv, nil, true)

	local proxy = self._panel:getProxy(GameProxys.Consigliere)
	local config = proxy:getDataById( self.typeId ) or {} --ConfigDataManager:getConfigById(ConfigData.CounsellorConfig, self.typeId) or {}
	local addInfo = config.addInfo
	self._text_info:setString( config.getinfo or "" ) --来源说明

	config = proxy:getLvData( self.typeId, lv)

	ComponentUtils:updateConsigliereProperty( self.panel_pro, config, self._panel )

	local desStr = ComponentUtils:analyzeConsiglierePropertyStr( config.skillID, addInfo )
	text_des:setString( desStr )

	-- --自适应高度
	-- bgImg:setContentSize( cc.size( bgImg:getContentSize().width, math.max( 250, height) ) )
	-- local bgHeight =  bgImg:getContentSize().height
 --    local contextY = (bgImg:getPositionY()-bgHeight)*0.5+70
	-- local y = bgImg:getPositionY() + height*0.5
	-- panel_pro:setPositionY( y )
 --    self.secLvBg:setContentHeight( bgHeight+160 )
 --    for i=1,3 do
 --    	local btn = self:getChildByName("Panel_Info/Panel_57/btn_"..i )
 --    	btn:setPositionY( contextY )
 --    end
 --    self._text_info:setPositionY( contextY )

end

function UIAdviserInfo:getChildByName(name)
    return self._uiSkin:getChildByName(name)
end

function UIAdviserInfo:getUseTypeId()
	return self.typeId
end

function UIAdviserInfo:hide()
    self._uiSkin:setVisible(false)
end