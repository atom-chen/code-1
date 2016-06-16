SceneCtrol = class("SceneCtrol")

local instance = nil

local curScene_Name = ""
local curScene = nil

function SceneCtrol:getInstance()
	if not instance then
		instance = SceneCtrol.new()
		Notifier.register(CmdName.MsgBox, function(param)
			ComponentMgr:showMsgBox(param)
		end)
	end
	return instance
end

function SceneCtrol:getCurScene()
	return curScene
end

function SceneCtrol:run()
	curScene_Name = CmdName.UpdateScene
	local scene = cc.Scene:create()
	curScene = scene
	LayerMgr:initAllLayer(scene)
	-- cc.Director:getInstance():runWithScene(scene)
	cc.Director:getInstance():replaceScene(scene)
end

function SceneCtrol:replaceMainScene()
	local scene = cc.Scene:create()
	curScene = scene
	cc.Director:getInstance():replaceScene(scene)
end