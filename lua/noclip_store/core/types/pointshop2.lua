-- Pointshop 2 Points
NoClip.Store.Core.RegisterType("pointshop_2_points", function(ply, expired, data)
	if not ply.PS2_AddStandardPoints then return end
	if expired then return end

	ply:PS2_AddStandardPoints(data.data.points)
end)

-- Pointshop 2 Premium Points
NoClip.Store.Core.RegisterType("pointshop_2_premium_points", function(ply, expired, data)
	if not ply.PS2_AddPremiumPoints then return end
	if expired then return end
	
	ply:PS2_AddPremiumPoints(data.data.points)
end)