-- If this file becomes a bit of a mess, we can make a subfolder and give them each their own file in there. Future issue tho.

-- Future proofing with expired arg
-- Also need to account for a lot more admin systems
NoClip.Store.Types['rank'] = function(ply, expired, data)
	local rank = expired and data.data.rank_expire or data.data.rank_to_give

	-- ULIB/ULX (https://github.com/TeamUlysses/ulx)
	if ULib then
		ULib.ucl.addUser(ply:SteamID(), nil, nil, rank)

	-- xAdmin (https://github.com/TheXYZNetwork/xAdmin)
	elseif xAdmin and xAdmin.Github then
		ply:SetUserGroup(rank)

	-- SAM (https://www.gmodstore.com/market/view/sam)
	elseif sam then
		ply:sam_set_rank(rank)

	-- No admin system found
	else
		NoClip.Store.Core.Error("Attempted to assign "..ply:SteamID().." the rank "..rank..", but no admin system was found.")
	end
end
-- Console Command
NoClip.Store.Types['custom_console_command'] = function(ply, expired, data)
	local command = data.data.console_command
	command = string.Replace(command, "{player.name}", "\""..string.Replace(ply:Name(), "\"", "").."\"")
	command = string.Replace(command, "{player.steamID}", ply:SteamID())
	command = string.Replace(command, "{player.steamID64}", ply:SteamID64())

	game.ConsoleCommand(command.."\n")
end
-- Custom Lua
NoClip.Store.Types['custom_lua'] = function(ply, expired, data)
	NoClip.Store.TempPlayer = ply -- This seems like the easiest and most reliable way to pass an object.

	local code = data.data.custom_lua
	code = string.Replace(code, "{player.entity}", "NoClip.Store.TempPlayer")
	code = string.Replace(code, "{player.steamID}", "\""..ply:SteamID().."\"")
	code = string.Replace(code, "{player.steamID64}", "\""..ply:SteamID64().."\"")

	local errorMsg = RunString(code, "NoClipStoreCustomLuaAction", false)
	if errorMsg then
		NoClip.Store.Core.Error("Custom Lua Error:\n"..errorMsg)
	end

	NoClip.Store.TempPlayer = nil
end
-- Pointshop 1 Points
NoClip.Store.Types['pointshop_1_points'] = function(ply, expired, data)
	if not ply.PS_GivePoints then return end
	ply:PS_GivePoints(data.data.points)
end
-- Pointshop 2 Points
NoClip.Store.Types['pointshop_2_points'] = function(ply, expired, data)
	if not ply.PS2_AddStandardPoints then return end
	ply:PS2_AddStandardPoints(data.data.points)
end