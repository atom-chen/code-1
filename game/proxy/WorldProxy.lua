WorldProxy = class("WorldProxy", BasicProxy)

function WorldProxy:ctor()
    WorldProxy.super.ctor(self)
    self.proxyName = GameProxys.World

    self:initData()
end

function WorldProxy:resetAttr()
    self:initData()
end

function WorldProxy:initData()
	self._lastMoveTileX = -1
    self._lastMoveTileY = -1

    self._realTileList = {}
end

function WorldProxy:setLastMoveTile(tileX, tileY)
    self._lastMoveTileX = tileX
    self._lastMoveTileY = tileY
end

function WorldProxy:getLastMoveTile()
    return self._lastMoveTileX, self._lastMoveTileY
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--地图资源点生成机制
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 种子 表
function WorldProxy:getRandomConfig(seedID)
	local config = ConfigDataManager:getConfigById("ParamBankConfig", seedID)
	return config
end

-- 地图库 表
function WorldProxy:getTileConfig(ID)
	-- if self._mapBankConfig == nil then
	-- 	self._mapBankConfig = ConfigDataManager:getConfigData("MapBankConfig")
	-- end
	-- local config = self._mapBankConfig[ID]

	local config = ConfigDataManager:getConfigById("MapBankConfig", ID)
	return config
end

-- 将资源类型和等级转换成字段：resPointId
function WorldProxy:getResPointId(type,level)
	local ID = type * 1000 + level
	return ID
end

-- -- 根据索引读取随机数
-- function WorldProxy:getRandomByIndex(randomList, index)
-- 	local random = randomList[index]
-- 	return random
-- end

-- 读取资源点数据
-- function WorldProxy:getTile(randomList, group, index)
function WorldProxy:getTile(randomList, x, y)

	-- local randnum = self:getRandomByIndex(randomList, index)
	local group = self:getGroupByPos(x,y)
	local index = self:getIndexByPos(x,y)
	local randnum = randomList[index]

	if randnum == nil then
		logger:error("... randnum is nil (index=%d)",index)
		return nil
	end

	local ID = group * 10000 + randnum  --转换成ID
	local realTile = self:getTileConfig(ID)
	if realTile then
		realTile.x = x
		realTile.y = y
		realTile.resPointId = self:getResPointId(realTile.restype,realTile.level)
		return realTile
	else
		logger:error("... 格子 realTile is nil (ID=%d,index=%d)",ID,index)
		return nil
	end
end


-- 线性同余法生成随机数
-- seed:[num]种子
-- b:[num]参数B
-- c:[num]参数C
-- m:[num]参数M
-- n:[num]生成的随机数个数
function WorldProxy:getRandomList(seed, b, c, m, n)
	local randomList = {}
	local index = 1
	local a0 = seed
	local an = a0

	while (index <= n) do
		local random = (b * an + c) % m
		table.insert(randomList,random)
		an = random
		index = index + 1
	end

	return randomList
end

-- 将坐标转换成随机数的索引
function WorldProxy:getIndexByPos(x,y)
	local index = x * 600 + y + 1
	return index
end

-- 将坐标转换成一个key
function WorldProxy:getKeyByPos(x,y)
	local key = x.."_"..y
	-- local key = x * 100 + y
	return key
end

-- 根据资源类型返回格子类型
function WorldProxy:getTileTypeByResType(restype)
	local tileType
	if restype >= 1 and restype <= 5 then
		tileType = WorldTileType.Resource  --资源点
	else
		tileType = WorldTileType.Empty  --空地
	end
	return tileType
end

-- 根据当前坐标获取对应的组
-- 废弃读表"MapGenerateConfig"判定方法，因为读表判定太慢(耗时5~6秒)
--TODO 要让策划新建配表
function WorldProxy:getGroupByPos(curPox, curPoy)
	if self._groupAreaList == nil then
		self._groupAreaList = {}
		self._groupAreaList[1] = {ID = 1, xorigin = 250, xend = 349, yorigin = 250, yend = 359, group = 13}
		self._groupAreaList[2] = {ID = 2, xorigin = 150, xend = 449, yorigin = 150, yend = 459, group = 12}
		self._groupAreaList[3] = {ID = 3, xorigin = 000, xend = 599, yorigin = 000, yend = 599, group = 11}
	end

	local group = 11  --生成组默认是11
	for i=1,3 do
		local config = self._groupAreaList[i]
		if curPox >= config.xorigin and curPox <= config.xend and curPoy >= config.yorigin and curPoy <= config.yend then
			return config.group
		end
	end
	return group
