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

local defautl_ip = '127.0.0.1'
local defautl_port = 8006
local port = defautl_port

function Transpiler:OnInit()
    while ParaGlobal.PortInUse(defautl_ip, port) do
        port = port + 1
    end

    ParaGlobal.ExecuteFilter('C:/msys64/home/favor/project/PyRuntime/Mod/PyRuntime/py2lua/dist/py2lua.exe', {'--addr', defautl_ip, '--port', tostring(port)})

    LOG.std(nil, "info", "PyRuntime", "start py2lua service at " .. defautl_ip .. ":" .. tostring(port))
end

function Transpiler:transpile(pycode)
    local url = string.format('http://%s:%d/transpile', defautl_ip, port)
    local err, msg, data = http_post({
            url=url,
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

function Transpiler:OnDestroy()
    local url = string.format('http://%s:%d/exit', defautl_ip, port)
    local err, msg, data = http_post({
            url=url,
            method = 'POST',
            json = true,
            form = {}
        }
    )

    if err == 200 then
        LOG.std(nil, "info", "PyRuntime", "terminate py2lua service at " .. defautl_ip .. ":" .. tostring(port) .. ' succeed.')
    else
        LOG.std(nil, "info", "PyRuntime", "terminate py2lua service at " .. defautl_ip .. ":" .. tostring(port) .. ' FAILED!!!!!')
    end        
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
