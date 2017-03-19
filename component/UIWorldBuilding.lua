--世界地图上的建筑类
UIWorldBuilding = class("UIWorldBuilding", function ()
    return UIMapNodeExtend.extend(cc.Node:create())
end)
UIWorldBuilding.__index = UIWorldBuilding

--worldTileInfo 世界格子信息 见M8
function UIWorldBuilding:ctor(worldTileInfo, mapPanel)
    self.worldTileInfo = worldTileInfo
    
    self._tileType = worldTileInfo.tileType
    self._mapPanel = mapPanel
    self:renderTile(worldTileInfo)

    self._getContentSize = self.getContentSize

    local function onClickEvent(obj, value)
        if value == true then  --点击自己的建筑，不处理了
            return
        end
        self:onClickEvent()
    end
    self.touchCallback = onClickEvent
end

function UIWorldBuilding:finalize()
    if self._protectUI ~= nil then
        self._protectUI:finalize()
        self._protectUI = nil
    end
    if self._buildEffect ~= nil then
        self._buildEffect:finalize()
        self._buildEffect = nil
    end

    if self._moveClip ~= nil then
        self._moveClip:finalize()
        self._moveClip = nil
    end
    if self._banditBg ~= nil then
        self._banditBg:finalize()
        self._banditBg = nil
    end
    if self._rebelsAnima ~= nil then
        self._rebelsAnima:finalize()
        self._rebelsAnima = nil
    end
end

function UIWorldBuilding:getWorldPosition()
    local size = self:getContentSize()
    local scale = self:getScale()
    local pos = self:getParent():convertToWorldSpace(cc.p(self:getPosition()))
    return pos
--    return cc.p(pos.x  - size.width * scale, pos.y - size.height * scale)
end

--强制设置描点
function UIWorldBuilding:getAnchorPoint()
    return cc.p(0.5, 0.5)
end

--function UIWorldBuilding:getContentSize()
--    return cc.size(220, 220)
--    -- local size = self._getContentSize(self)
--    -- if self._banditDungeon ~= nil then  --剿匪副本，特殊获取
--    --     size = cc.size(size.width, size.height)
--    -- end
--    -- return size
--end

function UIWorldBuilding:onExit()
    if self._banditDungeon ~= nil then
        TimerManager:remove(self.updateDungeonRestTime, self)
    end
    self._countDownTxt = nil
    self._banditDungeon = nil

    self._rebelsTileInfo = nil
end

function UIWorldBuilding:getBanditDungeonInfo()
    return self._banditDungeon
end

