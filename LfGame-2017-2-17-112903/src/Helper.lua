function updateChatView(text)
	print("server text==",text)
	Notifier.dispatch("chatEvent", text)
end

function showTips(args)
	print("reConnect",args)
	Notifier.dispatch(args)
end