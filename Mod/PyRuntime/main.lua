--[[
Title: PyRuntime Mod
Author(s): DreamAndDead
Date: 2019/09/27
Desc: running pycode in npl by transpiling
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
	return "PyRuntime is a plugin for running pycode in npl by transpiling"
end

function PyRuntime:init()
	LOG.std(nil, "info", "PyRuntime", "plugin initialized")

    -- register a new block item, id < 10512 is internal items, which is not recommended to modify. 
	GameLogic.GetFilters():add_filter("block_types", function(xmlRoot) 
		local blocks = commonlib.XPath.selectNode(xmlRoot, "/blocks/");
		if(blocks) then
			NPL.load("(gl)Mod/PyRuntime/ItemPyRuntimeCodeBlock.lua");
			blocks[#blocks+1] = {name="block", attr={ name="PyRuntimeCodeBlock",
				id = 10516, item_class="ItemPyRuntimeCodeBlock", text=L"PyRuntimeCodeBlock",
				icon = "Mod/PyRuntime/textures/icon.png",
			}}
			LOG.std(nil, "info", "PyRuntime", "PyRuntime is registered");

		end
		return xmlRoot;
	end)

	-- add block to category list to be displayed in builder window (E key)
	GameLogic.GetFilters():add_filter("block_list", function(xmlRoot) 
		for node in commonlib.XPath.eachNode(xmlRoot, "/blocklist/category") do
			if(node.attr.name == "tool" or node.attr.name == "character") then
				node[#node+1] = {name="block", attr={name="PyRuntimeCodeBlock"} };
			end
		end
		return xmlRoot;
	end)
end

function PyRuntime:OnLogin()
end

-- called when a new world is loaded. 
function PyRuntime:OnWorldLoad()
	LOG.std(nil, "info", "PyRuntime", "world load")
end

-- called when a world is unloaded. 
function PyRuntime:OnLeaveWorld()
	LOG.std(nil, "info", "PyRuntime", "world leave")
end

function PyRuntime:OnDestroy()
	LOG.std(nil, "info", "PyRuntime", "Plugin destroy")
end

function PyRuntime.LoadPlugin(callback)
    callback(true)
end

