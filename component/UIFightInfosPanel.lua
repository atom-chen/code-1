--群雄涿鹿的战场信息模板
UIFightInfosPanel = class("UIFightInfosPanel", BasicComponent)

function UIFightInfosPanel:ctor(parent,data,isShowBtn,bgType)
    -- local uiSkin = UISkin.new("UIFightInfosPanel")

    UIFightInfosPanel.super.ctor(self)

    local function initPanel(skin)
        self._uiSkin = skin
        self._parent = parent
        self._isShowBtn = isShowBtn
        self._soliderProxy = parent:getProxy(GameProxys.Soldier)
        self._battleActivityProxy = parent:getProxy(GameProxys.BattleActivity)
        self.bgType = bgType
        self._roleProxy = parent:getProxy(GameProxys.Role)
        self.listview = self._uiSkin:getChildByName("PanelTop/ListView")
        self:registerEvent()
        self:updateData(data)
    end

    local function doLayout(skin)
        self._uiSkin = skin
        self:doLayout()
    end

    local uiSkin = UISkin.new("UIFightInfosPanel", initPanel, doLayout)
    -- self._uiSkin = uiSkin
    uiSkin:setParent(parent)
    -- self:updateData(data)
end

--TODO !!这里外部还没有调用
function UIFightInfosPanel:finalize()
    UIFightInfosPanel.super.finalize(self)
end

function UIFightInfosPanel:doLayout()
    self.listview = self._uiSkin:getChildByName("PanelTop/ListView")
    local tabPanel = self._parent:getTabsPanel()
    local PanelDown = self._parent:getChildByName("PanelDown")
    NodeUtils:adaptiveListView(self.listview, PanelDown, tabPanel , 0)
end

function UIFightInfosPanel:initPanel()
end

function UIFightInfosPanel:registerEvent()
    
    -- local Label_result = self._uiSkin:getChildByName("PanelTop/Label_result")
    -- Label_result:setVisible(not(self._isShowBtn or false))
end

function UIFightInfosPanel:updateData(data)
    --if data then
    
    self:renderListView(self.listview, data or {}, self, self.registerItemEvents)
    --end
end

function UIFightInfosPanel:registerItemEvents(item,data,index)
    local Panel1 = item:getChildByName("Panel1")
    local Panel2 = item:getChildByName("Panel2")
    local Panel3 = item:getChildByName("Panel3")
    local bgImg = item:getChildByName("bgImg")
    --local bgImg2 = item:getChildByName("bgImg2")
    Panel3:setVisible(false)
    local Label_t = item:getChildByName("Label_t")
    --local goBtn = item:getChildByName("goBtn")
    item.data = data

    -- if self._isShowBtn == true then
    --     bgImg:setVisible(false)
    --     if index % 2 == 0 then
    --         bgImg2:setVisible(true)
    --     else
    --         bgImg2:setVisible(false)
    --     end
    -- end

    if data.type == 1 then

        local roleName = self._roleProxy:getRoleName()

        Panel1:setVisible(true)
        Panel2:setVisible(false)

        local Label_f = Panel1:getChildByName("Label_f")          --攻击方军团名称
        local Label_p = Panel1:getChildByName("Label_p")          --防守方军团名称
        local Label_namef = Panel1:getChildByName("Label_namef")  --攻击方玩家名称
        local Label_namep = Panel1:getChildByName("Label_namep")  --防守方玩家名称
        local Img_lose = Panel1:getChildByName("Img_lose")
        local Img_win = Panel1:getChildByName("Img_win")
        local Image_wl = Panel1:getChildByName("Image_wl")        --连胜
        local AtlasLabel = Panel1:getChildByName("AtlasLabel")

        local Img_lm = Panel1:getChildByName("Img_lm") --左边我的标记
        local Img_rm = Panel1:getChildByName("Img_rm") --右边我的标记
        Img_lm:setVisible(false)
        Img_rm:setVisible(false)


        local serverData = data.fightInfo
        local attackTeam = serverData.attackTeam
        local defendTeam = serverData.defendTeam
        local time = serverData.time                              --发生时间
        local wins = serverData.wins                              --连胜次数 0表示失败 1胜利 2...连胜xxx

        Label_t:setString(TimeUtils:setTimestampToString5(time))
        Label_t:setVisible(true)

        Label_f:setString(attackTeam.legionName)
        Label_namef:setString(attackTeam.playerName)

        Label_p:setString(defendTeam.legionName)
        Label_namep:setString(defendTeam.playerName)

        local Label_ratef = Panel1:getChildByName("Label_ratef") --左边百分比
        local Label_ratep = Panel1:getChildByName("Label_ratep") --右边百分比

        Label_ratef:setString("("..attackTeam.percent.."%)")
        Label_ratep:setString("("..defendTeam.percent.."%)")

        --Label_namef:setPositionX(Label_ratef:getPositionX() - Label_ratef:getContentSize().width)  --左边名字对齐
        --Label_ratep:setPositionX(Label_namep:getPositionX() + Label_namep:getContentSize().width)

        if roleName == attackTeam.playerName then
            Img_lm:setVisible(true)
        elseif roleName == defendTeam.playerName then
            Img_rm:setVisible(true)
        end

        -- if self._isShowBtn == true then
        --     wins = -1
        -- end
        --goBtn:setVisible(self._isShowBtn or false)

        if wins == 0 then  --失败
            Img_lose:setVisible(true)
            Img_win:setVisible(false)
            Image_wl:setVisible(false)
            AtlasLabel:setVisible(false)
        elseif wins == 1 then  --胜利
            Img_lose:setVisible(false)
            Img_win:setVisible(true)
            Image_wl:setVisible(false)
            AtlasLabel:setVisible(false)
        elseif wins > 1 then --几连胜
            Img_lose:setVisible(false)
            Img_win:setVisible(false)
            Image_wl:setVisible(true)
            AtlasLabel:setVisible(true)
            AtlasLabel:setString(wins)
        else   --个人详情
            -- Img_lose:setVisible(false)
            -- Img_win:setVisible(false)
            -- Image_wl:setVisible(false)
            -- AtlasLabel:setVisible(false)
            -- goBtn:setVisible(true)
            -- goBtn.data = data
            -- if goBtn.isAdd == true then
            --     return
            -- end
            -- goBtn.isAdd = true
            -- ComponentUtils:addTouchEventListener(goBtn, self.onClickBtnTouch, nil, self)
        end
    elseif data.type == 2 then
        Panel1:setVisible(false)
        Panel2:setVisible(true)

        local serverData = data.fightInfo

        local Label_l = Panel2:getChildByName("Label_l")          --被淘汰军团名称
        Label_l:setVisible(false)
