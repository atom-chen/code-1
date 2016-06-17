-------------------------------------------------------
RichLabelAlign = {}
RichLabelAlign.design_center = 1
RichLabelAlign.real_center = 2
RichLabelAlign.left_top = 3
RichLabelAlign.limit_center = 4
-------------------------------------------------------
--富文本 
local ccDirector = cc.Director:getInstance()
local ccTextureCache = ccDirector:getTextureCache()
RichLabel = class("RichLabel",function()
  return ccui.Layout:create()
end)
function RichLabel:create()
  local ret = RichLabel.new()
  ret:init()
  return ret
end



function RichLabel:init()
  self._lineNum = 1
  self.dic_lab = Dictionary:create()
  self.dic_img = Dictionary:create()
  self.dic_sprite = Dictionary:create()
  self._centerType = RichLabelAlign.design_center
  self._verticalSpace = 0
  self._strCharSizeMap = {} --字体尺寸映射缓存
end

function RichLabel:getLines()
  return self._lineNum
end

function RichLabel:getContainer()
  return self
end

function RichLabel:setData(tbl,lineWidth,defaultColor, lineSize)
  self:clean()
  self._elemRenderMap = {}
  self.lineMap = {}
  self.lineSize = lineSize
  for _,elem in ipairs(tbl) do
    if elem.txt and elem.txt ~= "" then -- 文本
      if type(elem.color) == "nil" then
        if defaultColor then
          if type(defaultColor) == "string" then
            elem.color = Utils.str2Color(defaultColor)
          else
            elem.color = defaultColor
          end
        else
          elem.color = cc.c3b(255,255,255)
        end
            elseif type(elem.color) == "string" then
                elem.color = Utils.str2Color(elem.color)
            end

      for _,char in ipairs(Utils.separate(tostring(elem.txt))) do
        local lab = self:getMesureLabel()
        local size = self:makeLabelSize(lab,elem,char)
        table.insert(self._elemRenderMap,{char=char,
                          width=size.width,
                          height=size.height,
                          isOutLine=1,
                          isUnderLine=elem.isUnderLine,
                          fontSize=elem.fontSize,
                          color=elem.color or cc.c3b(0x93,0xC8,0xFB),
                          data=elem.data})
      end
    elseif elem.img and elem.img ~= "" then -- 图片
      if cc.SpriteFrameCache:getInstance():getSpriteFrame(elem.img) or
        ccTextureCache:getTextureForKey(elem.img) then
        local imgContentSize = self:getMesureImageContentSize(elem.img,ccTextureCache:getTextureForKey(elem.img))
        table.insert(self._elemRenderMap,{img=elem.img,width=imgContentSize.width,height=imgContentSize.height,data=elem.data})
      end
    elseif elem.anim and elem.anim ~= "" then -- 动画
      if cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("%s%d.png",elem.anim,1)) then
        local imgContentSize = self:getMesureImageContentSize(string.format("%s%d.png",elem.anim,1))
        table.insert(self._elemRenderMap,{anim=elem.anim,dt=elem.dt,width=imgContentSize.width,height=imgContentSize.height,data=elem.data})
      end
    elseif elem.newline == 1 then -- 换行
      table.insert(self._elemRenderMap,{newline=1})
    end
  end

  local charWidth = 0
  local oneLine = 0
  local lines = 1

  if self._centerType == RichLabelAlign.real_center then
    self.lineWidth = display.width * 2 --无限宽
  else
    if lineWidth ~= nil then
      self.lineWidth = lineWidth
    else
      self.lineWidth = self.lineWidth or 600
    end
  end

  for i,elem in ipairs(self._elemRenderMap) do

    if elem.newline == 1 then --换行符

      oneLine = 0
            lines = lines +1
            self._lineNum = self._lineNum + 1
            elem.width = 0
            elem.height = 27
            elem.pos = cc.p(oneLine,-lines * 27)

    else --其他元素

          if oneLine + elem.width > self.lineWidth then
            
            if elem.char then --文字 

              if Utils.isCn(elem.char) or elem.char == " " then --中文字 或者空格 直接换行
                  
                  oneLine = 0
                  lines = lines +1
                  self._lineNum = self._lineNum + 1
                  elem.pos = cc.p(oneLine,-lines * 27)

                  oneLine = elem.width

              else --英文字或数字
                local spaceIdx = 0
                local idx = i
                while idx > 0 do 
                  idx = idx - 1

                  if self._elemRenderMap[idx] and 
                     self._elemRenderMap[idx].char == " " and
                     self._elemRenderMap[idx].pos.y == self._elemRenderMap[i-1].pos.y then --仅检测同一行
                    spaceIdx = idx
                    break
                  end
                end
                -- 找不到空格 直接换行
                if spaceIdx == 0 then
                
                  oneLine = 0
                  lines = lines +1
                  self._lineNum = self._lineNum + 1
                    elem.pos = cc.p(oneLine,-lines * 27)

                    oneLine = elem.width
                  else --有空格 可换行(要移位)

                    oneLine = 0
                    lines = lines +1
                    self._lineNum = self._lineNum + 1
                    for _i=spaceIdx+1,i do
                      
                      local _elem = self._elemRenderMap[_i]
                      _elem.pos = cc.p(oneLine,-lines * 27)
                    oneLine = oneLine + _elem.width
                    end
                end
              end
            elseif (elem.img ~= nil) or (elem.anim ~= nil) then --图片
              lines = lines +1
              self._lineNum = self._lineNum + 1
                elem.pos = cc.p(0,-lines * 27)
                oneLine = elem.width
            end
          else
            elem.pos = cc.p(oneLine,-lines * 27)
            oneLine = oneLine + elem.width
          end
      end
    end
