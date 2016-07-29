#include "lua_cocos2dx_networkmanager_auto.hpp"
#include "NetWorkManager.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_cocos2dx_networkmanager_NetWorkManager_sendData(lua_State* tolua_S)
{
    int argc = 0;
    NetWorkManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetWorkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetWorkManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_networkmanager_NetWorkManager_sendData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "NetWorkManager:sendData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_networkmanager_NetWorkManager_sendData'", nullptr);
            return 0;
        }
        cobj->sendData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetWorkManager:sendData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_networkmanager_NetWorkManager_sendData'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_networkmanager_NetWorkManager_connectFunc(lua_State* tolua_S)
{
    int argc = 0;
    NetWorkManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetWorkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetWorkManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_networkmanager_NetWorkManager_connectFunc'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_networkmanager_NetWorkManager_connectFunc'", nullptr);
            return 0;
        }
        cobj->connectFunc();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetWorkManager:connectFunc",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_networkmanager_NetWorkManager_connectFunc'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_networkmanager_NetWorkManager_init(lua_State* tolua_S)
{
    int argc = 0;
    NetWorkManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetWorkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetWorkManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_networkmanager_NetWorkManager_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_networkmanager_NetWorkManager_init'", nullptr);
            return 0;
        }
        cobj->init();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetWorkManager:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_networkmanager_NetWorkManager_init'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_networkmanager_NetWorkManager_recvFunc(lua_State* tolua_S)
{
    int argc = 0;
    NetWorkManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetWorkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetWorkManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_networkmanager_NetWorkManager_recvFunc'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_networkmanager_NetWorkManager_recvFunc'", nullptr);
            return 0;
        }
        cobj->recvFunc();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetWorkManager:recvFunc",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_networkmanager_NetWorkManager_recvFunc'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_networkmanager_NetWorkManager_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"NetWorkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_networkmanager_NetWorkManager_getInstance'", nullptr);
            return 0;
        }
        NetWorkManager* ret = NetWorkManager::getInstance();
        object_to_luaval<NetWorkManager>(tolua_S, "NetWorkManager",(NetWorkManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NetWorkManager:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_networkmanager_NetWorkManager_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_cocos2dx_networkmanager_NetWorkManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (NetWorkManager)");
    return 0;
}

int lua_register_cocos2dx_networkmanager_NetWorkManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"NetWorkManager");
    tolua_cclass(tolua_S,"NetWorkManager","NetWorkManager","",nullptr);

    tolua_beginmodule(tolua_S,"NetWorkManager");
        tolua_function(tolua_S,"sendData",lua_cocos2dx_networkmanager_NetWorkManager_sendData);
        tolua_function(tolua_S,"connectFunc",lua_cocos2dx_networkmanager_NetWorkManager_connectFunc);
        tolua_function(tolua_S,"init",lua_cocos2dx_networkmanager_NetWorkManager_init);
        tolua_function(tolua_S,"recvFunc",lua_cocos2dx_networkmanager_NetWorkManager_recvFunc);
        tolua_function(tolua_S,"getInstance", lua_cocos2dx_networkmanager_NetWorkManager_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(NetWorkManager).name();
    g_luaType[typeName] = "NetWorkManager";
    g_typeCast["NetWorkManager"] = "NetWorkManager";
    return 1;
}
TOLUA_API int register_all_cocos2dx_networkmanager(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_cocos2dx_networkmanager_NetWorkManager(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

