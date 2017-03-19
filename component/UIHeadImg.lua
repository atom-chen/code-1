-- /**
--  * @Author:      fzw
--  * @DateTime:    2016-02-27 15:05:50
--  * @Description: 头像通用控件
--  */

-- data表结构：
    -- data = {}
    -- data.icon = 100              --头像ID
    -- data.pendant = 100           --挂件ID
    -- data.preName1 = "headIcon"   --图片资源文件夹名称（头像headIcon）
    -- data.preName2 = nil          --图片资源文件夹名称（挂件headPendant）
    -- data.isCreatPendant = false  --是否创建挂件，默认不创建（例如：主城无挂件false，个人信息有挂件true）
    -- data.isCreatButton = false   --是否创建头像按钮，默认不创建（true=创建，false=不创建）
    -- data.isSettingPanel = false  --是否属于设置头像，默认false（true=是，false=不是）
    -- data.isCreatCover = true    --是否创建相框遮挡，默认创建（true=创建，false=不创建）


UIHeadImg = class("UIHeadImg")
UIHeadImg.HEAD_CHAT_ICON_PATH = "images/headChatIcon/%s.png"
UIHeadImg.HEAD_SQUARE_FRAME = "images/gui/Frame_prop_1.png"

function UIHeadImg:ctor(parent, data, panel)
    self._parent = parent
    self._panel = panel 
    
    self._noticeHead = 9999 --系统公告头像
    self._nullHead = 999 --挂件设置界面头像
    
    self:updateData(data)
end

function UIHeadImg:finalize()
    if self._pendantImg ~= nil then
        self._pendantImg:stopAllActions()
        self._pendantImg:setScale(1)
    end
    if self._headBg ~= nil then
        self._headBg:removeAllChildren()
        self._headBg:removeFromParent()
    end

    self._headBg = nil
end

-- 做一下数据检测，数据没变化不执行渲染
function UIHeadImg:isSame(data)
    local flag = false

    if self._data ~= nil and data ~= nil then

        local o_icon = rawget(self._data,"icon")
        local o_pendant = rawget(self._data,"pendant")
        local o_preName1 = rawget(self._data,"preName1")
        local o_preName2 = rawget(self._data,"preName2")
        local o_isCreatPendant = rawget(self._data,"isCreatPendant")
        local o_isCreatButton = rawget(self._data,"isCreatButton")
        local o_isSettingPanel = rawget(self._data,"isSettingPanel")
        local o_isCreatCover = rawget(self._data,"isCreatCover")
        local o_chat = rawget(self._data,"chat")

        local n_icon = rawget(data,"icon")
        local n_pendant = rawget(data,"pendant")
        local n_preName1 = rawget(data,"preName1")
        local n_preName2 = rawget(data,"preName2")
        local n_isCreatPendant = rawget(data,"isCreatPendant")
        local n_isCreatButton = rawget(data,"isCreatButton")
        local n_isSettingPanel = rawget(data,"isSettingPanel")
        local n_isCreatCover = rawget(data,"isCreatCover")
        local n_chat = rawget(data,"chat")

    
        if o_icon == n_icon
            and o_pendant == n_pendant
            and o_preName1 == n_preName1
            and o_preName2 == n_preName2
            and o_isCreatPendant == n_isCreatPendant
            and o_isCreatButton == n_isCreatButton
            and o_isSettingPanel == n_isSettingPanel
            and o_isCreatCover == n_isCreatCover
            and o_chat == n_chat
            then
            flag = true
        end


    end
    return flag
end

