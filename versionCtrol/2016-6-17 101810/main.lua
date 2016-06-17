
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "init"
local function main()
	math.randomseed(os.time()) 
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