----------------排序 分行----------------------------------------------
    local tmp = {}
    for i,v in ipairs(self._elemRenderMap) do
      if v.pos then
        tmp[ v.pos.y ] = tmp[ v.pos.y ] or {}
        table.insert(tmp[ v.pos.y ], v )
      end
    end 
    local tmpLineYKey = {}
    for lineY,v in pairs(tmp) do
      table.insert(tmpLineYKey,lineY)
    end
    table.sort( tmpLineYKey, function(a,b) return a > b end )
--------------------------------------------------------------
    for _,lineY in ipairs(tmpLineYKey) do

      local oneLine = ""
      local _lastEleme = tmp[lineY][1]
      local _lastDiffStarEleme = tmp[lineY][1]
      if #tmp[lineY] > 0 then
        local _arr = {}
        for _,elem in ipairs(tmp[lineY]) do

          if _lastEleme.char and elem.char then
            if Utils.isSameColor(_lastEleme.color,elem.color) then
              oneLine = oneLine .. elem.char

            else --颜色不同
              if _lastDiffStarEleme.char then
                local _newElem = clone(_lastDiffStarEleme)
                _newElem.str = oneLine
                table.insert(_arr,_newElem) 
                _lastDiffStarEleme = elem
                oneLine = elem.char
              end
            end
          elseif elem.img then

            if _lastDiffStarEleme.char then
              local _newElem = clone(_lastDiffStarEleme)
              _newElem.str = oneLine
              oneLine = ""
              table.insert(_arr,_newElem) 
            end

            table.insert(_arr,elem)
          elseif elem.anim then

            if _lastDiffStarEleme.char then
              local _newElem = clone(_lastDiffStarEleme)
              _newElem.str = oneLine
              oneLine = ""
              table.insert(_arr,_newElem) 
            end

            table.insert(_arr,elem)

          elseif elem.newline then

            if _lastDiffStarEleme.char then
              local _newElem = clone(_lastDiffStarEleme)
              _newElem.str = oneLine
              oneLine = ""
              table.insert(_arr,_newElem) 
            end

            table.insert(_arr,elem)
          elseif _lastEleme.char == nil then
            _lastDiffStarEleme = elem

            if elem.char then
              oneLine = elem.char
            end
          end
          _lastEleme = elem
        end
        if _lastEleme.char then
          local _newElem = clone(_lastDiffStarEleme)
        _newElem.str = oneLine
        table.insert(_arr,_newElem)
      end
        table.insert(self.lineMap,_arr)
      end
    end

  -- 偏移坐标
  local _obj = nil
  local _offsetLineY = 0
  self.realLineHeight = 0
  for i,lines in ipairs(self.lineMap) do
    local _lineHeight = 0
      for _,elem in ipairs(lines) do
        _lineHeight = math.max(_lineHeight,elem.height)
      end

      if i > 1 then --偶数行
        self.realLineHeight = self.realLineHeight + _lineHeight + self._verticalSpace
        _offsetLineY = _offsetLineY + (_lineHeight - 27) + self._verticalSpace
      else
        self.realLineHeight = self.realLineHeight + _lineHeight
        _offsetLineY = _offsetLineY + (_lineHeight - 27)
      end
      for _,elem in ipairs(lines) do
        elem.pos.y = elem.pos.y - _offsetLineY
        self.realLineHeight = math.max( self.realLineHeight, math.abs(elem.pos.y) )
      end
    end

    -- 放置元素坐标
    self.realLineWidth = 0
    for _,lines in ipairs(self.lineMap) do
      local _lineWidth = 0
      for _,elem in ipairs(lines) do
        if not elem.newline then
          if elem.img then
            _obj = self:getImage()
            self:makeImage(_obj,elem)
            _lineWidth = _lineWidth + _obj:getContentSize().width
          elseif elem.anim then
            _obj = self:getSprite()
            self:makeAnim(_obj,elem)
            _lineWidth = _lineWidth + elem.width
          elseif elem.str then
            _obj = self:getLabel()
            self:makeLabel(_obj,elem,elem.str)
            _lineWidth = _lineWidth + _obj:getContentSize().width
          end
          self:addChild(_obj)
          _obj:setPosition(cc.p(elem.pos.x,elem.pos.y + self.realLineHeight))
        end
      end   
      self.realLineWidth = math.max(_lineWidth,self.realLineWidth)
    end
    self:_onCenter()
