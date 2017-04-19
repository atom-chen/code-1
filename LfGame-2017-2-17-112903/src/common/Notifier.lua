Notifier = Notifier or {}

local allCallBack = allCallBack or {}


Notifier.register = function(token, callback, obj)
	if (not token) or type(callback) ~= "function" then
		print("缺少必要参数")
		return 
	end
	allCallBack[token] = allCallBack[token] or {}

	local message = {}
	message.callback = callback
	message.obj = obj
	table.insert(allCallBack[token], message)
end

Notifier.remove = function(token)
	if allCallBack[token] then
		allCallBack[token] = nil
	end
end

Notifier.dispatch = function(token, param)
	if type(allCallBack[token]) ~= "table" then
		print(token, "没有注册")
		return
	end

	for k,v in pairs(allCallBack[token]) do
		if v.obj ~= nil then
			v.callback(v.obj, param)
		else
			v.callback(param)
		end
	end
end

Notifier.clear = function()
	for k,v in pairs(allCallBack) do
		Notifier.remove(k)
	end
	allCallBack = {}
end