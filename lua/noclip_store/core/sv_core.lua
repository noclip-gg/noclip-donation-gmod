-- Start the timer to constantly check for updates
hook.Add("Initialize", "NoClip:Store:Load", function()
	timer.Create("NoClip:Store:Check", NoClip.Store.Config.Check, 0, function()
        if not NoClip.HasHTTPModule then
            NoClip.HTTPModuleErrorMessage()
        end
		NoClip.Store.Core.Check()
	end)
end)

-- Functions
function NoClip.Store.Core.Error(error)
	print("[NoClip | Store]", error)

	-- Maybe we can log it somewhere, like an SQL databse??
end

-- The networking for notifications
util.AddNetworkString("NoClip:Store:Notification")
function NoClip.Store.Core.Notification(msg, ply)
	net.Start("NoClip:Store:Notification")
		net.WriteString(msg)
	net.Send(ply)
end