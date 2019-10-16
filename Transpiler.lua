--[[
Title: Python Transpiler
Author(s): DreamAndDead
Date: 2019/09/29
Desc: Call external py2lua.exe to tranpile pycode to luacode
use the lib:
------------------------------------------------------------
local transpiler = NPL.load("Mod/PyTranspiler/Transpiler.lua")
local luacode, error_msg = transpiler:transpile(pycode)
if luacode == nil then
    -- handle error_msg
end
------------------------------------------------------------
--]]

local Transpiler = NPL.export()

--[[
    params:
    - pycode

    returns:
    - luacode
    - error_msg
]]
function Transpiler:transpile(pycode)
    if not Transpiler:OsSupported() then
        local error_msg = "PyTranspiler Mod isn't supported on " .. System.os.GetPlatform() .. " platform"
        return nil, error_msg
    end

    local app_root = ParaIO.GetCurDirectory(0)
    local py2lua_exe = app_root .. "plugins/py2lua.exe"

    if not ParaIO.DoesFileExist(py2lua_exe) then
        return nil, "py2lua.exe not found in plugins directory"
    end

    if not ParaGlobal.ExecuteFilter then
        return nil, "ParaGlobal.ExecuteFilter not found in NPL Runtime"
    end

    local res = ParaGlobal.ExecuteFilter(py2lua_exe, pycode)
    if res == nil then
        return nil, "found error in ParaGlobal.ExecuteFilter, please check the log"
    end

    local exit_code = res["exit_code"]
    local output = res["output"]

    if exit_code == 0 then
        return output, nil
    else
        return nil, output
    end
end

function Transpiler:OsSupported()
    local is_supported = (System.os.GetPlatform() == "win32")
    return is_supported;
end