function UIWorldBuilding:renderTile(worldTileInfo)
    local n = worldTileInfo.x
    local m = worldTileInfo.y

    -- print("...创建 tileType,x,y",worldTileInfo.tileType,n,m)

    local banditDungeonProxy = self._mapPanel:getProxy(GameProxys.BanditDungeon)
    local banditDungeon = banditDungeonProxy:getBanditDungeon(n, m)
   
    if banditDungeon ~= nil then
        logger:info("~~~~~~~~~~~~~~~~~~有剿匪副本了~~~~~~~~~~~~~~~x:%d~~~~~y:%d~~~~~~~", n, m)
        self._banditDungeon = banditDungeon
        self:addBanditDungeon(banditDungeon)  -- 需要有显示规则

        local x, y =banditDungeonProxy:getOneBanditPosition()
        if x == n and y == m then
            self._mapPanel["banditDungeon"] = self
        end
        
        return  --优先看到
    end

    local roleProxy = self._mapPanel:getProxy(GameProxys.Role)
    local x, y = roleProxy:getWorldTilePos()
    if x == n and y == m then
        self._mapPanel["selfBuilding"] = self --自己的建筑
    end

    if worldTileInfo.tileType == WorldTileType.Empty then  --空地
        local resId = math.fmod(n*99 + m * 77, 6) + 1
        if n < 0 or n > 599 or m < 0 or m > 599 then
            resId = 99
        end

        if resId < 8  then
            local url = string.format("images/map/empty%d.png", resId)
            -- logger:info("空格url=%s resid=%d",url,resId)
            local sprite = TextureManager:createSprite(url)
            self:addChild(sprite)
        end

    elseif worldTileInfo.tileType == WorldTileType.Resource then  --资源点
        local resInfo = rawget(worldTileInfo,"resInfo")
        if resInfo == nil then
            logger:error("...资源点信息为空 tileType,x,y=%d %d %d",worldTileInfo.tileType,n,m)
            return
        end
        local resType = resInfo.restype
        local resLv = resInfo.level
        local resPointId = resInfo.resPointId
        local pointInfo = ConfigDataManager:getConfigById(ConfigData.ResourcePointConfig, resPointId)
        local url = nil
        if pointInfo then
            url = string.format("images/map/res%d.png",pointInfo.icon)
        else
            url = string.format("images/map/res%d.png",resType)
        end
        -- logger:info("create new 资源点 url = %s resType=%d reslv=%d n=%d,m=%d", url,resType,resLv,n,m)

        local sprite = TextureManager:createSprite(url)
        self:addChild(sprite)
        
        if resType and resLv >= 30 then
            if self._moveClip == nil then
                local conf = GlobalConfig.worldMapEffects[resType]
                if conf then
                    local ccbLayer = UICCBLayer.new(conf.effectName, sprite)        
                    self._moveClip = ccbLayer
                    local size = sprite:getContentSize()
                    ccbLayer:setPosition(size.width/2,size.height/2)
                    -- ccbLayer:setPosition(conf.pos)
                end
            end    
        end

        self:addResourceTxt(resLv,0, worldTileInfo)

    elseif worldTileInfo.tileType == WorldTileType.Building then  --玩家基地
        local buildIcon = worldTileInfo.buildingInfo.buildIcon
        local url = string.format("images/map/building%d.png", buildIcon) 
        local sprite = TextureManager:createSprite(url)
        self:addChild(sprite)
        if buildIcon == 51 then
            if self._buildEffect == nil then
                self._buildEffect = UICCBLayer.new("rgb-feixu", sprite)        
                local size = sprite:getContentSize()
                self._buildEffect:setPosition(size.width/2,size.height/2)
            end
        end

        self:addBuildingTxt(worldTileInfo)

    elseif worldTileInfo.tileType == WorldTileType.Rebels then  --叛军
        --叛军
        self._rebelsTileInfo = self.worldTileInfo
        self:renderRebels()              
    end
end

-- 资源点建筑信息
function UIWorldBuilding:addResourceTxt(lv, dx, worldTileInfo)
    local dy = GlobalConfig.WorldResTitlePos.y
    local url = "images/map/Bg_resLvBg.png"
    local bg = TextureManager:createSprite(url)
    self:addChild(bg)
    bg:setPositionY(dy)
    
    local txt = ccui.Text:create()
    txt:setFontSize(14)
    txt:setString(lv)
    self:addChild(txt)
    txt:setPositionY(dy)
    
    self._resTxtBg = bg
    self._resTxt = txt

    local roleProxy = self._mapPanel:getProxy(GameProxys.Role)
    local selfLegionName = roleProxy:getLegionName()
    
    --有军团
    if worldTileInfo.legionName ~= "" and selfLegionName == worldTileInfo.legionName then
        local bgSize = bg:getContentSize()
        local url = "images/common/legion.png"
        local legionBg = TextureManager:createSprite(url)
        legionBg:setName("legionBg")
        self:addChild(legionBg)
        legionBg:setPosition(-bgSize.width / 2 - 70 , dy)
        self._legionBg = legionBg
    else
        local legionBg = self:getChildByName("legionBg")
        if legionBg ~= nil then
            legionBg:removeFromParent()
            self._legionBg = nil
        end
    end
end

-- 资源点标题缩放
function UIWorldBuilding:setResTxtScale(scale)
    -- body
    if self._resTxtBg ~= nil and self._resTxt ~= nil then
        self._resTxtBg:setScale(scale)
        -- self._resTxt:setScale(scale)

        self._resTxt:setFontSize(14 * scale)
    end
    if self._legionBg ~= nil then
        self._legionBg:setScale(scale)
    end

end

