--[[
Title: PyTranspiler Mod
Author(s): DreamAndDead
Date: 2019/09/27
Desc: pycode to luacode mod
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/PyTranspiler/main.lua");
------------------------------------------------------------
]]

local PyTranspiler = commonlib.inherit(commonlib.gettable("Mod.ModBase"), commonlib.gettable("Mod.PyTranspiler"))

function PyTranspiler:ctor()
end

-- virtual function get mod name
function PyTranspiler:GetName()
	return "PyTranspiler"
end

-- virtual function get mod description 
function PyTranspiler:GetDesc()
	return "PyTranspiler is a plugin to transpile pycode to luacode in paracraft"
end

function PyTranspiler:init()
	LOG.std(nil, "info", "PyTranspiler", "plugin initialized")
end

function PyTranspiler:OnLogin()
end

-- called when a new world is loaded. 
function PyTranspiler:OnWorldLoad()
end

-- called when a world is unloaded. 
function PyTranspiler:OnLeaveWorld()
end

function PyTranspiler:OnDestroy()
end

function PyTranspiler.LoadPlugin(callback)
    callback(true)
end

