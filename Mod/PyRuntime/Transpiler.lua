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

transpiler:run(py_code, _G)
------------------------------------------------------------
--]]

local http_post = System.os.GetUrl

local Transpiler = NPL.export()

function Transpiler:transpile(pycode)
    local err, msg, data = http_post({
            url='http://127.0.0.1:8080',
            method = 'POST',
            json = true,
            form = {
                pycode = pycode
            }
        }
    )
        
    local error = data['error']
    local luacode = data['luacode']

    return error, luacode
end

function Transpiler:installMethods(codeAPI, pyAPIs)
    for func_name, func in pairs(pyAPIs) do
		if(type(func_name) == "string" and type(func) == "function") then
			codeAPI[func_name] = function(...)
				return func(...);
			end
		end
	end
end

function Transpiler:OsSupported()
    local is_supported = (System.os.GetPlatform() == "win32")
    return is_supported;
end

local function activate()
    if msg then
        local runtime_error = msg["runtime_error"]
        local exit_code = msg["exit_code"]
        local output = msg["output"]

        if runtime_error then
            Transpiler.callback({
                lua_code = nil,
                error_msg = "Dll runtime error happens, please check the log"
            })
        else
            if exit_code ~= 0 then
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
