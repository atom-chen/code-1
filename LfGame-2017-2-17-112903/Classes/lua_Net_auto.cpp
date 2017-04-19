#include "lua_Net_auto.hpp"
#include "Net.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_cocos2dx_net_Net_getNetworkStatus(lua_State* tolua_S)
{
    int argc = 0;
    Net* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Net",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Net*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_net_Net_getNetworkStatus'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_getNetworkStatus'", nullptr);
            return 0;
        }
        int ret = cobj->getNetworkStatus();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Net:getNetworkStatus",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_net_Net_getNetworkStatus'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_net_Net_sendProto(lua_State* tolua_S)
{
    int argc = 0;
    Net* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Net",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Net*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_net_Net_sendProto'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "Net:sendProto");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_sendProto'", nullptr);
            return 0;
        }
        cobj->sendProto(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Net:sendProto",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_net_Net_sendProto'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_net_Net_startConnect(lua_State* tolua_S)
{
    int argc = 0;
    Net* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Net",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Net*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_net_Net_startConnect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_startConnect'", nullptr);
            return 0;
        }
        cobj->startConnect();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Net:startConnect",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_net_Net_startConnect'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_net_Net_initNetWork(lua_State* tolua_S)
{
    int argc = 0;
    Net* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Net",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Net*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_net_Net_initNetWork'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_initNetWork'", nullptr);
            return 0;
        }
        bool ret = cobj->initNetWork();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "Net:initNetWork");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_initNetWork'", nullptr);
            return 0;
        }
        bool ret = cobj->initNetWork(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "Net:initNetWork");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "Net:initNetWork");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_initNetWork'", nullptr);
            return 0;
        }
        bool ret = cobj->initNetWork(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Net:initNetWork",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_net_Net_initNetWork'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_net_Net_wakeUpRecv(lua_State* tolua_S)
{
    int argc = 0;
    Net* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Net",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Net*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_net_Net_wakeUpRecv'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_wakeUpRecv'", nullptr);
            return 0;
        }
        cobj->wakeUpRecv();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Net:wakeUpRecv",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_net_Net_wakeUpRecv'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_net_Net_setNetworkStatus(lua_State* tolua_S)
{
    int argc = 0;
    Net* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Net",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Net*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_net_Net_setNetworkStatus'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Net:setNetworkStatus");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_setNetworkStatus'", nullptr);
            return 0;
        }
        cobj->setNetworkStatus(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Net:setNetworkStatus",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_net_Net_setNetworkStatus'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_net_Net_close(lua_State* tolua_S)
{
    int argc = 0;
    Net* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Net",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Net*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_net_Net_close'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_close'", nullptr);
            return 0;
        }
        cobj->close();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Net:close",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_net_Net_close'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_net_Net_destoryIntancs(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Net",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_destoryIntancs'", nullptr);
            return 0;
        }
        Net::destoryIntancs();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Net:destoryIntancs",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_net_Net_destoryIntancs'.",&tolua_err);
#endif
    return 0;
}
int lua_cocos2dx_net_Net_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Net",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_net_Net_getInstance'", nullptr);
            return 0;
        }
        Net* ret = Net::getInstance();
        object_to_luaval<Net>(tolua_S, "Net",(Net*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Net:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_net_Net_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_cocos2dx_net_Net_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Net)");
    return 0;
}

int lua_register_cocos2dx_net_Net(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"Net");
    tolua_cclass(tolua_S,"Net","Net","",nullptr);

    tolua_beginmodule(tolua_S,"Net");
        tolua_function(tolua_S,"getNetworkStatus",lua_cocos2dx_net_Net_getNetworkStatus);
        tolua_function(tolua_S,"sendProto",lua_cocos2dx_net_Net_sendProto);
        tolua_function(tolua_S,"startConnect",lua_cocos2dx_net_Net_startConnect);
        tolua_function(tolua_S,"initNetWork",lua_cocos2dx_net_Net_initNetWork);
        tolua_function(tolua_S,"wakeUpRecv",lua_cocos2dx_net_Net_wakeUpRecv);
        tolua_function(tolua_S,"setNetworkStatus",lua_cocos2dx_net_Net_setNetworkStatus);
        tolua_function(tolua_S,"close",lua_cocos2dx_net_Net_close);
        tolua_function(tolua_S,"destoryIntancs", lua_cocos2dx_net_Net_destoryIntancs);
        tolua_function(tolua_S,"getInstance", lua_cocos2dx_net_Net_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(Net).name();
    g_luaType[typeName] = "Net";
    g_typeCast["Net"] = "Net";
    return 1;
}
TOLUA_API int register_all_cocos2dx_net(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_cocos2dx_net_Net(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

