NoClip = NoClip or {}
-- Create the master table
NoClip.Store = {
	Info = {
		Version = "1.1.3"
	},
	Config = {},
	Translation = {},
	Core = {},
	Types = {},
	UI = {},
	Notifications = {}
}

print("Loading NoClip | Store")

local path = "noclip_store/"
if SERVER then
	local files, folders = file.Find(path .. "*", "LUA")
	
	for _, folder in SortedPairs(folders, true) do
		print("Loading folder:", folder)
	    for b, File in SortedPairs(file.Find(path .. folder .. "/sh_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        AddCSLuaFile(path .. folder .. "/" .. File)
	        include(path .. folder .. "/" .. File)
	    end
	
	    for b, File in SortedPairs(file.Find(path .. folder .. "/sv_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        include(path .. folder .. "/" .. File)
	    end
	
	    for b, File in SortedPairs(file.Find(path .. folder .. "/cl_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        AddCSLuaFile(path .. folder .. "/" .. File)
	    end
	end

	-- Remove any poorly input URLs for the config
	NoClip.Store.Config.URL = string.Trim(NoClip.Store.Config.URL, "/")
end

if CLIENT then
	local files, folders = file.Find(path .. "*", "LUA")
	
	for _, folder in SortedPairs(folders, true) do
		print("Loading folder:", folder)
	    for b, File in SortedPairs(file.Find(path .. folder .. "/sh_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        include(path .. folder .. "/" .. File)
	    end

	    for b, File in SortedPairs(file.Find(path .. folder .. "/cl_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        include(path .. folder .. "/" .. File)
	    end
	end
end

print("Loaded NoClip | Store")