-- 玩家基地标题缩放
function UIWorldBuilding:setBuildTxtScale(scale)
    -- body
    if self._buildTxtBg ~= nil and self._buildLevelTxt ~= nil and self._buildNameTxt ~= nil then
        self._buildTxtBg:setScale(scale)
        -- self._buildLevelTxt:setScale(scale)
        -- self._buildNameTxt:setScale(scale)

        self._buildLevelTxt:setFontSize(14 * scale)

        self._buildNameTxt:setFontSize(14 * scale)

        local nameLen = StringUtils:separate(self._buildNameTxt:getString() or " ")
        local bgSize = self._buildTxtBg:getContentSize()
        local size = self._buildNameTxt:getContentSize()
        --名字太长
        if size.width > bgSize.width - 30 and table.size(nameLen) == 10 then
            self._buildNameTxt:setFontSize(13)
        end
    end
    if self._buildLegionBg ~= nil then
        self._buildLegionBg:setScale(scale)
    end

    if self._banditPanel ~= nil then
        self._banditPanel:setScale(scale)

        self._banditName:setScale(1 / scale)
        self._banditName:setFontSize(14 * scale)
    end

    if self._rebelsPanel ~= nil then
        self._rebelsPanel:setScale(scale)
        self._rebelsNameTxt:setScale(1 / scale)
        self._rebelsNameTxt:setFontSize(14 * scale)
    end
end

-- 资源点特效缩放
function UIWorldBuilding:setEffectScale(scale)
    -- body
    if self._moveClip ~= nil then
    -- self._moveClip:setScale(scale)
    end
end

-- 玩家建筑信息
function UIWorldBuilding:addBuildingTxt(worldTileInfo)

    local buildingInfo = worldTileInfo.buildingInfo
    local dy = GlobalConfig.WorldPlayerTitlePos.y
    local url = "images/map/Bg_playerName.png"
    local bg = TextureManager:createSprite(url)
    bg:setPositionY(dy)
    self:addChild(bg,1)
    local bgSize = bg:getContentSize()
    
    local name = buildingInfo.name
    local level = buildingInfo.level
    local levelTxt = ccui.Text:create()
    levelTxt:setFontSize(14)
    -- local content = string.format("%d %s", level, name)
    levelTxt:setString(level)
    levelTxt:setPosition(-bgSize.width / 2 - 10, dy)
    self:addChild(levelTxt,1)
    
    -- local txtSize = levelTxt:getContentSize()
    -- bg:setContentSize(txtSize.width + 10, txtSize.height + 5)

    local nameTxt = ccui.Text:create()
    nameTxt:setFontSize(14)
    nameTxt:setString(name)



    nameTxt:setPosition(20, dy)
    self:addChild(nameTxt,1)

    local size = nameTxt:getContentSize()
    if size.width > bgSize.width - 30 then
    --     bg:setScaleX(4)
        -- nameTxt:setAnchorPoint(0.23, 0.5)
        -- nameTxt:setPositionX(0)
    end


    self._buildTxtBg = bg
    self._buildLevelTxt = levelTxt
    self._buildNameTxt = nameTxt
    
    local roleProxy = self._mapPanel:getProxy(GameProxys.Role)
    local selfLegionName = roleProxy:getLegionName()

    local myName = roleProxy:getRoleName()
    local color = name == myName and cc.c3b(0, 255, 0) or cc.c3b(255,255,255)
    nameTxt:setColor(color)
    
    --有军团
    if worldTileInfo.legionName ~= "" and selfLegionName == worldTileInfo.legionName then
        local bgSize = bg:getContentSize()
        local url = "images/common/legion.png"
        local legionBg = TextureManager:createSprite(url)
        self:addChild(legionBg)
        legionBg:setPosition(-bgSize.width / 2 - 60 , dy)
        self._buildLegionBg = legionBg
        -- local legionTxt = ccui.Text:create()
        -- legionTxt:setFontSize(20)
        -- legionTxt:setPosition(-bgSize.width / 2 - 20 , dy)
        -- legionTxt:setString(TextWords:getTextWord(330)) 
        -- self:addChild(legionTxt)
    else
        self._buildLegionBg = nil
    end
    
    -- 免战保护小朋友
    if buildingInfo.protect == 1 then
        if self._protectUI == nil then
            self._protectUI = UICCBLayer.new("rpg-nengliangzhao", self)
        end
        -- local chip = self:getChildByName("defence")
        -- if chip == nil then
        --     chip = UIMovieClip.new("rpg-the-energy-shield")
        --     chip:setParent(self)
        --     chip:setName("defence")
        --     chip:setLocalZOrder(0)
        --     local diffX = 0
        --     local diffY = 40
        --     chip:setPosition(chip:getPositionX() + diffX, chip:getPositionY() + diffY)
        -- end
        -- chip:play(true)
    end
