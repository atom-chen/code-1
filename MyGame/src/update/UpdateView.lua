local HotUpdateUtils = HotUpdateUtils or {}

local fileUtils = cc.FileUtils:getInstance()

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

	local isUpdate = require "isUpdate"
    print(isUpdate)
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

    print(self.funcId)
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
            if self.tryCount <= 10 then
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
    local searchPaths = fileUtils:getSearchPaths()
    local resFile = self.path .. "/res"
    table.insert(searchPaths, 1, resFile)
    local srcFile = self.path .. "/src"
    table.insert(searchPaths, 1, srcFile)
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
    CommonResMgr:getInstance():loadRes("common/common.plist")
    CommonResMgr:getInstance():loadRes("common/gui.plist")
    SceneCtrol:getInstance():run()
end