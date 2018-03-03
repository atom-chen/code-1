
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath("src/cocos")
cc.FileUtils:getInstance():addSearchPath("src/update")

require "config"
require "init"

local function initAllFile()
    require "gameConfig"
    TimerManager.start()
    CommonResMgr:getInstance():loadRes("common/common.plist")
    CommonResMgr:getInstance():loadRes("common/gui.plist")
    SceneCtrol:getInstance():run()
end

local function startGame()
	local fileUtils = cc.FileUtils:getInstance()
    local path = fileUtils:getWritablePath().."pkg"
    local searchPaths = fileUtils:getSearchPaths()
    local resFile = path .. "/res"
    table.insert(searchPaths, 1, resFile)
    local srcFile = path .. "/src"
    table.insert(searchPaths, 1, srcFile)
    fileUtils:setSearchPaths(searchPaths)
    initAllFile()
    NetWorkManager:getInstance():initNetWorkEvent()
    -- NetWorkManager:getInstance():initWebSocket( IP , PORT )
    LayerCtrol:getInstance():open(CmdName.LoginView)
end


local function main()
	math.randomseed(os.time()) 
    cc.Director:getInstance():setDisplayStats(true)
    local isUpdate = require "isUpdate"
    -- Net:getInstance():initNetWork( "223.73.57.208" , 8765 )
    -- require "NetChannel"
    if isUpdate.flag then
        local scene = cc.Scene:create()
	    local view = UpdateView:create()
	    scene:addChild(view)
        display.runScene( scene )
    else
        startGame()
    end
    -- local z = NetChannel.new()
    -- NetWorkManager:getInstance():initChannel()





end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
