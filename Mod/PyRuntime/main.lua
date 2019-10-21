--[[
Title: PyRuntime Mod
Author(s): DreamAndDead
Date: 2019/09/27
Desc: pycode to luacode mod
use the lib:
------------------------------------------------------------
NPL.load("Mod/PyRuntime/main.lua");
------------------------------------------------------------
]]

local PyRuntime = commonlib.inherit(commonlib.gettable("Mod.ModBase"), commonlib.gettable("Mod.PyRuntime"))

function PyRuntime:ctor()
end

-- virtual function get mod name
function PyRuntime:GetName()
	return "PyRuntime"
end

-- virtual function get mod description 
function PyRuntime:GetDesc()
	return "PyRuntime is a plugin to transpile pycode to luacode in paracraft"
end

function PyRuntime:init()
	LOG.std(nil, "info", "PyRuntime", "plugin initialized")
end

function PyRuntime:OnLogin()
end

-- called when a new world is loaded. 
function PyRuntime:OnWorldLoad()
end

-- called when a world is unloaded. 
function PyRuntime:OnLeaveWorld()
end

function PyRuntime:OnDestroy()
end

function PyRuntime.LoadPlugin(callback)
    callback(true)
end

