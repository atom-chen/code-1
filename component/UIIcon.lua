UIIcon = class("UIIcon")

--data.power data.typeid data.num

-- @param  parent [node] 父节点
-- @param  data [table] 数据
-- @param  data.customNumStr [number/string/table] = 自定义的数量信息，支持数字/字符串/富文本（如：00/00）
-- @param  isShowNum [bool] 显示数量
-- @param  panel [node] 创建层self
-- @param  isMainScene [bool] 是否为主城
-- @param  isShowName [bool] 显示名称
-- @return nil
function UIIcon:ctor(parent, data, isShowNum, panel, isMainScene, isShowName, isNumNotStr, otherNumber, effectDelayTime)
    self._parent = parent
    self._effectQueue = {}
    if isShowNum == nil then
        self._isShowNum = true
    else
        self._isShowNum = isShowNum
    end
    
    self._isShowName = isShowName or false

    self._isMainScene = isMainScene     --是主城则不显示icon的bg    
    self._isNumNotStr = isNumNotStr     --false=数量用0.0k格式，true=数量用纯数字格式
    self._otherNumber = otherNumber     --Other类型ICON 自定义品质颜色
    self._showEffectDalay = effectDelayTime or 0

    self._panel = panel
    
    local icon = parent:getChildByName("Icon")
    if icon ~= nil then
        logger:info("======icon竟然有值！==========:%s========", debug.traceback())
    end
    
    self:updateData(data)
end

function UIIcon:finalize()
    for k,v in pairs(self._effectQueue) do
        v:finalize()
    end
    if self._parent.model ~= nil then
        self._parent.model:finalize()
        self._parent.model = nil
    end
    if self._iconBg ~= nil then
        self._iconBg:removeAllChildren()
        self._iconBg:removeFromParent()
    end

    
    self._effectQueue = {}

    self._iconBg = nil
end

function UIIcon:setScale(scale)
    self._iconBg:setScale(scale)
end
function UIIcon:setRotation( rotation )
    self._iconBg:setRotation( rotation )
end
function UIIcon:setVisible(visible)
    self._iconBg:setVisible(visible)
end
function UIIcon:isVisible()
    return self._iconBg:isVisible()
end
function UIIcon:setOpacity( vul )
    self._iconBg:setOpacity( vul )
end
function UIIcon:runAction(action)
    self._iconBg:runAction(action)
end
function UIIcon:stopAllActions()
    self._iconBg:stopAllActions()
end
function UIIcon:getPosition()
   self._iconBg:getPosition() 
end
function UIIcon:isSame(data)
    local flag = false

    if self._data ~= nil then


        if self._data.power == data.power 
            and self._data.typeid == data.typeid
            and self._data.num == data.num then
            flag = true
        end
        
        if rawget(self._data, "parts") ~= nil and 
            rawget(data, "parts") ~= nil then
            local parts = data.parts
            local oldparts = self._data.parts
            for key, value in pairs(parts) do
                if value ~= rawget(oldparts,key) then
                    flag = false
                    break
                end
            end
        end

        if rawget(self._data,"customNumStr") ~= nil and rawget(data,"customNumStr") ~= nil then  --有自定义数量文本，强制刷新
            local oldStr = rawget(self._data,"customNumStr")
            local newStr = rawget(data,"customNumStr")
            if type(oldStr) ~= type(newStr) then  --类型改变，要刷新
                flag = false
            elseif type(oldStr) == type(0) or type(oldStr) == "string" then
                if oldStr == newStr and self._data.power == data.power 
                    and self._data.typeid == data.typeid
                    and self._data.num == data.num then  --值没变，不刷新
                    flag = true
                end
            elseif type(oldStr) == type({}) then  --TODO 富文本暂定直接刷新
                flag = false
            end
        end
    end
    return flag
end