end

function RichLabel:setCenterType(t)
  self._centerType = t
end

function RichLabel:_onCenter()
  if self._centerType == RichLabelAlign.design_center then
    self:setContentSize(cc.size(self:getDesignWidth(),self:getRealHeight()))
    self:setAnchorPoint(cc.p(0.5,0.5))

  elseif self._centerType == RichLabelAlign.real_center or
      self._centerType == RichLabelAlign.limit_center then
    
    self:setContentSize(cc.size(self:getRealWidth(),self:getRealHeight()))
    self:setAnchorPoint(cc.p(0.5,0.5))
  elseif self._centerType == RichLabelAlign.left_top then

    self:setContentSize(cc.size(self:getRealWidth(),self:getRealHeight()))
    self:setAnchorPoint(cc.p(0,1))
  end
end

function RichLabel:getRealHeight()
  return self.realLineHeight
end

function RichLabel:getRealWidth()
  return self.realLineWidth
end

function RichLabel:getDesignWidth()
  return self.lineWidth
end

function RichLabel:setVerticalSpace(s)
  self._verticalSpace = s
end

function RichLabel:getDrawNode()
  if self._drawNode == nil then
    self._drawNode = cc.DrawNode:create()
    self:addChild(self._drawNode)
  end
  return self._drawNode
end

function RichLabel:getMesureLabel()
  if self._mesureLable == nil then
    self._mesureLable = ccui.Text:create()
    self._mesureLable:retain()
    self._mesureLable:setFontName("Arial")
  end
  return self._mesureLable
end

function RichLabel:getMesureImageContentSize(path,type)
  if self._mesureImage == nil then
    self._mesureImage = ccui.ImageView:create()
    self._mesureImage:retain()
  end
  if type then
    self._mesureImage:loadTexture(path)
  else
    self._mesureImage:loadTexture(path, ccui.TextureResType.plistType)
  end
  return self._mesureImage:getContentSize()
end

function RichLabel:setOnClickHandle(func)
  self._func = func
end

function RichLabel:getLabel()
  local isNeetCreate = true
  for _,lab in pairs(self.dic_lab.list) do
    if lab.isUse == 0 then
      return lab
    end
  end
  if isNeetCreate then
    local lab = ccui.Text:create()
    lab:setAnchorPoint(cc.p(0,0))
    lab:addTouchEventListener(function(sender,eventType)
        if eventType == 2 then
          if self._func then
            self._func(sender.data)
          end
        end
      end)
    lab:setFontName("Arial")
    local key = "lab_".. Utils.getTblLen(self.dic_lab.list)
    self.dic_lab:setObject(lab,key)
    return self.dic_lab:objectForKey(key)
  end
end

