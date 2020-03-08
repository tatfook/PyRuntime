--[[
Title: PyRuntime Transpiler
Author(s): DreamAndDead
Date: 2019/09/29
Desc: transpile pycode to luacode
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
local py2npl_exe = app_root .. "plugins/py2npl.exe"

local default_ip = '127.0.0.1'
local defautl_port = 8006
local port = defautl_port
local max_alive_interval = 5 -- seconds
local loaded = false


function Transpiler:start()
    if loaded then
        -- LOG.std(nil, "info", "PyRuntime", "py2npl service has been loaded at " .. default_ip .. ":" .. tostring(port))
        return
    end

    if not ParaIO.DoesFileExist(py2npl_exe) then
        LOG.std(nil, "info", "PyRuntime", "py2npl.exe not exists in plugins/ directory, please update to latest version.")
        return
    end

    local nTryCount = 0
    while(not ParaGlobal.IsPortAvailable(default_ip, port)) do
        nTryCount = nTryCount + 1;
        if (nTryCount > 10) then
            LOG.std(nil, "error", "PyRuntime", "py2npl.exe can not find an available http port")
            break;
        else
            port = port + 1
        end
    end

    ParaGlobal.Execute(py2npl_exe, {'--addr', default_ip, '--port', tostring(port), '--max_alive_interval', tostring(max_alive_interval), '--verbose'})
    loaded = true

    LOG.std(nil, "info", "PyRuntime", "start py2npl service at " .. default_ip .. ":" .. tostring(port))

    self.alive_timer = commonlib.Timer:new({callbackFunc = function(timer)
        self:keepalive()
    end})

    -- start the timer after 0 milliseconds, and signal every 1000 millisecond
    self.alive_timer:Change(0, 1000)
end

function Transpiler:keepalive()
    if not loaded then
        self:start()
        return
    end

    local url = string.format('http://%s:%d/keepalive', default_ip, port)
    local err, msg, data = http_post({
            url=url,
            method = 'POST',
            json = true,
            form = {
            }
        }
    )
end


function Transpiler:transpile(pycode)
    if not loaded then
        self:start()
    end

    local url = string.format('http://%s:%d/transpile', default_ip, port)
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
        return true, "can't fetch data from py2npl service"
    end

    local error = data['error']
    local luacode = data['luacode']

    return error, luacode
end

function Transpiler:installMethods(codeAPIs, pyAPIs)
    for name, api in pairs(pyAPIs) do
		codeAPIs[name] = api
	end
end