-- 更新头像显示
function UIHeadImg:updateData(data)
    local isSame = self:isSame(data)
    if isSame == true then
        -- print("...数据没有变化，不刷新头像")
        return
    end
    self._data = data


    local initHead = 101
    local initPendant = nil  --
    local initPreName1 = "headIcon"
    local initPreName2 = "headPendant"
    local initCreateCover = true
        
    local icon = data.icon
    local pendant = data.pendant
    
    if icon == self._lastIcon and pendant == self._lastPendant then
        return
    end

    if self._pendantImg then --兼容如果之前有挂件，现在没有挂件的情况
        self._pendantImg:setVisible(false)
    end
    
    local preName1 = data.preName1
    local preName2 = data.preName2
    local isCreatPendant = data.isCreatPendant
    local isCreatButton = data.isCreatButton
    local isSettingPanel = data.isSettingPanel
    local isCreatCover = data.isCreatCover

    -- 头像容错
    if icon == nil then
        icon = initHead
        logger:error("-- icon == nil >>> 显示头像容错")
    elseif icon == 1 or icon == self._noticeHead then --系统公告头像
        icon = self._noticeHead
    elseif icon == self._nullHead then 
       -- icon = 0
       -- print("..................卧槽. icon = 0 ")
    else
        local conf = ConfigDataManager:getConfigData(ConfigData.HeadPortraitConfig)
        local isHave = false
        for k,v in pairs(conf) do
            if v.id == icon then
                isHave = true
                break
            end
        end
        if isHave == false then
            icon = initHead
            logger:error("-- isHave == nil >>> 显示头像容错")
        end
    end

    -- 挂件容错
    if pendant == nil then
        pendant = initPendant
        isCreatPendant = false
    else
        local conf = ConfigDataManager:getConfigData(ConfigData.PendantConfig)
        local isHave = false
        for k,v in pairs(conf) do
            if v.id == pendant then
                isHave = true
                pendant = v.icon
                break
            end
        end
        if isHave == false then
            pendant = initPendant
        end
        isCreatPendant = isHave
    end


    if rawget(data, "isChat") == nil and isCreatPendant then
        isCreatPendant = false
    end


    if preName1 == nil then
        preName1 = initPreName1
    end

    if preName2 == nil then
        preName2 = initPreName2
    end

    if isCreatCover == nil then
        isCreatCover = initCreateCover
    end

    if icon == nil then
        return
    else
        if icon == self._nullHead then 
            self:updateOnlyPendant(icon, pendant, preName1, preName2, isCreatPendant, isCreatButton, isSettingPanel, isCreatCover)
        else
            self:updateHead(icon, pendant, preName1, preName2, isCreatPendant, isCreatButton, isSettingPanel, isCreatCover)
        end
        
    end
    
    self._lastIcon = icon
    self._lastPendant = pendant

end

------------------------------
-- 默认设置头像背景框为空图
function UIHeadImg:updateHead(icon, pendant, preName1, preName2, isCreatPendant, isCreatButton, isSettingPanel, isCreatCover)
    -- 头像框    
    if self._headBg == nil then
        local bg = TextureManager:createImageView("images/common/dot.png")
        self._parent:addChild(bg)
        self._headBg = bg
        local size = self._parent:getContentSize()
        bg:setPosition(size.width/2, size.height/2)
    end
    
    self:updateHeadImg(icon, preName1)
    
    -- 按钮
    if isCreatButton == true then
        -- 不要相框
        -- print("....................................... -- 不要相框")
        self:createButton()
    elseif isCreatCover then
        -- print("....................................... -- 没按钮 则创建相框")
        -- 没按钮 则创建相框
        if self._headCover == nil then
            self:addHeadCoverImg(isSettingPanel)
        end
    end

    
    -- start 当前版本暂时屏蔽挂件----------------------------------------------------------
    -- 挂件
    if isCreatPendant == true and pendant then
         self:updateHeadPendant(pendant, preName2)
    end
    -- end   当前版本暂时屏蔽挂件----------------------------------------------------------

