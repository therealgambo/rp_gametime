local h, m, s = 6, 0, 0 -- default start time: 6h:0m:0s

local gta_seconds_per_real_second = 8
local loopwhole = 1000 / gta_seconds_per_real_second
local looptime = loopwhole % 1 >= 0.5 and math.ceil(loopwhole) or math.floor(loopwhole)
local freezetime = false

Citizen.CreateThread(function()
	local timer = 0
	while true do
		Citizen.Wait(looptime)
        if not freezetime then
            timer = timer + 1
            s = s + 1

            if s >= 60 then
                s = 0
                m = m + 1
            end

            if m >= 60 then
                m = 0
                h = h + 1
            end

            if h >= 24 then
                h = 0
            end

            if timer >= 60 * gta_seconds_per_real_second then
                timer = 0
                TriggerClientEvent("rp_gametime:server_sync_time", -1, h, m, s, gta_seconds_per_real_second, freezetime)
            end
        end
	end
end)

RegisterServerEvent("rp_gametime:request_current_time")
AddEventHandler("rp_gametime:request_current_time", function()
	TriggerClientEvent("rp_gametime:server_sync_time", source, h, m, s, gta_seconds_per_real_second, freezetime)
end)

-- TODO: add ACE permissions for these.
RegisterCommand('freezetime', function()
    freezetime = not freezetime
    LogDebug(I18nTranslate('time_frozen', {is_frozen=tostring(freezetime)}))
    TriggerClientEvent("rp_gametime:server_sync_time", -1, h, m, s, gta_seconds_per_real_second, freezetime)
end, false)

RegisterCommand('morning', function()
    h = 9
    m = 0
    s = 0
    LogDebug(I18nTranslate('time_set', {hours=h,minutes=m,seconds=s}))
    TriggerClientEvent("rp_gametime:server_sync_time", -1, h, m, s, gta_seconds_per_real_second, freezetime)
end, false)

RegisterCommand('noon', function()
    h = 12
    m = 0
    s = 0
    LogDebug(I18nTranslate('time_set', {hours=h,minutes=m,seconds=s}))
    TriggerClientEvent("rp_gametime:server_sync_time", -1, h, m, s, gta_seconds_per_real_second, freezetime)
end, false)

RegisterCommand('evening', function()
    h = 18
    m = 0
    s = 0
    LogDebug(I18nTranslate('time_set', {hours=h,minutes=m,seconds=s}))
    TriggerClientEvent("rp_gametime:server_sync_time", -1, h, m, s, gta_seconds_per_real_second, freezetime)
end, false)

RegisterCommand('night', function()
    h = 23
    m = 0   
    s = 0
    LogDebug(I18nTranslate('time_set', {hours=h,minutes=m,seconds=s}))
    TriggerClientEvent("rp_gametime:server_sync_time", -1, h, m, s, gta_seconds_per_real_second, freezetime)
end, false)
