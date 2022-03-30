
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1000)
    end
end)

local IsDead				  = false
local cam = nil

Citizen.CreateThread(function()
    while true do
		local ped = PlayerPedId()
        Citizen.Wait(1)
		local kordypeda = GetEntityCoords(PlayerPedId(), 0)
		for k,v in pairs(Config.KordyBasia) do
			for i = 1, #v.napis, 1 do
		local distance = #(vector3(v.napis[i].x, v.napis[i].y, v.napis[i].z) - kordypeda)
		if distance < 10 then
			DrawMarker(27, v.baska[i].x, v.baska[i].y, v.baska[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 105, 180, 200, false, true, 2, true, false, false, false)
			ESX.ShowFloatingHelpNotification('~p~[E]~w~ ABY SIĘ ULECZYĆ KOSZT: 1000$', vector3(v.napis[i].x, v.napis[i].y, v.napis[i].z))
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
				if distance < 3 then
					ESX.ShowHelpNotification('~y~Naciśnij ~INPUT_CONTEXT~ aby się uleczyć.')
                    if IsControlJustReleased(0, 46) then
                        if (GetEntityHealth(PlayerPedId()) < 200) then
							TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, false)
							DisableAllControlActions(0)
							exports['verti_taskbar']:taskBar(1000, 'Czekasz w kolejce.', true, false)

							EnableControlAction(1, 154)	
							ESX.TriggerServerCallback('esx_baska:kupLeczenie', function(bought)
								if true then


									ESX.ShowNotification('Doktor sie tobą zajmuje, poczekaj chwile!')
									SetEntityCoords(ped, v.lozko[i].x, v.lozko[i].y, v.lozko[i].z, v.lozko[i].h)
									ExecuteCommand("e lezenie")
									FreezeEntityPosition(ped, true)
									exports['verti_taskbar']:taskBar(10000, 'Trwa Leczenie', true, false)
										if not status then

											ESX.ShowNotification('Twoje leczenie zakończyło się ~g~pozytywnie~w~!')
											TriggerEvent('esx_ambulancejob:revive')
											TriggerServerEvent('dyrkiel:log')
											FreezeEntityPosition(ped, false)
											ClearPedTasks(ped) 
										end

								else
									ESX.ShowNotification('Potrzebujesz ~r~1000$~w~ aby ukończyć leczenie!')

								end
							end)	


                        else

							ESX.ShowNotification('~r~Nie potrzebujesz~w~ pomocy medycznej!')
							
                        end
                    end
                end
            end
		end
	end
end
    end
end)
