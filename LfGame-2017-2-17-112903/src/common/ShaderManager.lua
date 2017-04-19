ShaderManager = class("ShaderManager")

function ShaderManager:test(node)
	local vert = "													\n\
attribute vec4 a_position;							\n\
attribute vec2 a_texCoord;							\n\
attribute vec4 a_color;								\n\
													\n\
#ifdef GL_ES										\n\
varying lowp vec4 v_fragmentColor;					\n\
varying mediump vec2 v_texCoord;					\n\
#else												\n\
varying vec4 v_fragmentColor;						\n\
varying vec2 v_texCoord;							\n\
#endif												\n\
													\n\
void main()											\n\
{													\n\
    gl_Position = CC_MVPMatrix * a_position;		\n\
	v_fragmentColor = a_color;						\n\
	v_texCoord = a_texCoord;						\n\
}													\n\
"
    
    local shader = "#ifdef GL_ES\n\
precision mediump float;\n\
#endif\n\
uniform vec2 u_resolution;\n\
\n\
varying vec4 v_fragmentColor;\n\
varying vec2 v_texCoord;\n\
\n\
const float RADIUS = 0.75;\n\
const float SOFTNESS = 0.45;\n\
const vec3 SEPIA = vec3(1.2, 1.0, 0.8);\n\
\n\
void main() {\n\
	vec4 texColor = texture2D(CC_Texture0, v_texCoord);\n\
	vec2 pos = (gl_FragCoord.xy/u_resolution.xy) - 0.5;\n\
	pos.x *= u_resolution.x/u_resolution.y;\n\
	float len = length(pos);\n\
	////gl_FragColor = vec4(texColor.rgb*(1.0-len), 1.0);\n\
	float vignette = smoothstep(RADIUS, RADIUS-SOFTNESS, len);\n\
	//texColor.rgb *= mix(texColor.rgb, texColor.rgb*vignette, 0.5);\n\
	texColor.rgb = mix(texColor.rgb, texColor.rgb*vignette, 0.5);\n\
	//gl_FragColor=texColor;\n\
	//gl_FragColor=texColor*v_fragmentColor;\n\
	//gl_FragColor = vec4(texColor.rgb*(1.0-len), 1);\n\
	float gray = dot(texColor.rgb, vec3(0.299, 0.587, 0.144));\n\
	vec3 sepiaColor = vec3(gray)*SEPIA;\n\
	gl_FragColor = vec4(mix(texColor.rgb, sepiaColor, 0.75), 1.0);\n\
}"

	local pProgram = cc.GLProgram:createWithByteArrays(vert, shader)
    
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
    pProgram:link()
    pProgram:use()
    pProgram:updateUniforms()
    node:setGLProgram(pProgram)
end

function ShaderManager:greyShader(node, reset)
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
 
    --变灰
    local psGrayShader = "#ifdef GL_ES \n" ..
                            "precision mediump float; \n" ..
                            "#endif \n" ..
                            "varying vec4 v_fragmentColor; \n" ..
                            "varying vec2 v_texCoord; \n" ..
                            "void main(void) \n" ..
                            "{ \n" ..
                            "vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
                            "gl_FragColor.xyz = vec3(0.299*c.r + 0.587*c.g +0.114*c.b); \n"..
                            "gl_FragColor.w = c.w; \n"..
                            "}"

    local pszRemoveGrayShader = "#ifdef GL_ES \n" ..  
        "precision mediump float; \n" ..  
        "#endif \n" ..  
        "varying vec4 v_fragmentColor; \n" ..  
        "varying vec2 v_texCoord; \n" ..  
        "void main(void) \n" ..  
        "{ \n" ..  
        "gl_FragColor = texture2D(CC_Texture0, v_texCoord); \n" ..  
        "}"   

    local shader = reset and pszRemoveGrayShader or psGrayShader

    local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource, shader)
    
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
    pProgram:link()
    pProgram:use()
    pProgram:updateUniforms()
    node:setGLProgram(pProgram)
end