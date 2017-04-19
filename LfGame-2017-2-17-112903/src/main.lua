
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath("src/cocos")
cc.FileUtils:getInstance():addSearchPath("src/update")

require "config"
require "init"
require "json"


local function main()

	local function callback(state)
		if state == nil then
			print("无法获取网络数据？？网络不行，那直接进入游戏")
		else
			print("state==",state)
		end
	end

	math.randomseed(os.time()) 
    cc.Director:getInstance():setDisplayStats(true)

    GetUpdateState = require "GetUpdateState"
    GetUpdateState:getState(callback)

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
