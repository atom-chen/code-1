
--版本管理器

VersionManager = {}

function VersionManager:loadServerVersion(luaStr)
    local versionConfigFun = loadstring(luaStr)
    local versionConfig = versionConfigFun()
    
    self._versionConfig = versionConfig
    self._moduleVersionMap = versionConfig.moduleMap or {}
    return versionConfig
end

--版本是否要显示悬浮框 IOS审核特有
function VersionManager:isShowFloatIcon()
    if self._versionConfig == nil then
        return true
    end
    
    if self._versionConfig.isShowFloatIcon == nil then
        return true
    end
    
    return self._versionConfig.isShowFloatIcon
end

--版本是否要显示排行榜IOS审核特有
function VersionManager:isShowRank()
    if self._versionConfig == nil then
        return true
    end

    if self._versionConfig.isShowRank == nil then
        return true
    end

    return self._versionConfig.isShowRank
end

--版本是否要显示CDKey IOS审核特有
function VersionManager:isShowCDKey()
    if self._versionConfig == nil then
        return true
    end

    if self._versionConfig.isShowCDKey == nil then
        return true
    end

    return self._versionConfig.isShowCDKey
end

--获取具体对应的模块版本信息
function VersionManager:getModuleVersionInfo(moduleName)
    local versionMap = self._moduleVersionMap or {}
    return versionMap[moduleName]
end


function VersionManager:getMainVersion()
    if self._versionConfig == nil or  self._versionConfig == 0 then
        return 1
    end
    
    return self._versionConfig.mainVersion
end

function VersionManager:getSubVersion()
    if self._versionConfig == nil or self._versionConfig == 0 then
        return 0
    end

    return self._versionConfig.subVersion
end

--获取版本字符串
function VersionManager:getVersionName()
    if self._versionConfig == nil or self._versionConfig == 0 then
        return "0.0.0.0"
    end
    return self._versionConfig.versionName or "0.0.0.0"
end

function VersionManager:getISBNName()
    local isbn = "文网游备字[2016]M-SLG1470号 \nISBN 978-7-7979-0012-6 \n新广出审[2016]1182号"
    if self._versionConfig == nil or self._versionConfig == 0 then
        return isbn
    end
    return self._versionConfig.isbnName or isbn
end

function VersionManager:getVersionStr()
    return self:getVersionName()
end


function VersionManager:getServerSrcVersion()
    local mainVersion = self:getMainVersion()
    local subVersion = self:getSubVersion()
    local version = mainVersion .. "." .. subVersion
    return version
end

function VersionManager:getPackageInfo(packageName)
    local mainVersion = self:getMainVersion()
    local packageMap = self._versionConfig.packageMap
    local name = mainVersion .. "-" .. packageName
    return packageMap[name]
end

--检查下载后的文件数
function VersionManager:checkDownloadFile(packageName)
    local result = true
    local mainVersion = self:getMainVersion()
    local name = mainVersion .. "-" .. packageName .. ".txt"
    local isExist = cc.FileUtils:getInstance():isFileExist(name)
    if isExist == false then
        result = false  --该文件不存在，更新失败
    else
        local downloadCount = cc.FileUtils:getInstance():getStringFromFile(name)
        local info = self:getPackageInfo(packageName)
        local serverCount = info.fileNum --self._packagesInfo[self._downloadPreName]
        if tonumber(downloadCount) ~= tonumber(serverCount) then
            result = false --数量不一致，更新失败
        end
    end
    
    return result
end














