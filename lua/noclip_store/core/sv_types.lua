-- If this file becomes a bit of a mess, we can make a subfolder and give them each their own file in there. Future issue tho.

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
-- Pointshop 1 points
NoClip.Store.Types['pointshop_1_points'] = function(plyID, expired, data)
	local ply = player.GetBySteamID64(plyID)

	if ply then -- Online
		ply:PS_GivePoints(data.data.points)
	else -- Offline
		-- Currently not sure the 'correct' way to give offline players points rn
	end
end
-- Pointshop w points
NoClip.Store.Types['pointshop_2_points'] = function(plyID, expired, data)
	local ply = player.GetBySteamID64(plyID)
	
	if ply then -- Online
		ply:PS2_AddStandardPoints(data.data.points)
	else -- Offline
		-- Also not sure how to handle this rn
	end
end