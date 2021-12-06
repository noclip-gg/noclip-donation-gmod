-- DarkRP Money
NoClip.Store.Core.RegisterType("darkrp_money", function(ply, expired, data)
	if not DarkRP then return end
	ply:addMoney(data.data.money)
end)

-- DarkRP Levels
NoClip.Store.Core.RegisterType("darkrp_levels", function(ply, expired, data)
	-- Vrondakis' leveling system (https://github.com/uen/Leveling-System)
	if LevelSystemConfiguration then
		ply:addLevels(data.data.levels)

	-- No level system found
	else
		NoClip.Store.Core.Error("Attempted to assign "..ply:SteamID().." "..data.data.levels.." DarkRP levels, but no level system was found.")
	end
end)