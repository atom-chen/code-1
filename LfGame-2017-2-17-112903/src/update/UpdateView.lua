local HotUpdateUtils = HotUpdateUtils or {}

local fileUtils = cc.FileUtils:getInstance()

--字符串根据指定符号，拆成table并返回
HotUpdateUtils.split = function(str, delim)
    assert(type (delim) == "string" and string.len (delim) > 0, "bad delimiter")
    local start = 1
    local results = {}

    while true do
        local pos = string.find(str, delim, start, true)
        if not pos then
            break
        end
        table.insert(results, string.sub(str, start, pos - 1))
        start = pos + string.len(delim)
    end

    table.insert (results, string.sub(str, start))
    return results
end

--删除指定目录下的文件夹
HotUpdateUtils.removeFile = function(path)
  path = HotUpdateUtils.checkPath(path)
  local isHas = fileUtils:isDirectoryExist(path)
  local isSuccess = false
  if isHas then
    isSuccess = fileUtils:removeDirectory(path)
  end
  if isSuccess then
    print("remove file success")
  end
end

--指定目录创建文件夹
HotUpdateUtils.createFile = function(path, removeOld)
    path = HotUpdateUtils.checkPath(path)
    if removeOld then
        HotUpdateUtils.removeFile(path)
        if fileUtils:createDirectory(path) then
            print("create file success")
        end
    else
      local isHas = fileUtils:isDirectoryExist(path)
      local isSuccess = false
      if not isHas then
          isSuccess = fileUtils:createDirectory(path)
      end
      if isSuccess then
          print("create file success")
      end
    end
end

HotUpdateUtils.checkPath = function(path)
  path = string.reverse(path)
  local pos = string.find(path, "/")
  if pos ~= 1 then
    path = "/"..path
  end
  path = string.reverse(path)
  return path
end

HotUpdateUtils.encode = function(source_str)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local s64 = ''
    local str = source_str

    while #str > 0 do
        local bytes_num = 0
        local buf = 0

        for byte_cnt=1,3 do
            buf = (buf * 256)
            if #str > 0 then
                buf = buf + string.byte(str, 1, 1)
                str = string.sub(str, 2)
                bytes_num = bytes_num + 1
            end
        end

        for group_cnt=1,(bytes_num+1) do
            b64char = math.fmod(math.floor(buf/262144), 64) + 1
            s64 = s64 .. string.sub(b64chars, b64char, b64char)
            buf = buf * 64
        end

        for fill_cnt=1,(3-bytes_num) do
            s64 = s64 .. '='
        end
    end

    return s64
end

HotUpdateUtils.decode = function(str64)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local temp={}
    for i=1,64 do
        temp[string.sub(b64chars,i,i)] = i
    end
    temp['=']=0
    local str=""
    for i=1,#str64,4 do
        if i>#str64 then
            break
        end
        local data = 0
        local str_count=0
        for j=0,3 do
            local str1=string.sub(str64,i+j,i+j)
            if not temp[str1] then
                return
            end
            if temp[str1] < 1 then
                data = data * 64
            else
                data = data * 64 + temp[str1]-1
                str_count = str_count + 1
            end
        end
        for j=16,0,-8 do
            if str_count > 0 then
                str=str..string.char(math.floor(data/math.pow(2,j)))
                data=math.mod(data,math.pow(2,j))
                str_count = str_count - 1
            end
        end
    end
    return str
end

HotUpdateUtils.writeDataByKey = function(key, value)
  local base64Value = HotUpdateUtils.encode(value)
  local base64Key = "ttt"..key.."kkk"
  cc.UserDefault:getInstance():setStringForKey(base64Key, base64Value)
end

HotUpdateUtils.readDataByKey = function(key)
  local base64Key = "ttt"..key.."kkk"
  local result = cc.UserDefault:getInstance():getStringForKey(base64Key)
  return HotUpdateUtils.decode(result)
end

HotUpdateUtils.otherSerialize = function(t, delim)
  delim = delim or ""
  local mark={}
    local assign={}
    
    local function ser_table(tbl,parent)
        mark[tbl]=parent
        local tmp={}
        for k,v in pairs(tbl) do
            local key= type(k)=="number" and "["..k.."]" or k
            if type(v)=="table" then
                local dotkey= parent--..(type(k)=="number" and key or "."..key)
                if mark[v] then
                    table.insert(assign, mark[v])
                else
                    table.insert(tmp, ser_table(v,dotkey))
                end
            else
                table.insert(tmp, v)
            end
        end
        return table.concat(tmp, delim)
    end
 
    return ser_table(t,"ret")..table.concat(assign," ")
end







UpdateView = class("UpdateView", function()
    return cc.Layer:create()
end)

local scheduler = cc.Director:getInstance():getScheduler()

function UpdateView:create()
	local ret = UpdateView.new()
    ret:init()
	return ret
end

