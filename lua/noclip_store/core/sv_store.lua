local EVENT_PURCAHSED = 1
local EVENT_EXPIRED = 2
local EVENT_REVOKED = 3

local httpFetch
local httpPost
do
    local result = pcall(require, "reqwest")

    if not result and not reqwest then
        print("[Noclip] reqwest not found. Please install it from https://github.com/WilliamVenner/gmsv_reqwest or your hosting providers mod manager.")
        print("[Noclip] Noclip will not work until reqwest is installed.")
        print("[Noclip] If you need help, join the discord at https://noclip.gg/discord")
        return
    end

    local noclip_debug = false
    local function debugHTTP(msg)
        if not noclip_debug then return end
        print("[NoclipDebug] " .. msg)
    end

    httpFetch = function(url, onsuccess, onfailure, header)
        reqwest({
            url = url,
            method = "GET",
            headers = header or {},
            success = function(code, body, headers)
                if not onsuccess then return end
                debugHTTP("GET " .. url .. " " .. code)
                onsuccess(body, body:len(), headers, code)
            end,
            failed = function(err) debugHTTP("FAIL " .. err) if not onfailure then return end onfailure(err) end
        })
    end

    httpPost = function(url, params, onsuccess, onfailure, header)
        reqwest({
            url = url,
            method = "POST",
            headers = header or {},
            parameters = params,
            success = function(code, body, headers)
                if not onsuccess then return end
                debugHTTP("POST " .. url .. " " .. code)
                onsuccess(body, body:len(), headers, code)
            end,
            failed = function(err) debugHTTP("FAIL " .. err) if not onfailure then return end onfailure(err) end
        })
    end
end

-- Probably a better name for this function?
function NoClip.Store.Core.Check()
	-- Check the API using the config values
	httpFetch(string.format("%s/api/v1/gmod/servers/%s/events?api_key=%s", NoClip.Store.Config.URL, NoClip.Store.Config.ServerID, NoClip.Store.Config.APIKey),
		function(body, size, headers, code)
			local data = util.JSONToTable(body)
			-- Seems we received some unexpected data
			if not data then
				NoClip.Store.Core.Error("Invalid JSON response from API /events route!")
				return 
			end

			-- Broadcast it in a hook, to allow other devs to do stuff
			hook.Run("NoClipStoreCheck", data)

			-- Have all the events processed
			for k, v in ipairs(data.data) do
				NoClip.Store.Core.EventProcess(v)
			end
		end
	)
end

function NoClip.Store.Core.EventProcess(data)
	-- Get the player
	local receiver = player.GetBySteamID64(data.receiver_game_id)
	if not IsValid(receiver) then return end -- They're not online, keep checking the event till they are.

	-- Allow for this event to be blocked
	local block = hook.Run("NoClipStorePreEventProcess", data.id, receiver, data)
	if block == false then return end -- A hook has killed this process

	local expired = data.type == EVENT_EXPIRED

	-- Run the actions for this event
	for k, v in ipairs(data.package.actions.data) do
		local typeFunc = NoClip.Store.Types[v.type]
		if not typeFunc then
			NoClip.Store.Core.Error("Attempted to process an action but the type function was not found. The action type was: "..v.type)
			continue
		end

		typeFunc(receiver, expired, v, data)
	end

	hook.Run("NoClipStorePostEventProcess", data.id, receiver, data)
	
	-- Post the notification
	if NoClip.Store.Config.ShowNotification then
		NoClip.Store.Core.Notification(string.format(expired and NoClip.Store.Translation.NotifExpired or NoClip.Store.Translation.NotifPurchase, receiver:Name(), data.package.name), NoClip.Store.Config.ShowNotificationToEveryone and player.GetAll() or receiver)
	end

	NoClip.Store.Core.EventMarkProcessed(data.id)
end

function NoClip.Store.Core.EventMarkProcessed(eventID)
	httpPost(string.format("%s/api/v1/gmod/servers/%s/events/%s/process?api_key=%s", NoClip.Store.Config.URL, NoClip.Store.Config.ServerID, eventID, NoClip.Store.Config.APIKey))
end

-- Register a new action type
function NoClip.Store.Core.RegisterType(api_name, action)
	if NoClip.Store.Types[api_name] then
		NoClip.Store.Core.Error("Attempted to register an action type that has already been registed. This type was: "..api_name)
		return
	end

	NoClip.Store.Types[api_name] = action
end
-- Load all the files in /types
for b, File in SortedPairs(file.Find("noclip_store/core/types/*.lua", "LUA"), true) do
	print("	Loading type file: ", File)
    include("noclip_store/core/types/" .. File)
end