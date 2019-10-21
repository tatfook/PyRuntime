--[[
Title: PyRuntime Transpiler
Author(s): DreamAndDead
Date: 2019/09/29
Desc: Call external py2lua.exe to tranpile pycode to luacode
use the lib:
------------------------------------------------------------
local transpiler = NPL.load("Mod/PyRuntime/Transpiler.lua")
transpiler:transpile(py_code, function(res)
    local lua_code = res["lua_code"]
    if lua_code == nil then
        -- handle error message
        print(res["error_msg"])
    end

    -- deal with lua_code
    print(lua_code)
end)
------------------------------------------------------------
--]]

local Transpiler = NPL.export()

function Transpiler:transpile(py_code, callback)
    if not Transpiler:OsSupported() then
        local error_msg = "PyRuntime Mod isn't supported on " .. System.os.GetPlatform() .. " platform"
        callback({
            lua_code = nil,
            error_msg = error_msg
        })
        return
    end

    local app_root = ParaIO.GetCurDirectory(0)
    local py2lua_exe = app_root .. "plugins/py2lua.exe"
    local exe_loader_dll = app_root .. "plugins/ExeLoader.dll"

    if not ParaIO.DoesFileExist(py2lua_exe) then
        callback({
            lua_code = nil,
            error_msg = "py2lua.exe not found in plugins directory"
        })
        return
    end

    if not ParaIO.DoesFileExist(exe_loader_dll) then
        callback({
            lua_code = nil,
            error_msg = "ExeLoader.dll not found in plugins directory, please install ExeLoader mod"
        })
        return
    end

    Transpiler.callback = callback

    NPL.activate(exe_loader_dll, {
        exe_path = py2lua_exe,
        input = py_code,
        callback = "Mod/PyRuntime/Transpiler.lua"
    })
end

function Transpiler:OsSupported()
    local is_supported = (System.os.GetPlatform() == "win32")
    return is_supported;
end

local function activate()
    if msg then
        local runtime_error = msg["runtime_error"]
        local exe_error = msg["exe_error"]
        local output = msg["output"]

        if runtime_error then
            Transpiler.callback({
                lua_code = nil,
                error_msg = "Dll runtime error happens, please check the log"
            })
        else
            if exe_error then
                Transpiler.callback({
                    lua_code = nil,
                    error_msg = output
                })
            else
                Transpiler.callback({
                    lua_code = output,
                    error_msg = nil
                })
            end
        end
    end
end

NPL.this(activate)
