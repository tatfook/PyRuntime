--[[
Title: Python Transpiler
Author(s): DreamAndDead
Date: 2019/09/29
Desc: Call external py2lua.exe to tranpile pycode to luacode
use the lib:
------------------------------------------------------------
local transpiler = NPL.load("Mod/PyTranspiler/Transpiler.lua")
luacode = transpiler:transpile(pycode)

-- TODO:
-- error handles

------------------------------------------------------------
--]]

local Transpiler = NPL.export()

function Transpiler:transpile(pycode)
    if(not Transpiler.OsSupported())then
	    LOG.std(nil, "info", "PyTranspiler", "PyTranspiler transpiler isn't supported on %s", System.os.GetPlatform())
        return
    end

    -- TODO: some more error handling
    local app_root = ParaIO.GetCurDirectory(0)

    -- TODO: exe exist?
    local luacode = ParaGlobal.ExecuteFilter(app_root .. "plugins/py2lua.exe", pycode)
    return luacode
end

function Transpiler:OsSupported()
    local is_supported = (System.os.GetPlatform()=="win32")
    return is_supported;
end
