local fileUtils = cc.FileUtils:getInstance()
fileUtils:addSearchPath("src/common")
fileUtils:addSearchPath("src/layer")
fileUtils:addSearchPath("src/component")
fileUtils:addSearchPath("src/net")
fileUtils:addSearchPath("src/proto")
fileUtils:addSearchPath("src/data")
fileUtils:addSearchPath("src/effect")
fileUtils:addSearchPath("src/login")
fileUtils:addSearchPath("src/protobuf")

require "CmdName"
require "LayerConfig"
require "ShaderManager"
require "ByteArray"
require "Utils"
require "Queue"
require "TimerManager"
require "ProtoBase"
require "Common"
require "CommonResMgr"
require "Notifier"
require "SocketTCP"
require "protobuf"
require "NetWorkManager"
require "SceneCtrol"
require "LayerCtrol"
require "LayerBase"
require "Dictionary"
require "LayerMgr"
require "RichLabel"
require "MsgBox"
require "Alert"
require "ComponentMgr"
require "UIExpandListView"
require "EffectManager"
require "EffectNode"

print(collectgarbage("count"))
collectgarbage("collect")
print(collectgarbage("count")/1024)
Utils.log(collectgarbage("count")/1024/1024)
collectgarbage("setpause", 100)
collectgarbage("setstepmul", 5000)