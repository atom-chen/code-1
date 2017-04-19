Utils = Utils or {}

local fileUtils = cc.FileUtils:getInstance()

--是否中文
Utils.isCn = function(str)
	return str:byte() > 128
end

--字符串根据指定符号，拆成table并返回
Utils.split = function(str, delim)
	assert(type (delim) == "string" and string.len (delim) > 0, "bad delimiter")
	local start = 1
  	local results = {}

  	while true do
    	local pos = string.find(str, delim, start, true)
    	if not pos then
      		break
    	end
    	table.insert(results, string.sub(str, start, pos - 1))
    	start = pos + string.len(delim)
  	end

  	table.insert (results, string.sub(str, start))
  	return results
end

--[[
	--不适用protobuf结构的table
    序列化表, 可以通过loadstring反序列化
    反序列化：loadstring(Utils.serialize(t))()这样可得到序列化前的table
    @return string
]]
Utils.serialize = function(t)

  local mark={}
	local assign={}
	
	local function ser_table(tbl,parent)
		mark[tbl]=parent
		local tmp={}
		for k,v in pairs(tbl) do
			local key= type(k)=="number" and "["..k.."]" or k
			if type(v)=="table" then
				local dotkey= parent..(type(k)=="number" and key or "."..key)
				if mark[v] then
					table.insert(assign,dotkey.."="..mark[v])
				else
					table.insert(tmp, key.."="..ser_table(v,dotkey))
				end
			else
				table.insert(tmp, key.."="..v)
			end
		end
		return "{"..table.concat(tmp,",").."}"
	end
 
	return ser_table(t,"ret")..table.concat(assign," ")
end

--字符转颜色 00ff00 转 cc.c3b
Utils.str2Color = function(str)
  str = string.gsub(str,"#","")
  return cc.c3b(tonumber(string.sub(str,1,2),16),
                 tonumber(string.sub(str,3,4),16),
                 tonumber(string.sub(str,5,6),16))
end

--将字符串拆开，一个个放进table并返回,主要用中英混合的
Utils.separate = function(str)

  	local function SubUTF8String(s, n)  
    	local dropping = string.byte(s, n+1)  
    	if not dropping then
    	 	return s 
    	end  
    	if dropping >= 128 and dropping < 192 then  
      		return SubUTF8String(s, n-1)  
    	end  
    	return string.sub(s, 1, n)  
  	end  

  	local i = 1
  	local lastStr = ""
  	local curStr = ""
  	local ret = {}
  	while i <= #str do
    	curStr = SubUTF8String(str,i)
    	if lastStr ~= curStr then
      		table.insert(ret,string.sub(curStr,string.len(lastStr)+1))
      		lastStr = curStr
    	end
    	i = i + 1
  	end
  	return ret
end

--删除指定目录下的文件夹
Utils.removeFile = function(path)
  path = Utils.checkPath(path)
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
Utils.createFile = function(path, removeOld)
    path = Utils.checkPath(path)
    if removeOld then
        Utils.removeFile(path)
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

Utils.checkPath = function(path)
  path = string.reverse(path)
  local pos = string.find(path, "/")
  if pos ~= 1 then
    path = "/"..path
  end
  path = string.reverse(path)
  return path
end

Utils.findFile = function(path)
   local file = io.open(path, "rb")
   if file then file:close() end
   return file ~= nil
end

Utils.getTblLen = function(tableValue)
  local tableLength = 0
  
  for k, v in pairs(tableValue) do
    tableLength = tableLength + 1
  end
  
  return tableLength
end

Utils.isSameColor = function(color1,color2)
    return color1.r == color2.r and 
           color1.g == color2.g and
           color1.b == color2.b
end

Utils.stringTotable = function(str)
  cclog("text===>>%s", str)
  local ret = loadstring("return "..str)()  
  return ret
end

--打乱数组
Utils.shuffleList = function(list)
  local len = #list

  for i = 1, len do
    local randomIndex = math.random(1, len)
    list[i], list[randomIndex] = list[randomIndex], list[i]
  end
end

--四舍五入
Utils.round = function(value)
  local temp_int_part,temp_dec_part = math.modf(value)

  if  temp_dec_part>= 0.5 then
    return temp_int_part+1
  else
    return temp_int_part
  end
end

