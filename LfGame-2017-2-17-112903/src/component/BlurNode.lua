BlurNode = BlurNode or {}


-- 截全屏
function BlurNode:screenshot()
    local winSize = cc.Director:getInstance():getWinSize()
    local renderTexture = cc.RenderTexture:create(winSize.width, winSize.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, gl.DEPTH24_STENCIL8_OES)
    --renderTexture:setPosition(cc.p(winSize.width / 2, winSize.height / 2))
    renderTexture:begin()
    cc.Director:getInstance():getRunningScene():visit()
    renderTexture:endToLua()
    renderTexture:retain()
    return renderTexture
end

-- 节点模糊
-- @param  node [2D node] 参数
-- @param  blurRadius [int] 半径
-- @param  sampleNum [] 参数
function BlurNode:nodeBlur(node, blurRadius, sampleNum)
    --模糊处理
    local vertDefaultSource = "\n"..
                           "attribute vec4 a_position; \n" ..
                           "attribute vec2 a_texCoord; \n" ..
                           "attribute vec4 a_color; \n"..                                                    
                           "#ifdef GL_ES  \n"..
                           "varying lowp vec4 v_fragmentColor;\n"..
                           "varying mediump vec2 v_texCoord;\n"..
                           "#else                      \n" ..
                           "varying vec4 v_fragmentColor; \n" ..
                           "varying vec2 v_texCoord;  \n"..
                           "#endif    \n"..
                           "void main() \n"..
                           "{\n" ..
                            "gl_Position = CC_PMatrix * a_position; \n"..
                           "v_fragmentColor = a_color;\n"..
                           "v_texCoord = a_texCoord;\n"..
                           "}"
        
    local fileUtiles = cc.FileUtils:getInstance()
    local size = node:getTexture():getContentSizeInPixels()
    local fragSource = fileUtiles:getStringFromFile("shader/example_Blur.fsh")
    local program = cc.GLProgram:createWithByteArrays(vertDefaultSource, fragSource)
    local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(program)
    node:setGLProgramState(glProgramState)
    --设置模糊参数
    node:getGLProgramState():setUniformVec2("resolution", cc.p(size.width, size.height))
    node:getGLProgramState():setUniformFloat("blurRadius", tonumber(sampleNum) or 8)
    node:getGLProgramState():setUniformFloat("sampleNum", tonumber(sampleNum)  or 8)

end