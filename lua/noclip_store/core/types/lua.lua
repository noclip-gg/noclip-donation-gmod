-- Custom Lua Action
NoClip.Store.Core.RegisterType("custom_lua", function(ply, expired, data)
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
end)