end
-- 兼容单独展示挂件
function UIHeadImg:updateOnlyPendant(icon, pendant, preName1, preName2, isCreatPendant, isCreatButton, isSettingPanel, isCreatCover)
    -- 头像框    
    if self._headBg == nil then
        local bg = TextureManager:createImageView("images/common/dot.png")
        self._parent:addChild(bg)
        self._headBg = bg
        local size = self._parent:getContentSize()
        bg:setPosition(size.width/2, size.height/2)
    end
    

    self._headBg:setVisible(true)
    -- local url = "images/headIcon/000.png"
    local url = string.format("images/headIcon/%d.png",icon)
    if self._iconImg == nil then
        self._iconImg = TextureManager:createImageView(url)
        self._headBg:addChild(self._iconImg)

    else
        TextureManager:updateImageView( self._iconImg,url)
    end
    

        -- 按钮
    if isCreatButton == true then
        -- 不要相框
        self:createButton()
    elseif isCreatCover then
        -- 没按钮 则创建相框
        if self._headCover == nil then
            self:addHeadCoverImg(isSettingPanel)
        end
    end
    -- start 当前版本暂时屏蔽挂件----------------------------------------------------------
    -- 挂件
    if isCreatPendant == true and pendant then
         self:updateHeadPendant(pendant, "headPendant")
    end
    -- end   当前版本暂时屏蔽挂件----------------------------------------------------------

end

-- 增加头像相框覆盖图片
function UIHeadImg:addHeadCoverImg(isSettingPanel)
    -- body
    local url = "images/gui/Frame_head.png"
    if isSettingPanel then
        url = "images/setting/Bg_circletool.png"
    end

    local bg = TextureManager:createImageView(url)
    self._headBg:addChild(bg)
    self._headCover = bg
end

-- 创建头像
function UIHeadImg:updateHeadImg(icon,preName)
    -- if icon == self._nullHead then
    --     icon = "000.png"
    -- else
    --     icon = icon..".png"
    -- end
   
    self._headBg:setVisible(true)
    -- local url = string.format("images/%s/%s",preName, icon)
    local url = string.format("images/%s/%s.png",preName, icon)
    if self._iconImg == nil then
        self._iconImg = TextureManager:createImageView(url)
        self._headBg:addChild(self._iconImg)
        self._iconImg:setPositionY(-1)

    else
        TextureManager:updateImageView( self._iconImg,url)
    end
end

-- 创建挂件
function UIHeadImg:updateHeadPendant(pendant,preName)
    local config = ConfigDataManager:getConfigById(ConfigData.PendantConfig, pendant)
    if config == nil then
        pendant = 101
    else
        pendant = config.icon
    end
    local pendantStr  = pendant..".png"
    self._iconImg:setVisible(true)
    local url = string.format("images/%s/%s",preName, pendantStr)




    if self._pendantImg == nil then
        self._pendantImg = TextureManager:createImageView(url)
        self._headBg:addChild(self._pendantImg)

        local size2 = self._pendantImg:getContentSize()
        self._pendantImg:setPositionY(size2.height)
        self._pendantImg:setLocalZOrder(10)
        if config then
          local offsetTable = StringUtils:jsonDecode(config.movexy)
          self._pendantImg:setPositionY(size2.height+offsetTable[2])
          self._pendantImg:setPositionX(offsetTable[1])
        end

    else
        self._pendantImg:setVisible(true)
        TextureManager:updateImageView( self._pendantImg,url)
    end

    
  
end

