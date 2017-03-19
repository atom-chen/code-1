
ColorUtils = {}

ColorUtils.copyColor = cc.c3b(190,183,142)          --副本颜色
ColorUtils.typeColor = cc.c3b(194,102,10)           --类型颜色 加亮
ColorUtils.labelColor = cc.c3b(86,72,37)           --文本颜色
ColorUtils.forbidColor = cc.c3b(120,68,13)           --禁止颜色
ColorUtils.riceColor = cc.c3b(250,253,193)           --米色
ColorUtils.wordGreyColor = cc.c3b(129,129,129)     --文字颜色[隐藏]
ColorUtils.wordWhiteColor = cc.c3b(255,255,255)    --文字颜色[白色]
ColorUtils.wordGreenColor = cc.c3b(64,226,21)     --文字颜色[绿色]
ColorUtils.wordBlueColor = cc.c3b(19,177,236)      --文字颜色[蓝色]
ColorUtils.wordPurpleColor = cc.c3b(255,39,252)    --文字颜色[紫色]
ColorUtils.wordOrangeColor = cc.c3b(253,235,3)    --文字颜色[橙色]
ColorUtils.wordRedColor = cc.c3b(253,1,1)        --文字颜色[红色]
ColorUtils.wordGrayColor = cc.c3b(125,125,125)        --文字颜色[灰色]

ColorUtils.wordAddColor = cc.c3b(255,78,0)        --文字颜色[橘色]
ColorUtils.wordTitleColor = cc.c3b(247,156,0)        --弹窗标题色[橙黄]

-- ColorUtils.wordYellowColor = cc.c3b(238,189,48)        --文字颜色[黄黄的颜色]

ColorUtils.nameString = {}
ColorUtils.nameString[1] = "白"
ColorUtils.nameString[2] = "绿"
ColorUtils.nameString[3] = "蓝"
ColorUtils.nameString[4] = "紫"
ColorUtils.nameString[5] = "橙"
ColorUtils.nameString[6] = "红"

ColorUtils.chatColor = {}
ColorUtils.chatColor[1] = cc.c3b(255,255,255)
ColorUtils.chatColor[2] = cc.c3b(64,226,21)
ColorUtils.chatColor[3] = cc.c3b(19,177,236)
ColorUtils.chatColor[4] = cc.c3b(255,39,252)
ColorUtils.chatColor[5] = cc.c3b(253,235,3)

ColorUtils.TipColor = {}
ColorUtils.wordGreyColor16 = "#818181"      --文字颜色[隐藏]
ColorUtils.wordWhiteColor16 = "#FFFFFF"     --文字颜色[白色]
ColorUtils.wordGreenColor16 = "#40E215"     --文字颜色[绿色]
ColorUtils.wordBlueColor16 = "#13B1EC"      --文字颜色[蓝色]
ColorUtils.wordPurpleColor16 = "#FF27FC"    --文字颜色[紫色]
ColorUtils.wordOrangeColor16 = "#EE8811"    --文字颜色[橙色]
ColorUtils.wordRedColor16 = "#FD0101"       --文字颜色[红色]

-- 十六进制颜色-----------------------------------------------
-- 深色背景
ColorUtils.wordColorDark1601 = "#eed6aa"    --文字颜色[常量]灰
ColorUtils.wordColorDark1602 = "#FFFFFF"    --文字颜色[变量]白
ColorUtils.wordColorDark1603 = "#25ef3c"    --文字颜色[增益]绿
ColorUtils.wordColorDark1604 = "#ff3e3e"    --文字颜色[减益]红
-- 浅色背景
ColorUtils.wordColorLight1601 = "#ffeb7d"   --文字颜色[常量]黄
ColorUtils.wordColorLight1602 = "#eed6aa"   --文字颜色[变量]灰
ColorUtils.wordColorLight1603 = "#46ff3d"   --文字颜色[增益]绿
ColorUtils.wordColorLight1604 = "#6f0b06"   --文字颜色[减益]红

-- RGB颜色----------------------------------------------------
ColorUtils.wordColor01 = cc.c3b(84,66,42)    --文字颜色[常量]深褐
-- 深色背景
ColorUtils.wordColorDark01 = cc.c3b(238,214,170)    --文字颜色[常量]灰
ColorUtils.wordColorDark02 = cc.c3b(255,255,255)    --文字颜色[变量]白
ColorUtils.wordColorDark03 = cc.c3b(37,239,60)      --文字颜色[增益]绿
ColorUtils.wordColorDark04 = cc.c3b(255,62,62)      --文字颜色[减益]红
-- 浅色背景
ColorUtils.wordColorLight01 = cc.c3b(255,235,125)   --文字颜色[常量]黄
ColorUtils.wordColorLight02 = cc.c3b(238,214,170)   --文字颜色[变量]灰
ColorUtils.wordColorLight03 = cc.c3b(70,255,61)     --文字颜色[增益]绿
ColorUtils.wordColorLight04 = cc.c3b(255,32,32)      --文字颜色[减益]红


