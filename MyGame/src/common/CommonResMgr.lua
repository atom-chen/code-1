CommonResMgr = class("CommonResMgr")

CommonResMgr.allRes = nil

local instance = nil

function CommonResMgr:ctor()
	self.allRes = {}
end

function CommonResMgr:getInstance()
	if not instance then
		instance = CommonResMgr.new()
	end
	return instance
end

function CommonResMgr:loadRes(plist)
	if self.allRes[plist] then
		print(plist.."已经加载过")
		return
	end
	if not instance:getFilePath(plist) then
		return
	end 
	print("load res name is: "..plist)
	self.allRes[plist] = true
	cc.SpriteFrameCache:getInstance():addSpriteFrames(plist)
end

function CommonResMgr:removeRes(plist)
	if not self.allRes[plist] then
		print(plist.."没加载过")
		return
	end
	if not instance:getFilePath(plist) then
		return
	end 
	self.allRes[plist] = nil
	print("删除spriteFrame name===",plist)
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(plist)
end

function CommonResMgr:getFilePath(file)
	local result = true
	local path = cc.FileUtils:getInstance():fullPathForFilename(file)
	if path == "" or (not path) then
		print("找不到文件==>>"..file)
		result = false
	end 
	return result
end

function CommonResMgr:removeUnUse()
	cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

function CommonResMgr:clear()
	for k,v in pairs(self.allRes) do
		instance:removeRes(v)
	end
	cc.SpriteFrameCache:getInstance():removeSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeAllTextures()
    self.allRes = {}
end