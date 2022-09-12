-- Your community's API key. Can be found here: https://yourcommunity.noclip.me/admin/general-settings
-- if you don't see the API key, press "Reset API Key" at the top
NoClip.Store.Config.APIKey = "ABC-123-XYZ"

-- The URL to your community. Ensure there is no trailing "/"
NoClip.Store.Config.URL = "https://yourcommunity.noclip.me"

-- This server's ID. It can be found by selecting the server here: https://yourcommunity.noclip.me/admin/servers
NoClip.Store.Config.ServerID = "ABC123"

-- How often (in seconds) should the server check for any new purchases?
NoClip.Store.Config.Check = 30

-- Show a notification when a package is purchased
NoClip.Store.Config.ShowNotification = true
-- If true, show the notification to everyone?
NoClip.Store.Config.ShowNotificationToEveryone = true
-- If true, log all HTTP requests made to the API
NoClip.Store.Config.LogHTTP = false