function UIIcon:updateData(data)
    
   local isSame = self:isSame(data)
   if isSame then
        --防止特效太早出现，重新调用一次
        self:updateIconQuality(self._data.color)
       return
   end
   
    self._data = data

    
    local power = data.power
    local typeid = data.typeid
    local num = data.num
    

    local url = ""
    local icon = 0
    local preName = nil
    local color = 1
    local name = ""
    local dec = ""
    local text = nil
    local effectframe = nil

    local info = nil
    if power == GamePowerConfig.Other then   --其他icon 将iconid传进来
        icon = typeid
        color = data.color or self._otherNumber or 1
        name = data.name or ""
        dec = data.dec or ""
        preName = "otherIcon"
    elseif power == GamePowerConfig.Product then   --主城生产图标 
        icon = typeid
        color = data.color or self._otherNumber or 1
        name = data.name
        dec = data.dec
        preName = "productIcon"
    elseif power == GamePowerConfig.Reward then   --奖励图标 
        icon = data.icon
        color = data.quality or self._otherNumber or 1
        name = data.name or ""
        dec = data.info or ""
        preName = "rewardIcon"
    else
        -- 根据power字段获取文件夹
        info = ConfigDataManager:getConfigByPowerAndID(power, typeid)
        preName = info.iconFolder
        if info == nil then
            logger:error("表中未匹配到power=%d----typeid = %d的数据！", power,typeid)
        else
--            if _G.next(info) == nil then
--                logger:error("表中未匹配到power=%d----typeid = %d的数据！", power,typeid)
--            end
            icon = info.icon
            color = info.color
            name = info.name
            dec = info.info
            text = info.text
            effectframe = info.effectframe
        end
        if power == GamePowerConfig.Item then
            icon = info.icon
            color = info.color
            name = info.name
            dec = info.info
            text = info.text
            effectframe = info.effectframe
        elseif power == GamePowerConfig.Resource then
            icon = info.icon
            color = info.quality
            name = info.name
            dec = info.info
        elseif power == GamePowerConfig.Soldier then  --TODO soldier的Icon表现方式
            icon = self:getRealModelId( info.model )
            color = info.color
            name = info.name
            dec = info.info or ""
            effectframe = info.effectframe --佣兵Icon显示特效
        elseif power == GamePowerConfig.Command then --司令部，先写死 info 空
            icon = 1
            color = 1
            name = TextWords:getTextWord(812)
            dec = ""
        elseif power == GamePowerConfig.Skill then  --info 空
            icon = info.icon
            color = 1
            name = info.name
            dec = ""
            -- print("技能icon···info.icon="..info.icon)
        elseif power == GamePowerConfig.Ordnance then   --军械
            icon = info.icon
            color = info.quality
            name = info.name
            dec = info.info
            effectframe = info.effectframe
        elseif power == GamePowerConfig.HeroTreasure then   --宝具
            icon = info.icon
            color = info.color
            name = info.name
            dec = info.desc
            effectframe = info.effectframe
        elseif power == GamePowerConfig.HeroTreasureFragment then   --宝具碎片
            icon = info.icon
            color = info.quality
            name = info.name
            dec = info.desc
            effectframe = info.effectframe
        elseif power == GamePowerConfig.OrdnanceFragment then   --军械碎片
            icon = info.icon
            color = info.quality
            name = info.name
            dec = info.desc
            effectframe = info.effectframe
        elseif power == GamePowerConfig.General then
            icon = info.icon --self:getRealModelId( info.model )
            color = info.color
            name = info.name
            dec = info.info or ""
        elseif power == GamePowerConfig.SoldierBarrack then 
            icon = self:getRealModelId( info.model )
            color = info.color
            name = info.name
            dec = info.info or ""
            effectframe = nil
            -- effectframe = info.effectframe --静态佣兵显示特效
        elseif power == GamePowerConfig.Building then
            icon = info.icon
            color = info.color
            name = info.name
            dec = info.info
        elseif power == GamePowerConfig.Collection then
            icon = info.icon
            color = info.color
            name = info.name
            dec = info.info
        elseif power == GamePowerConfig.Counsellor then  --谋士
            icon = info.icon
            color = info.color
            name = info.name
            dec = info.getinfo --来源信息
        elseif power == GamePowerConfig.Hero then
            icon = info.icon
            color = info.color
            name = info.name
            local conf = ConfigDataManager:getConfigById("HeroShowConfig",typeid)
            effectframe = conf.effectframe
            dec = conf.getinfo
        elseif power == GamePowerConfig.HeroFragment then
            dec = info.desc
            name = info.name
            color = info.color
            icon = info.icon
            local conf = ConfigDataManager:getConfigById("HeroShowConfig",typeid)
            effectframe = conf.effectframe
        else
            logger:error("--------出现未知的power值：%d-----------", power)
        end

    end

    color = color or 1  --容错
    
    self._data.name = name
    self._data.dec = dec
    self._data.color = color
    self._data.typeid = data.typeid
    self._info = info

    
    self._power = power
    self._name = name
    self._dec = dec
    self._color = color
    self._effectframe = effectframe

    self:updateIcon(icon, preName, color, num, text)
