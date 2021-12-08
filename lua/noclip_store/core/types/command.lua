-- Custom Console Command
NoClip.Store.Core.RegisterType("custom_console_command", function(ply, expired, data)
	local command = expired and (data.data.console_command_expire or "") or data.data.console_command
	if (not command) or (command == "") then return end

	command = string.Replace(command, "{player.name}", "\""..string.Replace(ply:Name(), "\"", "").."\"")
	command = string.Replace(command, "{player.steamID}", ply:SteamID())
	command = string.Replace(command, "{player.steamID64}", ply:SteamID64())

	game.ConsoleCommand(command.."\n")
end)