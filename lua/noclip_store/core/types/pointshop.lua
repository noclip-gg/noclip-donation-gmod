-- Pointshop 1 Points
NoClip.Store.Core.RegisterType("pointshop_1_points", function(ply, expired, data)
	if not ply.PS_GivePoints then return end
	ply:PS_GivePoints(data.data.points)
end)