function UpdateView:init()
  --   local link      = "www.a.c"

  -- self.socket     = cc.WebSocket:create(link)

  -- local function wsSendBinaryOpen(strData)

  --   end

  --   --接受到数据，进行解析
  --   local function wsSendBinaryMessage(buffer)
  --   end

  --   local function wsSendBinaryClose(strData)
  --       self.socket:close()
  --       self.socket = nil
        
  --       print("网络连接关闭")
        
  --   end

  --   local function wsSendBinaryError(strData)
  --       self:hideLoading()
  --       self.socket:close()
  --       self.socket = nil
  --       print("网络数据异常" .. strData)
  --   end

  --   if nil ~= self.socket then
  --       self.socket:registerScriptHandler(wsSendBinaryOpen,cc.WEBSOCKET_OPEN)
  --       self.socket:registerScriptHandler(wsSendBinaryMessage,cc.WEBSOCKET_MESSAGE)
  --       self.socket:registerScriptHandler(wsSendBinaryClose,cc.WEBSOCKET_CLOSE)
  --       self.socket:registerScriptHandler(wsSendBinaryError,cc.WEBSOCKET_ERROR)
  --   end
    
	local isUpdate = require "isUpdate"
    if isUpdate.flag then
        self:startUpdate()
    else
        self:startGame()
    end

end

function UpdateView:startUpdate()
    self.lab = cc.LabelTTF:create("正在更新--->", "Arial", 30)
    self.lab:setColor(cc.c3b(255,120,200))
    self.lab:setPosition(display.cx, display.cy+35)
    self:addChild(self.lab)

    self.bg = cc.Sprite:create("update/updateBg.png")
    self.bg:setPosition(display.cx, display.cy - 10)
    self:addChild(self.bg)

    self.Pro = cc.ProgressTimer:create(cc.Sprite:create("update/updateBar.png"))
    self.Pro:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.Pro:setMidpoint(cc.p(0, 0))
    self.Pro:setBarChangeRate(cc.p(1, 0))
    self.Pro:setPosition(display.cx, display.cy - 8)
    self.Pro:setPercentage(0)
    self:addChild(self.Pro)
    self.path = fileUtils:getWritablePath().."pkg"
    HotUpdateUtils.createFile(self.path)
    self.tryCount = 0

    self.funcId = scheduler:scheduleScriptFunc(function(dt)
        self:initAssets()
    end, 1.5, false)
end

function UpdateView:initAssets()
    if self.funcId then
        scheduler:unscheduleScriptEntry(self.funcId)
    end
    self.funcId = nil
    self.Pro:setPercentage(0)
	local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
        	self.lab:setString("正在进入游戏·····")
            self.Pro:setPercentage(100)
            self.funcId = scheduler:scheduleScriptFunc(function(dt)
                self:startGame()
            end, 1.0, false)
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            self.lab:setString("正在重试.....")
            self.tryCount = self.tryCount + 1
            if self.tryCount <= 3 then
                print("try again")
                self.funcId = scheduler:scheduleScriptFunc(function(dt)
                    self:initAssets()
                end, 1.0, false)
            else
                print("try 10 times, but fail")
                self.Pro:setPercentage(100)
                self.funcId = scheduler:scheduleScriptFunc(function(dt)
                    self:startGame()
                end, 1.0, false)
            end
        end
    end

    local function onProgress( percent )
        local progress = string.format("正在更新 %d%%",percent)
        self.Pro:setPercentage(percent)
        if percent < 100 then
        	self.lab:setString(progress)
        else
        	self.lab:setString("正在解压·····")
        end
    end

    local function onSuccess()
        self.lab:setString("正在进入游戏·····")
        
        self.funcId = scheduler:scheduleScriptFunc(function(dt)
            self:startGame()
        end, 1.0, false)
    end
    local PkgPath = "https://raw.githubusercontent.com/zlf921026/code/testUpdate/testUpdate.zip"
    local VerSionPath = "https://raw.githubusercontent.com/zlf921026/code/testUpdate/version"
    if not self.assetsManager then 
        self.assetsManager = cc.AssetsManager:new(PkgPath, VerSionPath, self.path)
	    self.assetsManager:retain()
        self.assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
        self.assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
        self.assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
        self.assetsManager:setConnectionTimeout(3)
    end
    self.assetsManager:update()
end

function UpdateView:startGame()
    if self.funcId then
        scheduler:unscheduleScriptEntry(self.funcId)
    end
    self.funcId = nil
    local allPath = cc.AssetsManager:getAllPath()
    local function removeRepeatData(t)
        local result = {}
        for k,v in pairs(t) do
            if  v ~= "" and not result[v] then
                result[v] = v
            end
        end
        return result
    end
    if allPath ~= "" then
        --有热更，要更新缓存
        local oldPaths = HotUpdateUtils.readDataByKey("allPath")
        if oldPaths then
            oldPaths = oldPaths .. "#"
            local newPaths = oldPaths..allPath
            HotUpdateUtils.writeDataByKey("allPath", newPaths)
        else
            HotUpdateUtils.writeDataByKey("allPath", allPath)
        end
    end

    local searchPaths = fileUtils:getSearchPaths()
    local paths = HotUpdateUtils.readDataByKey("allPath")
    if paths and paths ~= "" then
        local pathTable = removeRepeatData(HotUpdateUtils.split(paths, "#"))
        for k,v in pairs(pathTable) do
            if v ~= "" then
                table.insert(searchPaths, 1, v)
            end
        end
    end
    fileUtils:setSearchPaths(searchPaths)
    self.tryCount = 1
    if self.assetsManager then
        self.assetsManager:release()
        self.assetsManager = nil
    end
    self:removeAllChildren()
    self:initAllFile()
    LayerCtrol:getInstance():open(CmdName.LoginView)
end

function UpdateView:initAllFile()
    require "gameConfig"
    TimerManager.start()
    SceneCtrol:getInstance():run()
end