ColorUtils.TipSize = {}
ColorUtils.tipSize14 = 14
ColorUtils.tipSize16 = 16
ColorUtils.tipSize18 = 18
ColorUtils.tipSize20 = 20
ColorUtils.tipSize22 = 22
ColorUtils.tipSize24 = 24
ColorUtils.tipSize30 = 30

function ColorUtils:getColorByState(state)
    local color = nil
    if state == 1 then --老服 火爆 良好
        color = cc.c3b(37, 239, 60) -- ColorUtils.wordGreenColor
    elseif state == 2 then --新服
        color = cc.c3b(255, 189, 48) --ColorUtils.riceColor
    elseif state == 4 then --即将开服
        color = cc.c3b(255, 236, 23) --ColorUtils.wordRedColor
    else --3 维护中
        color = cc.c3b(243, 14, 14) --ColorUtils.wordRedColor
    end
    return color
end


function ColorUtils:getColorByQuality(type) -- 取品质颜色，默认白色，大于等于7为灰色
    local color = {}
    color[1] = ColorUtils.wordWhiteColor                 
    color[2] = ColorUtils.wordGreenColor
    color[3] = ColorUtils.wordBlueColor
    color[4] = ColorUtils.wordPurpleColor
    color[5] = ColorUtils.wordOrangeColor
    color[6] = ColorUtils.wordRedColor
    color[7] = ColorUtils.wordGreyColor
    if type == nil then
        return color[1]
    elseif type > 7 then
        return color[7]
    end
    return color[type]
end


-- ColorUtils.TipColor = {}
-- ColorUtils.wordGreyColor16 = "#818181"      --文字颜色[隐藏]
-- ColorUtils.wordWhiteColor16 = "#FFFFFF"     --文字颜色[白色]
-- ColorUtils.wordGreenColor16 = "#40E215"     --文字颜色[绿色]
-- ColorUtils.wordBlueColor16 = "#13B1EC"      --文字颜色[蓝色]
-- ColorUtils.wordPurpleColor16 = "#FF27FC"    --文字颜色[紫色]
-- ColorUtils.wordOrangeColor16 = "#EE8811"    --文字颜色[橙色]
-- ColorUtils.wordRedColor16 = "#FD0101"       --文字颜色[红色]

-- 取16进制颜色，富文本显示用
function ColorUtils:getRichColorByQuality(type) -- 取品质颜色，默认白色，大于等于7为灰色
    local color = {}
    color[1] = ColorUtils.wordWhiteColor16                 
    color[2] = ColorUtils.wordGreenColor16
    color[3] = ColorUtils.wordBlueColor16
    color[4] = ColorUtils.wordPurpleColor16
    color[5] = ColorUtils.wordOrangeColor16
    color[6] = ColorUtils.wordRedColor16
    color[7] = ColorUtils.wordGreyColor16
    if type == nil then
        return color[1]
    elseif type > 7 then
        return color[7]
    end
    return color[type]
end

function ColorUtils:getChatColorByType(type)
    local color = self.chatColor[type]
    if color == nil then
        color = self.chatColor[1]
    end
    return color
end

function ColorUtils:color16ToC3b(color)
    local color = string.gsub(color, "#", "")
    local r = tonumber(string.sub(color, 1, 2), 16) 
    local g = tonumber(string.sub(color, 3, 4), 16) 
    local b = tonumber(string.sub(color, 5, 6), 16) 
    return cc.c3b(r, g, b)
end

ColorUtils.FrameNameMap = {}
ColorUtils.FrameNameMap[1] = nil
ColorUtils.FrameNameMap[2] = nil
ColorUtils.FrameNameMap[3] = "Item_blue"
ColorUtils.FrameNameMap[4] = "Item_purple"
ColorUtils.FrameNameMap[5] = "Item_orange"

function ColorUtils:getFrameNameByQuality(color)
    return ColorUtils.FrameNameMap[color]
end

FontUtils = {}

function FontUtils:createFont(alias, 
    fontName, color, size_pt, style, strength, sce_color, facidx)
    
    cc.FontFactory:createFont(alias, 
        fontName, color, size_pt, style, strength, sce_color, facidx)
end