function RichLabel:getImage()
  local isNeetCreate = true
  for _,img in pairs(self.dic_img.list) do
    if img.isUse == 0 then
      return img
    end
  end
  if isNeetCreate then
    local img = ccui.ImageView:create()
    img:setAnchorPoint(cc.p(0,0))
    img:addTouchEventListener(function(sender,eventType)
      if eventType == 2 then
          if self._func then
          self._func(sender.data)
        end
      end
      end)
    local key = "img_".. Utils.getTblLen(self.dic_img.list)
    self.dic_img:setObject(img,key)
    return self.dic_img:objectForKey(key)
  end
end

function RichLabel:getSprite()
  local isNeetCreate = true
  for _,img in pairs(self.dic_sprite.list) do
    if img.isUse == 0 then
      return img
    end
  end
  if isNeetCreate then
    local img = cc.Sprite:create()
    img:setAnchorPoint(cc.p(0,0))
    local key = "sprite_".. Utils.getTblLen(self.dic_sprite.list)
    self.dic_sprite:setObject(img,key)
    return self.dic_sprite:objectForKey(key)
  end
end

function RichLabel:makeImage(img,elem)
  img:stopAllActions()
  if not cc.SpriteFrameCache:getInstance():getSpriteFrame(elem.img) then
    img:loadTexture(elem.img)
  else
    img:loadTexture(elem.img, ccui.TextureResType.plistType)
  end
  img.isUse = 1
  img.data = elem.data 

  if elem.data then
    img:setTouchEnabled(true)
    else
      img:setTouchEnabled(false)
  end
end

function RichLabel:makeAnim(img,elem)
  img:stopAllActions()

  local pCache = cc.SpriteFrameCache:getInstance();
  local pFrame;
  local index = 1
  local pAnim = cc.Animation:create()
  local animName = ""
  while true do
    animName = string.format("%s%d.png",elem.anim,index)
    pFrame = pCache:getSpriteFrame(animName);
    if pFrame == nil then
      break
    end
    pAnim:addSpriteFrame(pFrame);
    index = index + 1
  end

  pAnim:setLoops(999);
  --pAnim:setRestoreOriginalFrame(true);
  pAnim:setDelayPerUnit(elem.dt or 0.1);
  img:runAction(cc.Animate:create(pAnim))
  img.isUse = 1
end

function RichLabel:makeLabelSize(lab,elem,char)

  local key = string.format("%s_%d",char,elem.fontSize or 22)
  if not self._strCharSizeMap[ key ] then
    self:makeLabel(lab,elem,char)
    self._strCharSizeMap[ key ] = lab:getContentSize()
  end
  return self._strCharSizeMap[ key ]
end

function RichLabel:makeLabel(lab,elem,char)

  lab:disableEffect()
  elem.color.a = 255
  if elem.isOutLine == 1 then
    lab:setColor(elem.color)
    lab:enableShadow(cc.c4b(0,0,0,255),cc.size(1,-1))
  else
    lab:setColor(elem.color)
  end
  
  lab:setFontSize(elem.fontSize or 22)
  lab:setString(char)
  lab.isUse = 1
  elem.pos = elem.pos or cc.p(0,0)
  if elem.isUnderLine == 1 and elem.pos and self.realLineHeight then
    local color4F = cc.convertColor(elem.color, "4f")
    color4F.a = 1--drawSegment
    self:getDrawNode():drawLine(
      cc.p(elem.pos.x,elem.pos.y + self.realLineHeight),
      cc.p(elem.pos.x +lab:getContentSize().width,elem.pos.y + self.realLineHeight ),
      color4F)
  end
  if elem.data then
    lab:setTouchEnabled(true)
    else
      lab:setTouchEnabled(false)
  end
  lab.data = elem.data 
end

function RichLabel:clean()
  if self._drawNode then
    self._drawNode:clear()
  end
  self.dic_lab:forEach(function(lab)
    lab.isUse = 0
    lab:setString("")
    lab:removeFromParent()
  end)
  self.dic_img:forEach(function(img)
    img.isUse = 0
    img:removeFromParent()
  end)
  self.dic_sprite:forEach(function(img)
    img.isUse = 0
    img:removeFromParent()
  end)
end

function RichLabel:dispose()
  self:clean()
  self.dic_lab:clean()
  self.dic_img:clean()
  self.dic_sprite:clean()
  if self._mesureLable then
    self._mesureLable:release()
    self._mesureLable = nil
  end
  if self._mesureImage then
    self._mesureImage:release()
    self._mesureImage = nil
  end