end

--添加剿匪副本
function UIWorldBuilding:addBanditDungeon(banditDungeon)
    local eventId = banditDungeon.eventId
    local panditMonster = ConfigDataManager:getConfigById(ConfigData.PanditMonsterConfig, eventId)

    local bg = UICCBLayer.new("rgb-diyin-qibing", self)
    self._banditBg = bg
    -- bg:setVisible(false)
    -- local bgUrl = string.format("images/map/bandit%d.png", panditMonster.icon)
    -- local bg = TextureManager:createSprite(bgUrl)
    self:addChild(bg)


    --TODO 背景名字

    local panel = cc.Node:create()
    self:addChild(panel)
    
    local url = "images/map/Bg_resLvBg.png"
    local rect_table = cc.rect(10,5,10,10)
    local bg = TextureManager:createScale9Sprite(url, rect_table)
    panel:addChild(bg)
    self._nameBg = bg

    local name = panditMonster.name
    local level = panditMonster.lv
    local txt = string.format(TextWords:getTextWord(318), level, name)
    local nameTxt = ccui.Text:create()
    nameTxt:setFontSize(14)
    nameTxt:setString(txt)
    panel:addChild(nameTxt)
    self._nameTxt = nameTxt
    nameTxt:setColor(ColorUtils.wordRedColor)
    local nameSize = nameTxt:getContentSize()
    bg:setContentSize(nameSize.width + 2, nameSize.height + 2)
    self._banditName = nameTxt

    local flagImg = TextureManager:createImageView("images/map/banditFlag.png")
    panel:addChild(flagImg)
    flagImg:setAnchorPoint(1, 0.5)
    flagImg:setPositionX( -nameTxt:getContentSize().width / 2)
    self._flagImg = flagImg

    --休整倒计时

    local countNode = cc.Node:create()
    local url = "images/map/Bg_resLvBg.png"
    local rect_table = cc.rect(10,5,10,10)
    local bg = TextureManager:createScale9Sprite(url, rect_table)

    bg:setContentSize(70, 17)
    countNode:addChild(bg)

   

    local countDownTxt = ccui.Text:create()
    countDownTxt:setFontSize(14)
    countNode:addChild(countDownTxt)
    countDownTxt:setColor(ColorUtils.wordGreenColor)

    countNode:setPositionY(-nameSize.height+13)

    panel:addChild(countNode)


    countNode:setVisible(false)

    self._countDownTxt = countDownTxt
    self._countNode = countNode
    self._countBg = bg
    self:updateDungeonRestTime()

    --clock:setPositionX(-countDownTxt:getContentSize().width / 2 - 10)--时钟图标


    local dy = GlobalConfig.WorldPlayerTitlePos.y
    panel:setPositionY(dy)
    self._banditPanel = panel


end

function UIWorldBuilding:updateDungeonRestTime()
    if self._countDownTxt == nil then
        
        return
    end

    TextureManager:updateImageView(self._flagImg, "images/map/Bg_horse.png")
    local banditDungeon = self._banditDungeon
    local banditDungeonProxy = self._mapPanel:getProxy(GameProxys.BanditDungeon)
    local time = banditDungeonProxy:getRemainRestTime(banditDungeon.id)

    local url = time > 0 and "images/map/Bg_horse.png" or "images/map/banditFlag.png"
    if self._flagImg ~= nil then
        TextureManager:updateImageView(self._flagImg, url)
    end

    local txt = string.format(TextWords:getTextWord(319), TimeUtils:getStandardFormatTimeString4(time))
    self._countDownTxt:setString(txt)
    self._countNode:setVisible(false)

    local size = self._countDownTxt:getContentSize()
    -- self._countBg:setContentSize(80, 25)

    if self._nameTxt and self._nameBg then
        self._nameTxt:setVisible(time <= 0)
        self._nameBg:setVisible(time <= 0)
    end

    if self._banditBg and self._flagImg then
        self._banditBg:setVisible(time <= 0)
        self._flagImg:setVisible(time <= 0)
    end

    if time > 0 then  --
        self._isBanditRest = true
        TimerManager:addOnce(1000, self.updateDungeonRestTime, self)
    else
        self._isBanditRest = false
        self._countNode:setVisible(false)
    end
