
FunctionShield = {}
FunctionShield.TALENT = 1  --国策

--功能屏蔽表
--用来处理一些版本功能的特殊逻辑
--true则表示屏蔽了
FunctionShieldConfig = {}

FunctionShieldConfig[FunctionShield.TALENT] = false  --国策


--功能是否被屏蔽掉了
--
function FunctionShieldConfig:isShield(id)
	return FunctionShieldConfig[id]
end