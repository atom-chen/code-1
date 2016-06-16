Notifier = Notifier or {}

local allCallBack = allCallBack or {}

Notifier.register = function(token, callback)
	if (not token) or (not callback) or (type(callback) ~= "function") then
		print("缺少必要参数")
		return 
	end
	if allCallBack[token] then
		if type(allCallBack[token]) == "table" then
			table.insert(allCallBack[token], callback)
		else
			local oldFunc = allCallBack[token]
			allCallBack[token] = {}
			table.insert(allCallBack[token], callback)
			table.insert(allCallBack[token], oldFunc)
		end
	else
		allCallBack[token] = callback
	end
end

Notifier.remove = function(token)
	if allCallBack[token] then
		allCallBack[token] = nil
	end
end

Notifier.dispatch = function(token, param)
	if not allCallBack[token] then
		print(token.."没有注册")
		return
	end

	if type(allCallBack[token]) == "table" then
		for k,v in pairs(allCallBack[token]) do
			v(param)
		end
	else
		allCallBack[token](param)
	end
end

Notifier.clear = function()
	for k,v in pairs(allCallBack) do
		Notifier.remove(k)
	end
	allCallBack = {}
end