end

function UIIcon:getRealModelId(model)
    local realModelId = ConfigDataManager:getInfoFindByOneKey(
        ConfigData.ModelGroConfig,"ID",model).modelID

    return realModelId
end

------------------------------
function UIIcon:getName()  --道具名字
    return self._name
end

function UIIcon:getDec()  --道具描述信息
    return self._dec
end

function UIIcon:getInfo()  --道具配表信息
    return self.info
end

function UIIcon:getQuality()  --道具品质
    return self._color
end

------------------------

function UIIcon:updateIcon(icon, preName, color, num, text)
    if self._iconBg == nil then
        local bg = TextureManager:createImageView("images/gui/none.png")
        bg:setName("Icon")
        self._parent:addChild(bg)
        self._iconBg = bg
        
        if self._panel ~= nil then
--            local layout = ccui.Layout:create()
--            layout:setContentSize(cc.size(93,93))
--            layout:setPosition(-46,-46)
--            layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.none)
--            self._iconBg:addChild(layout)
--            ComponentUtils:addTouchEventListener(layout,self.onIconTouch, nil, self)
        end
    else
    end
    
    
    local customNumStr = rawget(self._data,"customNumStr")  --自定义数量文本，默认为nil
    if customNumStr == nil then
        self:updateIconNum(num, text ,color)
    else
        self:setCustomNumStr(customNumStr, text, color)
    end
    
    self:updateIconQuality(color)
    self:updateIconImg(preName, icon)
   
    if self._power == GamePowerConfig.Ordnance then
        self:updatePartsLv()
    end 
    
end

function UIIcon:onIconTouch(sender)
--    print("=========================")
    --TODO 弹出各种对应的信息Panel
    if self._panel == nil or self._power == GamePowerConfig.Other then
        return
    end
    self:onWatchIconDetailInfo(self._power)
end

function UIIcon:onSetOrdnanceData()
    if rawget(self._data,"parts") == nil then
        local config = ConfigDataManager:getInfoFindByOneKey("OrdnanceConfig","ID",self._data.typeid)
        self._data.parts = {}
        self._data.parts.part = config.part
        self._data.parts.type = config.type
        self._data.parts.quality = config.quality
        self._data.parts.strgthlv = 0
        self._data.parts.remoulv = 0
        self._data.parts.strength = 0
        self._data.parts.id = self._data.typeid
    end
end

