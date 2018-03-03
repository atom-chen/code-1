--字典
Dictionary = class("Dictionary")

function Dictionary:ctor()
	self.list = {}
end

function Dictionary:create()
	local ret = Dictionary.new()
	return ret
end

function Dictionary:setObject(obj,key)
	if obj then
		self.list[key] = obj
		self.list[key]:retain()
	end
end

function Dictionary:objectForKey(key)
	return self.list[key]
end

function Dictionary:clean(func)
	for _,v in pairs(self.list) do
		if type(func) == "function" then
			func(v)
		end
		v:release()
		v = nil
	end
	self.list = {}
end

function Dictionary:forEach(func)
	for k,v in pairs(self.list) do
		func(v,k)
	end
end

function Dictionary:removeWithKey(key)
	for k,v in pairs(self.list) do
		if string.find(k,key) then
			v:release()
			self.list[k] = nil
		end
	end
end