end

function UIWorldBuilding:renderRebels()

    local rebelInfo = self._rebelsTileInfo.rebelInfo

    --叛军生成配置表
    local rebelDesignData = ConfigDataManager:getInfoFindByOneKey(ConfigData.ArmyGoDesignConfig, "monsterType", rebelInfo.rebelArmyType )

    --叛军动画
    if self._rebelsAnima == nil then
        self._rebelsAnima = UICCBLayer.new("rgb-diyin0" .. rebelDesignData.monsterType, self)
        self:addChild( self._rebelsAnima)
    end

    --叛军信息容器
    self._rebelsPanel = cc.Node:create()
    self._rebelsPanel:setPositionY(GlobalConfig.WorldPlayerTitlePos.y)
    self:addChild(self._rebelsPanel)
    
    --名称背景
    local url = "images/map/Bg_resLvBg.png"
    local rect_table = cc.rect(10,5,10,10)
    self._rebelsNameBg = TextureManager:createScale9Sprite(url, rect_table)
    self._rebelsPanel:addChild(self._rebelsNameBg)

    --名称
    self._rebelsNameTxt = ccui.Text:create()
    self._rebelsNameTxt:setFontSize(14)
    self._rebelsNameTxt:setString(string.format(TextWords:getTextWord(401300), rebelInfo.level, rebelDesignData.monsterName))
    self._rebelsNameTxt:setColor(ColorUtils.wordRedColor)
    self._rebelsPanel:addChild(self._rebelsNameTxt)
    
    --设置名称背景大小
    local nameSize = self._rebelsNameTxt:getContentSize()
    self._rebelsNameBg:setContentSize(nameSize.width + 2, nameSize.height + 2)    

    --战旗
    self._rebelsFlagImg = TextureManager:createImageView("images/map/banditFlag.png")
    self._rebelsFlagImg:setAnchorPoint(1, 0.5)
    self._rebelsFlagImg:setPositionX( -nameSize.width / 2)
    self._rebelsPanel:addChild(self._rebelsFlagImg)

end

function UIWorldBuilding:addPosTxt(x, y)
--    local txt = ccui.Text:create()
--    txt:setFontSize(20)
--    txt:setColor(ColorUtils.riceColor)
--    txt:setPosition(0,-55)
--    self:addChild(txt)
--    
--    txt:setString(string.format("(%d,%d)",x, y))
end

function UIWorldBuilding:getContentSize()
--    return cc.size(170,110)
    return cc.size(220,220)
end

function UIWorldBuilding:runAllChildAction(action)
    local children = self:getChildren()
    for _, child in pairs(children) do
        local actionClone = action:clone()
        child:runAction(actionClone)
    end
end

function UIWorldBuilding:onClickEvent()
    logger:info("-------onClickEvent----x:%d--y:%d-", self.worldTileInfo.x, self.worldTileInfo.y)

    if self.worldTileInfo.x < 0 or self.worldTileInfo.y < 0 then  --世界尽头不给操作
        self._mapPanel:showSysMessage(TextWords:getTextWord(315))
        return
    end

    if self._banditDungeon ~= nil then  --有剿匪副本信息，执行剿匪逻辑
        if self._isBanditRest == true then
            self._mapPanel:showSysMessage(TextWords:getTextWord(351))
            return
        end
        self._mapPanel:onBanditDungeonBattleTouch(self._banditDungeon)
        return
    end

    if self._tileType == WorldTileType.Building then
--        local playerId = self.worldTileInfo.buildingInfo.playerId
        self._mapPanel:onWatchPlayerInfoTouch(self.worldTileInfo)
    elseif self._tileType == WorldTileType.Resource then --查看资源
        self._mapPanel:onWatchResourceTouch(self.worldTileInfo)
    elseif self._tileType == WorldTileType.Empty then
        self._mapPanel:onEmptyTileTouch(self.worldTileInfo)
    elseif self._tileType == WorldTileType.Rebels then
        self._mapPanel:onRebelsTouch(self._rebelsTileInfo)
    end
    
end