function UIIcon:onWatchIconDetailInfo(power)
    --只有self._panel存在字段_enableTouch，才会弹军械/碎片的查看UI
    local enableTouch = self._panel._enableTouch
    if power == GamePowerConfig.Ordnance and enableTouch ~= nil then
        UIWatchOrdnance.new(self._panel, self._data)  --军械查看UI    
    elseif  power == GamePowerConfig.OrdnanceFragment and enableTouch ~= nil then
        UIWatchOrdnancePiece.new(self._panel, self._data)  --军械碎片查看UI
    elseif power == GamePowerConfig.Hero then--英雄查看UI
        local config = ConfigDataManager:getConfigById(ConfigData.HeroConfig, self._data.typeid)
        local isExpCar = config.type == 1

        if enableTouch ~= nil or isExpCar then
            UIIconTip.new(self._panel:getParent(), self._data, nil, self._panel)
        else
            local isHave = self._panel._isHave
            --这里特殊处理一下，有真实数据的传个dbid过来拿真实数据去显示面板
            --若是活动里面的奖励icon，就用假的英雄数据
            local dbId = rawget(self._data, "heroDbId")

            local typeid = self._data.typeid
            if dbId ~= nil then
                local heroProxy = self._panel:getProxy(GameProxys.Hero)
                local heroData = heroProxy:getInfoById(dbId)
                if heroData ~= nil then
                    typeid = heroData
                end
            end

            UIHeroInfoPanel.new(self._panel, typeid, nil, isHave)
        end
    elseif power == GamePowerConfig.HeroTreasure then--宝具
    elseif power == GamePowerConfig.HeroTreasureFragment then--宝具碎片
    elseif power == GamePowerConfig.SoldierBarrack 
        or power == GamePowerConfig.Soldier then
        local soldierProxy = self._panel:getProxy(GameProxys.Soldier)
        soldierProxy:showSoldierInfo(self._panel, self._data.typeid)
--        self._panel:showSoldierInfo(self._data.typeid)
    else
       UIIconTip.new(self._panel:getParent(), self._data, nil, self._panel)
    end
end

-------------------
function UIIcon:setPosition(x, y)
    self._iconBg:setPosition(x,y)
end

