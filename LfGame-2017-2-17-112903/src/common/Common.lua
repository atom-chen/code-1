Common = class("Common")

local instance = nil

function Common:getInstance()
	if not instance then
		instance = Common.new()
	end
	return instance
end

--读表数据，大数据
function Common:getExcelData(excelName)
	local data = ProtoDataUnpack:create(excelName)
	return data
end

--读表数据，通过大数据来读小数据，相当于table嵌套
function Common:getChildData(parent, childName)
	local data = parent:getSheetByName(childName)
	return data
end
