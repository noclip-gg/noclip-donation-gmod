-- Custom Lua Action
NoClip.Store.Core.RegisterType("custom_lua", function(ply, expired, data)
	NoClip.Store.TempPlayer = ply -- This seems like the easiest and most reliable way to pass an object.

	local code = expired and (data.data.custom_lua_expire or "") or data.data.custom_lua
	if (not code) or (code == "") then return end

	code = string.Replace(code, "{player.entity}", "NoClip.Store.TempPlayer")
	code = string.Replace(code, "{player.steamID}", "\""..ply:SteamID().."\"")
	code = string.Replace(code, "{player.steamID64}", "\""..ply:SteamID64().."\"")
	code = string.Replace(code, "{player.name}", "\""..string.Replace(ply:Name(), "\"", "").."\"")

	local errorMsg = RunString(code, "NoClipStoreCustomLuaAction", false)
	if errorMsg then
		NoClip.Store.Core.Error("Custom Lua Error:\n"..errorMsg)
	end

	NoClip.Store.TempPlayer = nil
end)