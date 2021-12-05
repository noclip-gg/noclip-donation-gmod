surface.CreateFont("noclip_header", {
	font = "Roboto",
	size = ScreenScale(10),
	weight = 200
})
surface.CreateFont("noclip_body", {
	font = "Roboto",
	size = ScreenScale(8),
	weight = 200
})

local activeNotification
function NoClip.Store.UI.Notification(msg)
	-- All the stuff to get the sizes
	local scrW, scrH = ScrW(), ScrH()
	local boxSize = scrH*0.2
	surface.SetFont("noclip_header")
	local headerTextH = select(2, surface.GetTextSize(NoClip.Store.Translation.NotifHeader))
	surface.SetFont("noclip_body")
	local bodyTextH = select(2, surface.GetTextSize(msg))
	local headerH = headerTextH*1.2

	-- The main frame
	local frame = vgui.Create("DFrame")
	activeNotification = frame
	frame:SetSize(boxSize, boxSize)
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame:DockPadding(headerH*0.2, headerH*1.2, headerH*0.2, headerH*0.2)
	function frame:Paint(w, h)
		draw.RoundedBox(5, 0, 0, w, h, NoClip.Store.Config.NotifBodyColor, true, true)
		draw.RoundedBoxEx(5, 0, 0, w, headerH, NoClip.Store.Config.NotifHeaderColor, true, true)
		draw.SimpleText(NoClip.Store.Translation.NotifHeader, "noclip_header", 5, headerTextH*0.6, NoClip.Store.Config.NotifTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	-- The actual message
	local content = vgui.Create("DLabel", frame)
	content:Dock(FILL)
	content:SetAutoStretchVertical(true)
	content:SetContentAlignment(4)
	content:SetWrap(true)
	content:SetFont("noclip_body")
	content:SetColor(NoClip.Store.Config.NotifTextColor)
	content:SetText(msg)

	-- Because we're doing some annoying sizing stuff to the DFrame, we need to give the label time to init and size itself.
	-- Along with requiring that for the animations, there isn't an 'easy' way to do this without a hacky timer.
	-- We could pre calculate the height ourselves with some custom wrapper thing, but it doesn't seem worth the effort, or
	-- risk of incorrect calculation. If I'm being dumb or you have a 120IQ solution, please PR this lol... For all our sakes!
	-- All this for a damn slide animation.
	frame:SetPos(scrW, scrH) -- We place it off screen while we wait for things to get sorted
	timer.Simple(0.5, function()
		-- Size the frame to fit the content, maybe there is a better way to do this?
		frame:SizeToChildren(false, true)
		frame:SetTall((frame:GetTall() - bodyTextH*1.5) + headerH) -- There is a weird white space line under if we don't remove a line and a half?

		-- Animation stuff
		frame:SetPos(scrW, (scrH*0.5) - (frame:GetTall()*0.5))
		frame:MoveTo(scrW - (frame:GetWide()*1.05), (scrH*0.5) - (frame:GetTall()*0.5), 1)
		timer.Simple(3, function()
			frame:MoveTo(scrW, (scrH*0.5) - (frame:GetTall()*0.5), 1, 0, -1, function()
				frame:Remove()
				NoClip.Store.Notifications.Next()
			end)
		end)
	end)
end

-- A basic queue system
NoClip.Store.Notifications.Queue = {} 
function NoClip.Store.Notifications.Next()
	if IsValid(activeNotification) then return end
	for k, v in pairs(NoClip.Store.Notifications.Queue) do
		-- Run the next found notification
		NoClip.Store.UI.Notification(v)

		-- Remove it from the list
		NoClip.Store.Notifications.Queue[k] = nil
		break
	end
end
net.Receive("NoClip:Store:Notification", function()
	local msg = net.ReadString()

	table.insert(NoClip.Store.Notifications.Queue, msg)
	NoClip.Store.Notifications.Next()
end)