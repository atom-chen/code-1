UpdateView = class("UpdateView", function()
    return cc.Layer:create()
end)

function UpdateView:create()
	local ret = UpdateView.new()
    ret:init()
	return ret
end

function UpdateView:init()
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
    self.path = cc.FileUtils:getInstance():getWritablePath().."pkg"
    Utils.createFile(self.path)
    self.tryCount = 0
    TimerManager.addTimer(2000, function()
    	self:initAssets()
    end, false)

end

function UpdateView:initAssets()

	local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
        	self.lab:setString("no new version")
        	self:startGame()
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            self.lab:setString("network error")
            self.tryCount = self.tryCount + 1
            if self.tryCount <= 10 then
                print("try again")
                self:initAssets()
            else
                print("try 10 times, but fail")
                self:startGame()
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
        
        TimerManager.addTimer(1000, function()
            self:startGame()
        end, false)
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
    local allPath = cc.AssetsManager:getAllPath()
    local function removeRepeatData(t)
        local result = {}
        for k,v in pairs(t) do
            if not result[v] and v ~= "" then
                result[v] = v
            end
        end
  return result
    end
    if allPath ~= "" then
        --有热更，要更新缓存
        local oldPaths = Utils.readDataByKey("allPath")
        if oldPaths then
            oldPaths = oldPaths .. "#"
            local newPaths = removeRepeatData(Utils.split(oldPaths..allPath, "#")) 
            local savePaths = Utils.otherSerialize(newPaths, "#")
            Utils.writeDataByKey("allPath", savePaths)
        else
            Utils.writeDataByKey("allPath", allPath)
        end
    end

    local fileUtils = cc.FileUtils:getInstance()
    local searchPaths = fileUtils:getSearchPaths()
    local paths = Utils.readDataByKey("allPath")
    if paths and paths ~= "" then
        for k,v in pairs(Utils.split(paths, "#")) do
            if v ~= "" then
                print("添加搜索路径---->",v)
                table.insert(searchPaths, 1, v)
            end
        end
    end
    fileUtils:setSearchPaths(searchPaths)
    self:initAllFile()
    self.assetsManager:release()
    self.assetsManager = nil
    self.tryCount = 1
    self:removeAllChildren()
    -- LayerCtrol:getInstance():close(self.name)
    LayerCtrol:getInstance():open(CmdName.LoginView)
end

function UpdateView:initAllFile()
    cc.FileUtils:getInstance():addSearchPath("src/layer")
    cc.FileUtils:getInstance():addSearchPath("src/component")
    cc.FileUtils:getInstance():addSearchPath("src/data")
    cc.FileUtils:getInstance():addSearchPath("src/effect")
    cc.FileUtils:getInstance():addSearchPath("src/login")

    require "CmdName"
    require "ProtoBase"
    require "Common"
    require "CommonResMgr"
    require "Notifier"
    require "SceneCtrol"
    require "LayerCtrol"
    require "LayerBase"
    require "Dictionary"
    require "LayerMgr"
    require "RichLabel"
    require "MsgBox"
    require "Alert"
    require "ComponentMgr"
    require "EffectManager"
    require "EffectNode"

    SceneCtrol:getInstance():run()
end