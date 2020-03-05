--[[
Title: PyRuntime Transpiler
Author(s): DreamAndDead
Date: 2019/09/29
Desc: tranpile pycode to luacode
use the lib:
------------------------------------------------------------
local transpiler = NPL.load("Mod/PyRuntime/Transpiler.lua")

transpiler:start()

error, luacode = transpiler:transpile(py_code)

if error then
    local error_msg = luacode
    print("error msg", error_msg)
end

-- handle with the transpiled luacode

transpiler:terminate()
------------------------------------------------------------
--]]

local Transpiler = NPL.export()

local http_post = System.os.GetUrl
local app_root = ParaIO.GetCurDirectory(0)
local py2lua_exe = app_root .. "plugins/py2lua.exe"

local defautl_ip = '127.0.0.1'
local defautl_port = 8006
local port = defautl_port
local max_alive_interval = 20 -- minutes
local loaded = false


function Transpiler:start()
    if loaded then
        LOG.std(nil, "info", "PyRuntime", "py2lua service has been loaded at " .. defautl_ip .. ":" .. tostring(port))
        return
    end

    if not ParaIO.DoesFileExist(py2lua_exe) then
        LOG.std(nil, "info", "PyRuntime", "py2lua.exe not exists in plugins/ directory, please update to latest version.")
        return
    end

    while not ParaGlobal.IsPortAvailable(defautl_ip, port) do
        port = port + 1
    end

    ParaGlobal.Execute(py2lua_exe, {'--addr', defautl_ip, '--port', tostring(port), '--max_alive_interval', tostring(max_alive_interval), '--verbose'})
    loaded = true

    LOG.std(nil, "info", "PyRuntime", "start py2lua service at " .. defautl_ip .. ":" .. tostring(port))
end

function Transpiler:transpile(pycode)
    if not loaded then
        self:start()
    end

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
    
    if data == nil then
        LOG.std(nil, "info", "PyRuntime", "transpile error happens")
        return true, "can't fetch data from py2lua service"
    end

    local error = data['error']
    local luacode = data['luacode']

    return error, luacode
end

function Transpiler:terminate()
    if not loaded then
        LOG.std(nil, "info", "PyRuntime", "py2lua service is not running")
        return
    end

    local url = string.format('http://%s:%d/exit', defautl_ip, port)
    local err, msg, data = http_post({
            url=url,
            method = 'POST',
            json = true,
            form = {}
        }
    )

    if err == 200 then
        loaded = false
        LOG.std(nil, "info", "PyRuntime", "terminate py2lua service at " .. defautl_ip .. ":" .. tostring(port) .. ' succeed.')
    else
        LOG.std(nil, "info", "PyRuntime", "terminate py2lua service at " .. defautl_ip .. ":" .. tostring(port) .. ' FAILED!')
    end        
end


function Transpiler:installMethods(codeAPIs, pyAPIs)
    for func_name, func in pairs(pyAPIs) do
        if(type(func_name) == "string" and type(func) == "function") then
			codeAPIs[func_name] = function(...)
				return func(...);
			end
		end
	end
end
