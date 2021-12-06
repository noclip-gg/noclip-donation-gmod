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
-- Pointshop 1 points
NoClip.Store.Types['pointshop_1_points'] = function(ply, expired, data)
	if not ply.PS_GivePoints then return end
	ply:PS_GivePoints(data.data.points)
end
-- Pointshop w points
NoClip.Store.Types['pointshop_2_points'] = function(ply, expired, data)
	if not ply.PS2_AddStandardPoints then return end
	ply:PS2_AddStandardPoints(data.data.points)
end