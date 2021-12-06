-- Custom Console Command
NoClip.Store.Core.RegisterType("custom_console_command", function(ply, expired, data)
	local command = data.data.console_command
	command = string.Replace(command, "{player.name}", "\""..string.Replace(ply:Name(), "\"", "").."\"")
	command = string.Replace(command, "{player.steamID}", ply:SteamID())
	command = string.Replace(command, "{player.steamID64}", ply:SteamID64())

	game.ConsoleCommand(command.."\n")
end)