end

--[[
	生成逻辑：
	1.根据当前服的种子id，匹配种子，并生成随机数
	2.根据生成的随机数和当前位置坐标，过滤资源点
	3.每次登陆客户端都重新生成
]]
function WorldProxy:createRandomData(seedID)
	if seedID == nil or seedID < 0 then
		logger:error("... World seed type id is nil. ")  --种子id有误
		return
	end
	
	if self._seedID == nil or self._seedID ~= seedID then
		self._seedID = seedID
	elseif table.size(self._realTileList) > 0 or self._seedID == seedID then  --避免重复创建
		logger:info("... Tile list already been created. (done)")
		return
	end

	local randomConfig = self:getRandomConfig(seedID)
	if randomConfig == nil then
		logger:error("... RandomConfig is nil (seedID=%d)",seedID)  --种子id匹配不到种子
		return
	end


	local row,col = 600,600  --行，列
	local tileCount = col*row  --随机数个数
	local randomList = self:getRandomList(randomConfig.seed, randomConfig.parameterB, randomConfig.parameterC, randomConfig.parameterM, tileCount)
	
	local beginTime = os.clock()
	logger:info(string.format("0000---not-error--LUA VM MEMORY USED : %0.2f KB", collectgarbage("count")))

	local tmpList = {}
	for i=1,row do
		for j=1,col do
			local tmpX = i - 1
			local tmpY = j - 1
			local realTile = self:getTile(randomList, tmpX, tmpY)
			if realTile then				
				--TODO 用KEY做下标，表格插入数据速度比较慢,原因是字符串拼接耗时导致
				local key = self:getKeyByPos(tmpX,tmpY)
				self._realTileList[key] = realTile

				-- realTile.key = self:getKeyByPos(tmpX,tmpY)
				-- table.insert(self._realTileList,realTile) 
				-- table.insert(tmpList,realTile)

			else
				logger:error("... 生成错误资源点 tile : x=%d,y=%d",tmpX,tmpY)
			end

		end
	end

	logger:error("... 世界地图生成耗时(s) : %2.5f",os.clock() - beginTime)  --生成耗时3~4秒 ！！！
	logger:info(string.format("1111---not-error--LUA VM MEMORY USED : %0.2f KB", collectgarbage("count")))

	-- self:testAsync()
end

-------------------------------------------------------------------------------
function WorldProxy:testAsync()
	local index = 0
	local function createCallback()
		index = index + 1
		-- print("...  测试异步 testAsync ... ",index)
	end

	local time = os.clock()
	local url = "ui/littleIcon_ui_resouce_big_0"..TextureManager.file_type
	for i=1,360000 do
		cc.Director:getInstance():getTextureCache():addImageAsync(url, createCallback)
	end

	print(".... testAsync time ",os.clock() - time)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 对外接口
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 通过坐标获取tile数据
function WorldProxy:getTileByPos(x,y)
	if x == nil or y == nil then
		logger:info("can't get the tile by (%d,%d).",x,y)
		return nil
	end

	local key = self:getKeyByPos(x,y)
	return self._realTileList[key]
end


---------------------
-- 拖动地图的时候本地手动刷新资源点显示
-- 其他格子类型等协议回来再刷新
function WorldProxy:onGetResTileInfos(x,y)
	-- local time = os.clock()

    local allResTiles = {}
    local dt = 4
    for i=x - dt, x + dt do
        for j=y - dt, y + dt do
        	if i < 0 or j < 0 then
        		break
        	end
			local resInfo = self:getTileByPos(i,j)
            local tileType = self:getTileTypeByResType(resInfo.restype)
            if tileType == WorldTileType.Resource then  --只匹配资源点，空地不要了
    	        local worldTileInfo = {}
	            worldTileInfo.x = i
	            worldTileInfo.y = j
	            worldTileInfo.buildingInfo = {}
	            worldTileInfo.tileType = tileType
	            worldTileInfo.resInfo = resInfo
	            table.insert(allResTiles, worldTileInfo)
            end
        end
    end

    -- print("... time",os.clock() - time)
    -- print("... allResTiles size",table.size(allResTiles))
    return allResTiles
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------