--key-value转数组
Utils.map2list = function(map, isSort, key)
    local list = {}
        for _, value in pairs(map) do
            table.insert(list,value)
        end
    if isSort then
      table.sort(list, function(a, b)
        if key then
          return a[key] < b[key]
        else
          return a < b
        end
      end)
    end
    return list
end

Utils.log = function(...)
  local data = string.format(...)
  print(data)
  local date = os.date("%x")
  date = string.gsub(date, "/", "")
  local file_name = fileUtils:getWritablePath()..date..".log"
  local file = assert(io.open(file_name, 'a'))
  file:write(os.date("%c").."===>>"..data.."\n")
  file:close()
end

Utils.encode = function(source_str)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local s64 = ''
    local str = source_str

    while #str > 0 do
        local bytes_num = 0
        local buf = 0

        for byte_cnt=1,3 do
            buf = (buf * 256)
            if #str > 0 then
                buf = buf + string.byte(str, 1, 1)
                str = string.sub(str, 2)
                bytes_num = bytes_num + 1
            end
        end

        for group_cnt=1,(bytes_num+1) do
            b64char = math.fmod(math.floor(buf/262144), 64) + 1
            s64 = s64 .. string.sub(b64chars, b64char, b64char)
            buf = buf * 64
        end

        for fill_cnt=1,(3-bytes_num) do
            s64 = s64 .. '='
        end
    end

    return s64
end

Utils.decode = function(str64)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local temp={}
    for i=1,64 do
        temp[string.sub(b64chars,i,i)] = i
    end
    temp['=']=0
    local str=""
    for i=1,#str64,4 do
        if i>#str64 then
            break
        end
        local data = 0
        local str_count=0
        for j=0,3 do
            local str1=string.sub(str64,i+j,i+j)
            if not temp[str1] then
                return
            end
            if temp[str1] < 1 then
                data = data * 64
            else
                data = data * 64 + temp[str1]-1
                str_count = str_count + 1
            end
        end
        for j=16,0,-8 do
            if str_count > 0 then
                str=str..string.char(math.floor(data/math.pow(2,j)))
                data=math.mod(data,math.pow(2,j))
                str_count = str_count - 1
            end
        end
    end
    return str
end

Utils.writeDataByKey = function(key, value)
  local base64Value = Utils.encode(value)
  local base64Key = string.format(CmdName.userDefaultKey, key)
  cc.UserDefault:getInstance():setStringForKey(base64Key, base64Value)
end

Utils.readDataByKey = function(key)

  local base64Key = string.format(CmdName.userDefaultKey, key)
  local result = cc.UserDefault:getInstance():getStringForKey(base64Key)
  return Utils.decode(result)
end

Utils.otherSerialize = function(t, delim)
  delim = delim or ""
  local mark={}
    local assign={}
    
    local function ser_table(tbl,parent)
        mark[tbl]=parent
        local tmp={}
        for k,v in pairs(tbl) do
            local key= type(k)=="number" and "["..k.."]" or k
            if type(v)=="table" then
                local dotkey= parent--..(type(k)=="number" and key or "."..key)
                if mark[v] then
                    table.insert(assign, mark[v])
                else
                    table.insert(tmp, ser_table(v,dotkey))
                end
            else
                table.insert(tmp, v)
            end
        end
        return table.concat(tmp, delim)
    end
 
    return ser_table(t,"ret")..table.concat(assign," ")
end


Utils.h2b = {
    ["0"] = 0,
    ["1"] = 1,
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
    ["5"] = 5,
    ["6"] = 6,
    ["7"] = 7,
    ["8"] = 8,
    ["9"] = 9,
    ["A"] = 10,
    ["B"] = 11,
    ["C"] = 12,
    ["D"] = 13,
    ["E"] = 14,
    ["F"] = 15
}

Utils.hex2bin = function( hexstr )
    local s = string.gsub(hexstr, "(.)(.)%s", function ( h, l )
         return string.char(Utils.h2b[h]*16+Utils.h2b[l])
    end)
    return s
end

Utils.bin2hex = function(s)
    s=string.gsub(s,"(.)",function (x) return string.format("%02X ",string.byte(x)) end)
    return s
end

--做一个fix64出来
Utils.int32ToFixed64 = function(int32)
    local byteArray = ByteArray.new()
    byteArray:writeInt(int32)
    byteArray:writeInt(0)
    local fix64 = byteArray:toString()
    return fix64
end