end

-------------------------------------------------------------------------------------------------------------
--富文本 动画 仅限文字
RichAnimLabel = class("RichAnimLabel",display.newWidget)
function RichAnimLabel:create()
 local ret = RichAnimLabel.new()
 ret:init()
 return ret
end

function RichAnimLabel:init()
 self.dic = Dictionary:create()
 self.labTbl = {}
end

function RichAnimLabel:setData(tbl,lineWidth)
 self:clean()
 self.labTbl = {}
 for _,elem in ipairs(tbl) do
   for _,char in pairs(Utils.separate(elem.txt)) do
     local lab = self:getLabel()
     self:makeLabel(lab,elem,char)
     local size = lab:getContentSize()
     table.insert(self.labTbl,{char=char,
                       width=size.width,
                       height=size.height,
                       fontSize=elem.fontSize,
                       color=elem.color or cc.c3b(0x93,0xC8,0xFB),
                       lab=lab})
     self:addChild(lab)
   end
 end

 local oneLine = 0
 local lines = 1
 self.lineWidth = lineWidth or 600

 for i,elem in ipairs(self.labTbl) do

   if elem.newline == 1 then --换行符

     oneLine = 0
            lines = lines +1
           
   else --其他元素
         if oneLine + elem.width > self.lineWidth then

           if Utils.isCn(elem.char) or elem.char == " " then --中文字 或者空格 直接换行
                
               oneLine = 0
               lines = lines +1
                
               elem.pos = cc.p(oneLine,-lines * 27)

               oneLine = elem.width

           else --英文字
             local spaceIdx = 0
             local idx = i
             while idx > 0 do 
               idx = idx - 1

               if self.labTbl[idx] and self.labTbl[idx].char == " " then
                 spaceIdx = idx
                 break
               end
             end
             -- 找不到空格 直接换行
             if spaceIdx == 0 then
              
               oneLine = 0
               lines = lines +1
                 elem.pos = cc.p(oneLine,-lines * 27)

                 oneLine = elem.width
               else --有空格 可换行(要移位)

                 oneLine = 0
                 lines = lines +1

                 for _i=spaceIdx+1,i do
                    
                   local _elem = self.labTbl[_i]
                   _elem.pos = cc.p(oneLine,-lines * 27)
                 oneLine = oneLine + _elem.width
                 end
             end
           end
         else
           elem.pos = cc.p(oneLine,-lines * 27)
           oneLine = oneLine + elem.width
         end
     end
    end
    self.realLineHeight = math.abs(lines) * 27
    -- 设置坐标
    for _,elem in ipairs(self.labTbl) do
     elem.lab:setPosition(elem.pos)
    end
end

function RichAnimLabel:getRealHeight()
 return self.realLineHeight
end

function RichAnimLabel:getRealWidth()
 return self.lineWidth
end

function RichAnimLabel:setAllVisible(value)
 for _,elem in ipairs(self.labTbl) do
   if elem.lab then
     elem.lab:setVisible(value)
   end
 end
end
function RichAnimLabel:setVisibleAtIndex(i,value)
 if self.labTbl[i] and self.labTbl[i].lab then
   self.labTbl[i].lab:setVisible(value)
 end
end

function RichAnimLabel:getLabel()
 local isNeetCreate = true
 for _,lab in pairs(self.dic.list) do
   if lab.isUse == 0 then
     return lab
   end
 end
 if isNeetCreate then
   local lab = ccui.Text:create()
   lab:setFontName("res/font/Arial.ttf")
   local key = "lab_".. Utils.getTblLen(self.dic.list)
   self.dic:setObject(lab,key)
   return self.dic:objectForKey(key)
 end
end

function RichAnimLabel:makeLabel(lab,elem,char)
 lab:setAnchorPoint(cc.p(1, 0))
 lab:setString(char)
 lab:setColor(elem.color or cc.c3b(0x93,0xC8,0xFB))
 lab:setFontSize(elem.fontSize or 20)
 lab.isUse = 1
end

function RichAnimLabel:clean()
 self.dic:forEach(function(lab)
   lab.isUse = 0
   lab:setString("")
   lab:removeFromParent()
 end)
end

function RichAnimLabel:dispose()
 self:clean()
 self.dic:clean()
end