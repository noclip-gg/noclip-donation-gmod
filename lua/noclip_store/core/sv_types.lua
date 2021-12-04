-- Future proofing with expired arg
-- Also need to account for a lot more admin systems
NoClip.Store.Types['rank'] = function(plyID, expired, data)
	local ply = player.GetBySteamID64(plyID)
	local rank = expired and data.data.rank_expire or data.data.rank_to_give

	-- ULIB/ULX (https://github.com/TeamUlysses/ulx)
	if ULib then
		ULib.ucl.addUser(util.SteamIDFrom64(plyID), nil, nil, rank)

	-- xAdmin (https://github.com/TheXYZNetwork/xAdmin)
	elseif xAdmin and xAdmin.Github then

		if ply then -- Online
			ply:SetUserGroup(rank)
		else -- Offline
			xAdmin.Database.UpdateUsersGroup(plyID, rank)
		end

	-- SAM (https://www.gmodstore.com/market/view/sam)
	elseif sam then
		if ply then -- Online
			ply:sam_set_rank(rank)
		else -- Offline
			sam.player.set_rank_id(plyID, rank)
		end

	-- No admin system found
	else
		NoClip.Store.Core.Error("Attempted to assign "..plyID.." the rank "..rank..", but no admin system was found.")
	end
end