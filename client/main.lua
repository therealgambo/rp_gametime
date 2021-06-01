local synced, freezetime = false, false;
local h, m, s = 0, 0, 0
local looptime = 1000

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(100)
	end
	TriggerServerEvent("rp_gametime:request_current_time")
	while not synced do
		Citizen.Wait(0)
	end
	TriggerEvent("rp_gametime:override_client_time")

    TriggerEvent('chat:addSuggestion', '/freezetime', 'Freeze / unfreeze time.')
    TriggerEvent('chat:addSuggestion', '/morning', 'Set the time to 09:00')
    TriggerEvent('chat:addSuggestion', '/noon', 'Set the time to 12:00')
    TriggerEvent('chat:addSuggestion', '/evening', 'Set the time to 18:00')
    TriggerEvent('chat:addSuggestion', '/night', 'Set the time to 23:00')
end)

RegisterNetEvent("rp_gametime:server_sync_time")
AddEventHandler("rp_gametime:server_sync_time", function(hour, minute, second, loop, freeze)
	h = hour
	m = minute
	s = second
    freezetime = freeze
    synced = true
    local loopwhole = 1000 / loop
    looptime = loopwhole % 1 >= 0.5 and math.ceil(loopwhole) or math.floor(loopwhole)
end)

AddEventHandler("rp_gametime:override_client_time", function()
    LogDebug(I18nTranslate('time_sync', {hours=h, minutes=m, seconds=s}))
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(10)
			NetworkOverrideClockTime(h, m, s)
		end
	end)
end)

Citizen.CreateThread(function()
	while not synced do
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(looptime)
        if not freezetime then
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
        end
	end
end)
