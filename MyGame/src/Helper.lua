function updateChatView(text)
	print("text===",text)
	Notifier.dispatch("chatEvent", text)
end

function showTips(args)
	print("args===",args)
	Notifier.dispatch(args)
end

function onReciveProto( data )
	print( "args===" , data )
end