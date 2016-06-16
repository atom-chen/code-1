
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "init"
local function main()
    print(collectgarbage("count"))
	collectgarbage("collect")
    print(collectgarbage("count")/1024)
    Utils.log(collectgarbage("count")/1024/1024)
	collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
	math.randomseed(os.time())
    TimerManager.start()
    cc.Director:getInstance():setDisplayStats(true)
    local scene = cc.Scene:create()
    local view = UpdateView:create()
    scene:addChild(view)
    cc.Director:getInstance():runWithScene(scene)
    -- SceneCtrol:getInstance():run()
    -- LayerCtrol:getInstance():open(CmdName.UpdateView)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