--        local Label_p = Panel2:getChildByName("Label_p")          --玩家名称
--        local Label_r = Panel2:getChildByName("Label_r")          --排名

--        Label_t:setString(TimeUtils:setTimestampToString5(serverData.time))
--        Label_l:setString(serverData.legionName)
--        Label_p:setString(serverData.playerName)
--        Label_r:setString(serverData.rank.."名")

      --TODO 文本不规范，后面要改； 如果有富文本的需求，直接处理table，显得比较麻烦，应该有个辅助工具，获得类来处理

       local lines = { { {content = serverData.legionName, color = ColorUtils.wordRedColor16 },
                       {content = TextWords:getTextWord(380004)}, {content = serverData.playerName, color = ColorUtils.wordGreenColor16 }, 
                       {content = TextWords:getTextWord(380005)},
                       {content = serverData.rank, color = ColorUtils.wordOrangeColor16}, {content = TextWords:getTextWord(380003)},
                       {content = "    " .. TimeUtils:setTimestampToString5(serverData.time) , color = ColorUtils.wordOrangeColor16} } }
        local richNode = Panel2.richNode
        if richNode == nil then
            richNode = ComponentUtils:createRichNodeWithString("", 22)
            Panel2.richNode = richNode
            richNode:setPosition(Label_l:getPosition())
            Panel2:addChild(richNode)
        end
         
        richNode:setString(lines)

        local x = (Panel2:getContentSize().width - richNode:getContentSize().width) / 2
        richNode:setPositionX(x)

        Label_t:setVisible(false)

        
        --goBtn:setVisible(false)
    else 
        Panel1:setVisible(false)
        Panel2:setVisible(false)
        Panel3:setVisible(true)
        --goBtn:setVisible(false)
        local Label_name3 = Panel3:getChildByName("Label_name3")
        Label_name3:setVisible(false)
        local serverData = data.fightInfo
--        Label_name3:setString(serverData.legionName)

--        Label_t:setString(TimeUtils:setTimestampToString5(serverData.time))

        local lines = { { {content = TextWords:getTextWord(380001)}, {content = serverData.legionName, color = ColorUtils.wordGreenColor16 },
                       {content = TextWords:getTextWord(380002)}, {content = "1", color = ColorUtils.wordOrangeColor16}, {content = TextWords:getTextWord(380003)},
                       {content = "    " .. TimeUtils:setTimestampToString5(serverData.time) , color = ColorUtils.wordOrangeColor16} } }

        local richNode = Panel3.richNode
        if richNode == nil then
            richNode = ComponentUtils:createRichNodeWithString("", 22)
            Panel3.richNode = richNode
            richNode:setPosition(Label_name3:getPosition())
            Panel3:addChild(richNode)
        end

        richNode:setString(lines)
        local x = (Panel3:getContentSize().width - richNode:getContentSize().width) / 2
        richNode:setPositionX(x)

        Label_t:setVisible(false)
    end

    ComponentUtils:onUpdateLvItem(bgImg,data.actorType)
end

-- function UIFightInfosPanel:onClickBtnTouch(sender)
--     self._battleActivityProxy:onTriggerNet330009Req({battleId = sender.data.fightInfo.battleId})
-- end

-- function UIFightInfosPanel:onSetTitleImg(status,notStatus)
--     local titleImg = self._uiSkin:getChildByName("PanelTop/titleImg")
--     local titleImg1 = self._uiSkin:getChildByName("PanelTop/titleImg1")
--     titleImg:setVisible(status)
--     titleImg1:setVisible(notStatus)
-- end

function UIFightInfosPanel:onSetPosOffset(xx,yy)
    local px = self._uiSkin:getPositionX()
    local py = self._uiSkin:getPositionY()

    px = px + xx or 0
    py = py + yy or 0

    self._uiSkin:setPositionX(px)
    self._uiSkin:setPositionY(py)
end