function UIIcon:updateIconNum(num, text, color)
    if num == nil then
        num = 0
    end
    if self._numTxt == nil then
        local text = ccui.Text:create()
        text:setLocalZOrder(100)
        text:setAnchorPoint(cc.p(1, 0.5))
        text:setPosition(35,-26)
        self._iconBg:addChild(text)
        self._numTxt = text
        text:setVisible(self._isShowNum)
        self._numTxt:setLocalZOrder(100)
        self._numTxt:setFontSize(16)
    end
    
    if self._isNumNotStr ~= nil then
        if type(self._isNumNotStr) == type(0) then  --如果self._isNumNotStr是数字，则显示数量
            self._numTxt:setString(num)
        elseif num <= 0 then
            self._numTxt:setString("")
        else
            self._numTxt:setString(num)
        end
    else
        local numF = StringUtils:formatNumberByK(num)
        if num <= 1 then
            numF = ""
        end
        if self._power == GamePowerConfig.OrdnanceFragment then
            local numStr = "碎"
            if num > 1 then
                numStr = "碎*"..numF
            end 
            if  self._data.typeid == OrdnancePieceType.Universal
                or self._info.type == 2 then
                numStr = numF
            end
            self._numTxt:setString(numStr)
        else
            if self._isShowNum == true then
                if text ~= nil and num <= 1 then
                    numF = text
                elseif text ~= nil then
                    numF = text .. "*" .. num
                end
                self._numTxt:setString(numF)
            end
        end

    end

    -- if self._numTxt:getString() == "" then return end

    -- 道具数量为空or道具数量为1 设置为隐藏数量的显示
    local tmpIsShowNum = self._isShowNum
    if self._numTxt:getString() == "" or self._numTxt:getString() == "1" then 
        if self._isShowNum == true then
            tmpIsShowNum = false
        end 
    end

    if self.textBg ~= nil then
        self.textBg:removeFromParent()
    end

    -- 数量背景框
    -- local url = "images/gui/Frame_prop_box_1.png" --不用区分品质
    -- local rect_table = cc.rect(11,10,2,1)   --小背景框的9宫格参数
    -- TextureManager:createScale9ImageView(url,rect_table)
    -- textBg:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    
    local url = "images/gui/Frame_prop_box_"..color..".png"  

    local rect_table = cc.rect(10,0,1,1)   --小背景框的9宫格参数
    local textBg = TextureManager:createScale9ImageView(url,rect_table)

    textBg:setLocalZOrder(80)
    textBg:setAnchorPoint(cc.p(1, 0.5))
    local bgPos = cc.p(39,-26)
    textBg:setPosition(bgPos) ---这是小背景框的位置

    local width = 0
    local numSize = self._numTxt:getContentSize() --文字根据字的多少获得的长度
    if numSize.width <= 25 then
        width = 25
        local txtWidth = bgPos.x - (width/2 - numSize.width/2) -- x描点的中心坐标
        self._numTxt:setPosition(txtWidth,bgPos.y) --这是文字的描点Y坐标位置(除了1之外的位置）
    else
        width = numSize.width + 6
        self._numTxt:setPosition(bgPos.x-2,bgPos.y)  ----这是文字的位置
    end

    local initSize = textBg:getContentSize()
    textBg:setContentSize(initSize.width * width / 25, initSize.height)
    textBg:setName("textBg")
    self._iconBg:addChild(textBg)
    textBg:setVisible(tmpIsShowNum)
    self.textBg = textBg

end

-- 设置自定义数量字符串，特殊用途，慎用
-- num支持数字/字符串/富文本
function UIIcon:setCustomNumStr(num, text, color)
    print("-- 设置自定义数量字符串")
    if self._numTxt == nil then
        local text = ccui.Text:create()
        text:setLocalZOrder(100)
        text:setAnchorPoint(cc.p(1, 0.5))
        text:setPosition(35,-26)
        self._iconBg:addChild(text)
        self._numTxt = text
        text:setVisible(self._isShowNum)
        self._numTxt:setLocalZOrder(100)
        self._numTxt:setFontSize(16)

        if type(num) == type({}) then
            if self._numTxt.richLabel == nil then
                self._numTxt.richLabel = ComponentUtils:createRichLabel("", nil, nil, 2)
                self._numTxt:addChild(self._numTxt.richLabel)
            end
        end

    end
    local numSize
    if type(num) == type({}) then
        -- print("-- 设置自定义数量字符串 00")
        self._numTxt.richLabel:setString(num)
        numSize = self._numTxt.richLabel:getContentSize()
        self._numTxt.richLabel:setPosition(0-numSize.width, 16/2)
    else
        -- print("-- 设置自定义数量字符串 11")
        self._numTxt:setString(num)
        numSize = self._numTxt:getContentSize() --文字根据字的多少获得的长度
    end
    

    -- 道具数量为空or道具数量为1 设置为隐藏数量的显示
    local tmpIsShowNum = self._isShowNum
    if type(num) == type({}) then
    elseif self._numTxt:getString() == "" or self._numTxt:getString() == "1" then 
        if self._isShowNum == true then
            tmpIsShowNum = false
        end 
    end

    local width = 0
    local bgPos = cc.p(39,-26)
    if numSize.width <= 25 then
        width = 25
        local txtWidth = bgPos.x - (width/2 - numSize.width/2) -- x描点的中心坐标
        self._numTxt:setPosition(txtWidth,bgPos.y) --这是文字的描点Y坐标位置(除了1之外的位置）
    else
        width = numSize.width + 6
        self._numTxt:setPosition(bgPos.x-2,bgPos.y)  ----这是文字的位置
    end


    if self.textBg ~= nil then
        self.textBg:removeFromParent()
    end

    -- 数量背景框    
    local url = "images/gui/Frame_prop_box_"..color..".png"  
    local rect_table = cc.rect(10,0,1,1)   --小背景框的9宫格参数
    local textBg = TextureManager:createScale9ImageView(url,rect_table)
    textBg:setLocalZOrder(80)
    textBg:setAnchorPoint(cc.p(1, 0.5))
    textBg:setPosition(bgPos) ---这是小背景框的位置

    local initSize = textBg:getContentSize()
    textBg:setContentSize(initSize.width * width / 25, initSize.height)
    textBg:setName("textBg")
    self._iconBg:addChild(textBg)
    textBg:setVisible(tmpIsShowNum)
    self.textBg = textBg

end

function UIIcon:updateIconImg(preName, icon)
    if self._parent.model ~= nil then
        self._parent.model:finalize()
        self._parent.model = nil
    end
--    --创建出模型
--    if self._power == GamePowerConfig.Soldier then --or self._power == GamePowerConfig.General
--        self:createModel(icon)
--        self._iconBg:setVisible(false)
--        -----today
--        local layout = ccui.Layout:create()
--        layout:setContentSize(cc.size(93,93))
--        layout:setPosition(-46,-46)
--        layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.none)
--        self._parent:addChild(layout)
--        ComponentUtils:addTouchEventListener(layout,self.onIconTouch, nil, self)
--        -----today
--        return
--    end

    self._iconBg:setVisible(true)
    local url = string.format("images/%s/%s.png",preName, icon) --icon
    if self._iconImg == nil then
        self._iconImg = TextureManager:createImageView(url)
        self._iconImg:setLocalZOrder(2)
        self._iconBg:addChild(self._iconImg)
        self._iconImg:setName("iconImg" .. icon)
        -- self._iconImg:setPositionY(2)  --由于道具框有阴影，将icon图片上移2个像素
        
        ComponentUtils:addTouchEventListener(self._iconImg,self.onIconTouch, nil, self)
    else
        TextureManager:updateImageView( self._iconImg,url)
    end
    
    if self._power == GamePowerConfig.SoldierBarrack then
        TextureManager:updateImageView( self._iconBg,"images/gui/none.png")
    end

    if self._isMainScene ~= nil and self._isMainScene == true then
        TextureManager:updateImageView( self._iconBg,"images/gui/none.png")
    end
end

function UIIcon:updateIsShowName(data)
    -- body
    self._isShowName = data
end

function UIIcon:setTouchEnabled(enabled)
    self._iconImg:setTouchEnabled(enabled)
end

function UIIcon:isShowName(visible)
    self._isShowName = visible
    if self._isShowName == true then
        if self._nameTxt == nil then
            local text = ccui.Text:create()
            text:setLocalZOrder(100)
            text:setAnchorPoint(cc.p(0.5, 0.5))
            self._iconBg:addChild(text)
            self._nameTxt = text
            self._nameTxt:setFontSize(15)
            self._nameTxt:setPosition(0, -52)
        end
        self._nameTxt:setVisible(true)
        self._nameTxt:setString(self._name)
        local color = ColorUtils:getColorByQuality(self._color)
        self._nameTxt:setColor(color)
    else
        if self._nameTxt ~= nil then
            self._nameTxt:setVisible(false)
        end
    end
end

-- 获取icon名字的节点(用于自定义名字属性)
function UIIcon:getNameChild(  )
    -- body
    return self._nameTxt
end
-- 设置数量的颜色
function UIIcon:setNumColor(color)
    if self._numTxt then
        self._numTxt:setColor(color)
    end
end

-- 设置图标的框体、品质图，品质特效
function UIIcon:updateIconQuality(quality)

    for k,v in pairs(self._effectQueue) do
        v:setVisible(false)
    end

    -- local url = "images/gui/Frame_prop_" .. quality .. ".png"
    local url = "images/gui/Frame_prop_1.png"
    if self._qualityImg == nil then
        self._qualityImg = TextureManager:createImageView(url)
        self._qualityImg:setLocalZOrder(1)
        self._iconBg:addChild(self._qualityImg)
    else
        TextureManager:updateImageView( self._qualityImg,url)
    end

    ---ceshi
    local urlTure = "images/gui/Frame_prop_aperture_"..quality..".png"
    if self._qualityTure == nil then
        self._qualityTure = TextureManager:createImageView(urlTure)
        self._qualityTure:setLocalZOrder(3)
        self._iconBg:addChild(self._qualityTure)
        -- self._qualityTure:setPositionY(2)  --道具品质背景坐标偏移
    else
        self._qualityTure:setVisible(true)
        TextureManager:updateImageView( self._qualityTure,urlTure)
    end
    ---ceshi
    
    -- if self._movieChip ~= nil then
    --     if self._movieChip.frameName ~= self._effectframe then
    --         self._movieChip:finalize()
    --         self._movieChip = nil
    --     end
    -- end

    if self._effectframe ~= nil then
        -- print("~~~~~~~~self._effectframe~~~~~~~~~~~", self._movieChip)
    end
    
    self:isShowName(self._isShowName)

    for k,v in pairs(self._effectQueue) do
        v:setVisible(false)
    end

    local function addEffect()
        for k,v in pairs(self._effectQueue) do
            v:setVisible(v:getName() == self._effectframe)
        end
        local frameName = self._effectframe
        if frameName ~= nil then
            local movieChip = self._effectQueue[frameName]
            if movieChip ~= nil then
                local timee = os.clock()
                movieChip:setVisible(true)
                print("使用缓存的icon，耗时-->",os.clock() - timee)
            else
                local timee = os.clock()
                movieChip = UICCBLayer.new(frameName, self._iconBg)
                self._effectQueue[frameName] = movieChip
                --print("创建新的icon，耗时-->",os.clock() - timee)
            end
            movieChip:setScale(1.1)
            movieChip:setLocalZOrder(4)
            movieChip:setPosition(33,46)
        end
    end
    -- 防止奖励图标特效显示过早
    if self._showEffectDalay <= 0 then
        addEffect()
    else
        TimerManager:addOnce(self._showEffectDalay, addEffect, self)
    end
    
    local color = ColorUtils:getColorByQuality(quality)
    self._numTxt:setColor(color)
    
    if self._power == GamePowerConfig.SoldierBarrack then
        self._qualityTure:setVisible(false)
        TextureManager:updateImageView( self._qualityImg,"images/gui/none.png")
    end
    if self._isMainScene ~= nil and self._isMainScene == true then
        self._qualityTure:setVisible(false)
        TextureManager:updateImageView( self._qualityImg,"images/gui/none.png")
    end
end

function UIIcon:createModel(modelId)
    local model = SpineModel.new(modelId, self._parent)
    model:playAnimation("wait", true)
    self._parent.model = model
    
    model:setPosition(0, -20)
end
--更新配件强化等级和改造等级
function UIIcon:updatePartsLv()
    local parts = rawget(self._data, "parts")
    if parts ~= nil then
        local iconSize = self._iconBg:getContentSize()
--        print("iconSize====",iconSize.width,iconSize.height)
        if self._intenLvTxt == nil then
            local text = ccui.Text:create() 
            text:setLocalZOrder(100)
            text:setPosition(20,-25)
            text:setAnchorPoint(cc.p(1, 0.5)) -- 锚点统一：1，0.5
            self._iconBg:addChild(text)
            self._intenLvTxt = text
            
        end
        
        if self._remLvTxt == nil then --color
           --[[ local layerColor = ccui.LayerColor:create(cc.c4b(255,255,0,0),20,20)
            layerColor:setLocalZOrder(100)
            layerColor:setPosition(0,iconSize.height-20)
            self._iconBg:addChild(layerColor)
            --]]
            local text = ccui.Text:create()
            text:setLocalZOrder(100)
            text:setPosition(iconSize.width-20,25)
            self._iconBg:addChild(text)
            self._remLvTxt = text
            
        end
        
        self._intenLvTxt:setString("Lv."..parts.strgthlv)
        self._remLvTxt:setString(parts.remoulv)
        -- 显示小框背景
        self.textBg:setVisible(true)
        
        -- 调用小框背景重设大小，（原因：和self._numTxt 用的不是同一个node）
        self:setTextBgContentSize(self.textBg, self._intenLvTxt)
    
    end 
end 

------
-- 设置小背景框的大小
function UIIcon:setTextBgContentSize(textBg, strTxt)
    local bgPos = cc.p(39,-26) -- 原始坐标
    local width = 0
    local numSize = strTxt:getContentSize() --文字根据字的多少获得的长度
    if numSize.width <= 25 then
        width = 25
        local txtWidth = bgPos.x - (width/2 - numSize.width/2) -- x描点的中心坐标
        strTxt:setPosition(txtWidth,bgPos.y) --这是文字的描点Y坐标位置(除了1之外的位置）
    else
        width = numSize.width + 6
        strTxt:setPosition(bgPos.x-2,bgPos.y)  ----这是文字的位置
    end
    local initSize = textBg:getContentSize()
    textBg:setContentSize(initSize.width * width / 25, initSize.height)

end

--------------------------------------------------------------
UIIconTip = class("UIIconTip")
function UIIconTip:ctor(parent, data, isShare, panel)
    local uiSkin = UISkin.new("UIIconTip")
    uiSkin:setParent(parent)
    self._uiSkin = uiSkin
    self._panel = panel
    
    self:renderData(data, isShare)
    self:registerEvents()
    self._uiSkin:setLocalZOrder(100)    
end

function UIIconTip:finalize()
    if self._uiSharePanel ~= nil then
        self._uiSharePanel:finalize()
        self._uiSharePanel = nil
    end

    self._uiSkin:finalize()
end

function UIIconTip:registerEvents()
    ComponentUtils:addTouchEventListener(self._uiSkin.root, self.onCloseTouch,nil,self)
end

function UIIconTip:onCloseTouch(sender)
    TimerManager:addOnce(1,self.finalize,self)
end

function UIIconTip:renderData(data, isShare)
    local iconContainer = self:getChildByName("mainPanel/iconContainer")
    local nameTxt = self:getChildByName("mainPanel/nameTxt")
    local numTxt = self:getChildByName("mainPanel/numTxt")
    local infoTxt = self:getChildByName("mainPanel/infoTxt")
    local otherLabel = self:getChildByName("mainPanel/OtherLab")
    otherLabel:setString("")

    if rawget(data, "otherInfo") then
        otherLabel:setString(data.otherInfo)
    end
    if rawget(data, "otherColor") then        
        otherLabel:setColor(data.otherColor)
    end
    
    if rawget(data,"num") then
        numTxt:setString(string.format(TextWords:getTextWord(103),data.num))
        -- numTxt:setVisible(true)
    else
        numTxt:setString("数量：未知")
        -- numTxt:setVisible(false)
    end

    nameTxt:setString(data.name)
    infoTxt:setVisible(type(data.dec) == "string")
    if type(data.dec) == "string" then
        infoTxt:setString(data.dec)
    elseif type(data.dec) == "table" then
        if infoTxt.richLabel == nil then
            infoTxt.richLabel = ComponentUtils:createRichLabel("", nil, nil, 2)
            infoTxt.richLabel:setPosition(cc.p(infoTxt:getPosition()))
            infoTxt:getParent():addChild(infoTxt.richLabel)
        end
        infoTxt.richLabel:setString(data.dec)
    end
    
    local power = rawget(data, "power")
    local isItem = type(power) == "number" and power == GamePowerConfig.Item
    local shareBtn = self:getChildByName("mainPanel/shareBtn")
    shareBtn:setVisible( isItem and isShare == nil)
    shareBtn.data = data
    ComponentUtils:addTouchEventListener(shareBtn, self.onShare, nil, self)

    --物品跳转获取----fwx-------------
    local jumpBtn = self:getChildByName("mainPanel/jumpBtn")
    jumpBtn:setVisible( false )
    if isItem then
        local typeid = rawget(data, "typeid")
        local itemconfig = ConfigDataManager:getConfigById(ConfigData.ItemConfig, typeid)
        if itemconfig.jumpModule and itemconfig.jumpPannel then
            jumpBtn:setVisible(true)
            ComponentUtils:addTouchEventListener(jumpBtn, function()
                ModuleJumpManager:jump( itemconfig.jumpModule, itemconfig.jumpPannel )
            end)
        end
    end
    -----------------------------------
    -- logger:info("UIIconTip> %s %s %d", data.name, data.dec, self._power)

    nameTxt:setColor(ColorUtils:getColorByQuality(data.color))
    
    UIIcon.new(iconContainer, data)
    -- logger:error("点击物品 power:"..rawget(data,"power").." typeid:"..rawget(data,"typeid"))
end

function UIIconTip:getChildByName(name)
    return self._uiSkin:getChildByName(name)
end

function UIIconTip:onShare(sender)
    if self._uiSharePanel == nil then
        self._uiSharePanel = UISharePanel.new(sender, self._panel)
    end
        
    local itemData = sender.data

    local data = {}
    data.type = ChatShareType.PROP_TYPE
    data.typeId = rawget(itemData, "typeid")
    if type(data.typeId) ~= "number" then
        return
    end
    self._uiSharePanel:showPanel(sender, data)
end

















