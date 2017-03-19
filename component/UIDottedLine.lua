
UIDottedLine = class("UIDottedLine")

function UIDottedLine:ctor(nodePos1, nodePos2, parent, dottedNode, targetNode, dirNode)

    -- 根节点
    self._rootNode = cc.Node:create()
    self._rootNode:setPosition(0, 0)
    self._rootNode:setLocalZOrder(9999)

    -- 目标节点
    self._rootNode:addChild(targetNode)
    self._targetNode = targetNode

    -- 线节点
    self._lineNode = cc.Node:create()
    self._lineNode:setPosition(0, 0)
    self._rootNode:addChild(self._lineNode)
    parent:addChild(self._rootNode)


    -- self._dottedGroup = { }
    self:drawLine(nodePos1, nodePos2, self._lineNode, dottedNode, targetNode, dirNode)
    if dirNode ~= nil then
        self.infoNode = dirNode.infoNode
    end
    if self.infoNode ~= nil then
        self.timeTxt = self.infoNode:getChildByName("timeTxt")
    end
    TimerManager:add(1000, self.update, self, -1)

end

function UIDottedLine:finalize()

    -- 打完叛军，和其他不同的是立刻返回，重新create另一条行军路线(创建大量的dottedNode)，
    -- 同时异步加载资源，
    -- 如果直接迟释放，如果有40多分钟以上的路程卡2秒多,有空仔细研究一下
    local function delayFinalize()
        --local a = os.clock()
        if self._rootNode ~= nil then
            self._rootNode:removeFromParent()
            self._rootNode = nil
        end
        --print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++" .. os.clock() - a)
    end
    if self._rootNode ~= nil then
        self._rootNode:setVisible(false)
    end
    TimerManager:addOnce(0.5, delayFinalize, self)

    TimerManager:remove(self.update, self)
    if self._dirNode ~= nil then
        self._dirNode:removeFromParent()
        self._dirNode = nil
    end
    if self.infoNode ~= nil then
        self.infoNode:removeFromParent()
        self.infoNode = nil
    end
end

-- dirNode的移动参数
function UIDottedLine:setMoveData(data)
    if self._dirNode == nil then
        return
    end

    self._moveData = data
    local totalTime = self._moveData.totalTime
    local alreadyTime = self._moveData.alreadyTime

    self._alreadyTime = alreadyTime
    self._totalTime = totalTime
    self._time = totalTime - alreadyTime
    if self.timeTxt ~= nil then
        local timeStr = TimeUtils:getStandardFormatTimeString4(self._totalTime)
        self.timeTxt:setString(timeStr)
    end

    self._speedDir = cc.pMul(self._distance, 1 / totalTime)

    self:update()
end

function UIDottedLine:getTargetPosition()
    return self._endX, self._endY
end

function UIDottedLine:getTargetNode()
    return self._targetNode
end

function UIDottedLine:drawLine(nodePos1, nodePos2, lineNode, dottedNode, targetNode, dirNode)
    local dottedGroup = { }

    local x1, y1 = nodePos1.x, nodePos1.y
    local x2, y2 = nodePos2.x, nodePos2.y

    self._endX = x2
    self._endY = y2


    local dir = cc.p(x2 - x1, y2 - y1)
    if dir.x == 0 and dir.y == 0 then
        targetNode:setPosition(x1, y1)
        -- self._dottedGroup = dottedGroup
        return
    end

    local normalDir = cc.pNormalize(dir)

    self._startPos = nodePos1
    self._distance = dir

    local angle = math.deg(cc.pToAngleSelf(dir))

    local inval = 40

    local len = cc.pGetLength(dir)
    local size = math.floor(len / inval)

    -- print("!!!!!!!!size!!!!!!!!!!", size)

    for index = 1, size - 2 do
        local dlen = inval * index
        local dir2 = cc.pMul(normalDir, dlen)

        local srcPos = cc.p(x1 + dir2.x, y1 + dir2.y)
        local dotted = dottedNode:clone()
        -- local dotted = cc.Node:create()
        dotted:setPosition(srcPos.x, srcPos.y)
        dotted:setRotation(- angle)
        lineNode:addChild(dotted)

        -- local nextDir = cc.pMul(normalDir, inval * (index + 1) )
        -- local nextDtPos = cc.p(nextDir.x - dir2.x, nextDir.y - dir2.y)
        -- self:runLineAction(dotted, srcPos, nextDtPos)

        -- table.insert(dottedGroup, dotted)
    end

    local dir2 = cc.pMul(normalDir, inval)
    local nextDir = cc.pMul(normalDir, inval * 2)
    local nextDtPos = cc.p(nextDir.x - dir2.x, nextDir.y - dir2.y)
    self:runLineAction(lineNode, cc.p(0, 0), nextDtPos)


    if dirNode ~= nil then
        dirNode:setPosition(x1, y1)
        dirNode:setLocalZOrder(9999)
        if self.infoNode ~= nil then
            self.infoNode:setPosition(x1, y1)
            -- self.infoNode:setLocalZOrder(20000)
        end
        -- dirNode:setParent(parent)
    end

    targetNode:setPosition(x2, y2)

    -- self._dottedGroup = dottedGroup

    self._dirNode = dirNode

end

function UIDottedLine:runLineAction(node, srcPos, nextDtPos)

    local function callback()
        node:setPosition(srcPos.x, srcPos.y)
        -- node:setOpacity(0)
    end

    -- local fadeAction1 = cc.FadeTo:create(0.5, 255)
    -- local fadeAction2 = cc.FadeTo:create(0.01, 0)
    local moveBy1 = cc.MoveBy:create(1, cc.p(nextDtPos.x, nextDtPos.y))
    -- local moveBy2 = cc.MoveBy:create(0.01, cc.p(-nextDtPos.x, -nextDtPos.y))

    -- local spawn1 = cc.Spawn:create(fadeAction1, moveBy1)
    -- local spawn2 = cc.Spawn:create(fadeAction2, moveBy2)

    local callFunc = cc.CallFunc:create(callback)

    local seq = cc.Sequence:create(moveBy1, callFunc)

    local repeatAction = cc.RepeatForever:create(seq)

    node:runAction(repeatAction)
end

function UIDottedLine:update()

    if self._alreadyTime ~= nil and self._dirNode ~= nil then
        local s = cc.pMul(self._speedDir, self._alreadyTime)

        local curPosX = self._startPos.x + s.x
        local curPosY = self._startPos.y + s.y


        self._dirNode:setPosition(self._startPos.x + s.x, self._startPos.y + s.y)


        self._alreadyTime = self._alreadyTime + 1

        if self.timeTxt ~= nil then
            self._time = self._totalTime - self._alreadyTime
            local timeStr = TimeUtils:getStandardFormatTimeString4(self._time)
            self.timeTxt:setString(timeStr)
        end

        if self.infoNode ~= nil then
            local offsetPos = self.infoNode.timePos
            self.infoNode:setPosition(self._startPos.x + s.x + offsetPos.x, self._startPos.y + s.y + 30 + offsetPos.y)
        end

    end
end
