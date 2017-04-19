local GetUpdateState = {}

function GetUpdateState:getState(callBack)

	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr:open("GET", "https://raw.githubusercontent.com/zlf921026/code/testUpdate/isUpdate")


	local function onReadyStateChange()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
			callBack(tonumber(xhr.response) == 1)
			print("是否更新-->", xhr.response)
		else
			print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
			callBack()
		end
    end

	xhr:registerScriptHandler(onReadyStateChange)
   	xhr:send()
end

return GetUpdateState