-------------------------------------------------------------------------------
-- 创建VIP等级显示
--[[
传入参数vip等级，等级为0不显示
]]
function UIHeadImg:updateVIPLevel(num)
    print("-- 创建VIP等级显示 ",num)
    local function updateNum(num)
        if self._vipBg then
            self._vipBg:removeFromParent()
            self._vipBg = nil
        end
        if num == nil or num <= 0 then
            if self._vipImg then
                self._vipImg:removeFromParent()
                self._vipImg = nil
            end
            if self._vipNumTxt then
                self._vipNumTxt:removeFromParent()
                self._vipNumTxt = nil
            end
            return
        end

        local dstY = -42  --VIP的Y坐标
        if self._vipNumTxt == nil then
            -- V图片
            local vipImg = TextureManager:createImageView("images/chat/V.png")
            vipImg:setLocalZOrder(1000)
            vipImg:setAnchorPoint(cc.p(0, 0))
            vipImg:setPosition(-35,dstY)
            self._headBg:addChild(vipImg)
            self._vipImg = vipImg

            -- vip等级数字标签
            local text = ccui.TextAtlas:create()
            text:setProperty("1234567890", "ui/images/fonts/VIP123456789.png", 14, 23, "0")
            text:setLocalZOrder(1000)
            text:setAnchorPoint(cc.p(0, 0))
            text:setPosition(-35+self._vipImg:getContentSize().width,dstY)
            self._headBg:addChild(text)
            self._vipNumTxt = text
        end

        self._vipNumTxt:setString(num)

        -- 数量背景框        
        local url = "images/gui/Frame_prop_box_1.png"  
        local rect_table = cc.rect(10,0,1,1)   --小背景框的9宫格参数
        local vipBg = TextureManager:createScale9ImageView(url,rect_table)

        vipBg:setLocalZOrder(800)
        vipBg:setAnchorPoint(cc.p(0, 0))
        local bgPos = cc.p(-39,dstY)
        vipBg:setPosition(bgPos) ---这是小背景框的位置

        local vipImgWidth = self._vipImg:getContentSize().width
        local vipNumWidth = self._vipNumTxt:getContentSize().width
        local totalWidth = vipNumWidth + vipImgWidth
        bgPos.x = bgPos.x + vipImgWidth + 4
        totalWidth = totalWidth + 6

        self._vipNumTxt:setPosition(bgPos.x, bgPos.y)  ----这是vip等级数字标签的位置

        local initSize = vipBg:getContentSize()
        vipBg:setContentSize(initSize.width * totalWidth / 25, initSize.height)
        vipBg:setName("vipBg")
        self._headBg:addChild(vipBg)
        self._vipBg = vipBg
    end
    
    updateNum(num)

end
-------------------------------------------------------------------------------

-- 单独对头像的图片缩放
function UIHeadImg:setHeadScale(float)
    self._iconImg:setScale(float)
end

-- 整个头像控件缩放
function UIHeadImg:setScale(float)
    self._headBg:setScale(float)
end

function UIHeadImg:getNode()
    return self._headBg
end


-------------------------------------------------------------------------------

function UIHeadImg:createButton()
    local url = "images/gui/Frame_head.png"     --normal
    local url2 = "images/gui/Frame_head2.png"   --pressed

    if self._button == nil then
        -- print("···神秘感...UIHeadImg:createButton")

        self._button = ccui.Button:create()
        self._headBg:addChild(self._button)

        local plist = TextureManager:getUIPlist(url)
        cc.SpriteFrameCache:getInstance():addSpriteFrames(plist)
        local plist2 = TextureManager:getUIPlist(url2)
        cc.SpriteFrameCache:getInstance():addSpriteFrames(plist2)

        self._button:loadTextures(url, url2, "", 1)
    end

end

-- 获取头像按钮 在外部的panel里添加触摸事件
function UIHeadImg:getButton()
    return self._button 
end

-- 获取头像Icon
function UIHeadImg:getHeadIcon()
    return self._iconImg
end

-- 获取头像路径
function UIHeadImg:getHeadIconPath()
    return UIHeadImg.HEAD_CHAT_ICON_PATH 
end


------
-- 设置方形头像
-- @param  iconId [int] 头像id
function UIHeadImg:setHeadSquare(iconId)
    local iconId = iconId
    self._iconImg:setLocalZOrder(1)
    -- 专用方形头像icon
    local headUrl = string.format(self:getHeadIconPath(), iconId) 
    TextureManager:updateImageView( self._iconImg,headUrl)
    if self:getButton() == nil then
    -- 如果没按钮只换底图
        TextureManager:updateImageView(self._headCover, UIHeadImg.HEAD_SQUARE_FRAME )

    else
    -- 有按钮换按钮材质
        self._button:loadTextures(UIHeadImg.HEAD_SQUARE_FRAME, UIHeadImg.HEAD_SQUARE_FRAME, "", 1)
    end
end

function UIHeadImg:runPendantAction()
    if self._pendantImg ~= nil then
        local scaleTo1 = cc.ScaleTo:create(0.4, 1.1)
        local scaleTo2 = cc.ScaleTo:create(0.4, 1)
        local seq = cc.Sequence:create(scaleTo1, scaleTo2)
        local action = cc.RepeatForever:create(seq)
        self._pendantImg:runAction(action)
    end
end