--[[
Title: Transpiler
Author(s): DreamAndDead
Date: 2019/09/29
Desc: Connect "py2lua.exe" 
use the lib:
------------------------------------------------------------
--using
local Transpiler = NPL.load("Mod/Py2Lua/Transpiler.lua");
Transpiler.load({ npl_oce_dll = "plugins/nploce_d.dll", activate_callback = "Mod/Py2Lua/Transpiler.lua", },function(msg)
	local cube = NplOce.cube(1,2,3);
    commonlib.echo(cube:IsNull());
    commonlib.echo(cube:ShapeType());
end);
-- or
local Transpiler = NPL.load("Mod/Py2Lua/Transpiler.lua");
Transpiler.load({ npl_oce_dll = "plugins/nploce.dll", activate_callback = "Mod/Py2Lua/Transpiler.lua", },function(msg)
    
end);
------------------------------------------------------------
--]]
NPL.load("(gl)script/ide/math/bit.lua");
NPL.load("(gl)script/ide/System/os/os.lua");

local Transpiler = NPL.export();
Transpiler.is_loaded = false;

-- Install dll
-- @param {table} options
-- @param {string} [options.npl_oce_dll = "plugins/nploce_d.dll"] - the location of dll
-- @param {string} [options.activate_callback = "Mod/NplOce/Transpiler.lua"] - the location of be actived
function Transpiler.load(options, callback)
    if(Transpiler.is_loaded)then
        if(callback)then
            callback(true);
        end
        return
    end

    if(not Transpiler.OsSupported())then
	    LOG.std(nil, "info", "Transpiler", "nplcad isn't supported on %s", System.os.GetPlatform());
        return
    end

    if(not NPL.GetLuaState)then
		LOG.std(nil, "error", "Transpiler", "can't find the function of NPL.GetLuaState.\n");
        return
    end

	Transpiler.callback = callback;
    local npl_oce_dll = options.npl_oce_dll or "plugins/py2lua.exe"
    local activate_callback = options.activate_callback or "Mod/Py2Lua/Transpiler.lua";
    
    local lua_state = NPL.GetLuaState("",{});
    local high = lua_state.high or 0;
    local low = lua_state.low or 0;
    local value = mathlib.bit.lshift(high, 32);
    value = mathlib.bit.bor(value, low);
	if(value == 0)then
		LOG.std(nil, "error", "Transpiler", "lua state is wrong.\n");
		return
    end
    
	NPL.activate(npl_oce_dll, { lua_state = value, callback = activate_callback});
end

function Transpiler.OsSupported()
    local is_supported = (System.os.GetPlatform()=="win32" and not System.os.Is64BitsSystem());
    return is_supported;
end

local function activate()
	if(msg and msg.successful)then
        if(not Transpiler.is_loaded)then
            Transpiler.is_loaded = true;

            NPL.load("Mod/Py2Lua/NplOce_Internal.lua");

            if(Transpiler.callback)then
                Transpiler.callback(true);
            end
		end
	end
end

NPL.this(activate);