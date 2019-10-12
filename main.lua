--[[
Title: Py2Lua
Author(s): DreamAndDead
Date: 2019/09/27
Desc: python script to lua script mod
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/Py2Lua/main.lua");
------------------------------------------------------------
]]
local Py2Lua = commonlib.inherit(commonlib.gettable("Mod.ModBase"), commonlib.gettable("Mod.Py2Lua"));

function Py2Lua:ctor()
end

-- virtual function get mod name
function Py2Lua:GetName()
	return "Py2Lua"
end

-- virtual function get mod description 
function Py2Lua:GetDesc()
	return "Py2Lua is a plugin in paracraft"
end

function Py2Lua:init()
	LOG.std(nil, "info", "Py2Lua", "plugin initialized");
end

function Py2Lua:OnLogin()
end

-- called when a new world is loaded. 
function Py2Lua:OnWorldLoad()
end

-- called when a world is unloaded. 
function Py2Lua:OnLeaveWorld()
end

function Py2Lua:OnDestroy()
end

function Py2Lua.LoadPlugin(callback)
    callback(true)
end

