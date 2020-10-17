ESX = nil

PlayerData = {}

Current = {
    Action      = nil,
    Actionmsg   = nil,
    Spawn       = {pos = nil, rot = nil},
    Garage      = nil,
    CanTakeOut  = nil,
    isList      = nil,
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
    
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plyped = PlayerPedId()
        local coords = GetEntityCoords(plyped)

        for k,v in pairs(Config.Locations) do
            if (PlayerData.job and PlayerData.job.name == v.job and PlayerData.job.grade >= v.grade) or (v.job == false and v.grade == -1) then
                local distance = GetDistanceBetweenCoords(coords, v.coords, true)
                if distance <= 100 then
                    DrawMarker(v.markerType, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.markerSize, v.markerColor, v.markerDensity, false, true, 2, true, false, false, false)
                end
                if distance < 2 then
                    Current.Action = 'confiscation'
                    Current.Actionmsg = 'Press ~INPUT_PICKUP~ to open the impound'
                    Current.Spawn.pos = v.spawnCoords
                    Current.Spawn.rot = v.spawnRotation
                    Current.Garage = v.garagePool
                    Current.CanTakeOut = v.canTakeOut
                    Current.isList = v.isList

                    ESX.ShowHelpNotification(Current.Actionmsg)

                    if IsControlJustPressed(0, 38) then
                        if Current.Action == 'confiscation' then
                            OpenConfiscateMenu()
                        end
                    end
                end
            end
        end
    end
end)

function ConfiscateVehicle()
    local plyped = PlayerPedId()
    local plycoords = GetEntityCoords(plyped)
    local vehicle = ESX.Game.GetClosestVehicle(plycoords)
    local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
    local plate = vehicleData.plate
    local year, month, day, hour, minute, second = Citizen.InvokeNative(0x50C7A99057A69748, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local time = day.."."..month.."."..year.." "..hour..":"..minute..":"..second
    if not ESX.UI.Menu.IsOpen('dialog', GetCurrentResourceName(), 'confiscatemenu1') then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'confiscatemenu1', {
            title = 'Available garages: '..table.concat(Config.GaragePools, ", ")
        }, function(data, menu)
                for k,v in pairs(Config.GaragePools) do 
                    print(v)
                    if data.value == nil then
                        data.value = 'police'
                    end
                    if v == data.value then 
                        menu.close()
                        TaskStartScenarioInPlace(plyped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                        ImpoundVehicle(vehicle)
                        ESX.TriggerServerCallback('GetVehOwner', function(owner)
                            TriggerServerEvent('InsertConfiscation', plate, owner, time, data.value)
                        end, plate)
                    end
                end
        end, function(data, menu)
            menu.close()
        end)
    end
end

function OpenConfiscateMenu()
    Citizen.Wait(1000)
    if not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'confiscatemenu2a') and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'confiscatemenu2b') then
        if Current.isList then
            ESX.TriggerServerCallback('RetrieveAllConfiscatedVehicles', function(confiscatedvehicles)
            
                local elements = {}

                for k,v in pairs(confiscatedvehicles) do
                    table.insert(elements, {label = "Owner: "..v.owner.." | ".."Officer: "..v.officer.." | ".."Plate: "..v.plate.." | ".."Date: "..v.originaldate.." | ".."Garage: "..v.garage, plate = v.plate})
                end
                
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confiscatemenu2a', {
                    title    = "Confiscated Vehicles",
                    align    = 'bottom-right',
                    elements = elements,
                    }, function (data, menu)
                        if Current.CanTakeOut then
                            menu.close()
                            TriggerServerEvent('DeleteConfiscation', data.current.plate)
                            ESX.ShowNotification("Vehicle with plate: "..data.current.plate.." released")
                            SpawnVehicle(data.current.plate)
                            OpenConfiscateMenu()
                        else
                            ESX.ShowNotification("This is not a garage")
                        end
                end, function (data, menu)
                    menu.close()
                end)
                
            end)
        else
            ESX.TriggerServerCallback('RetrieveConfiscatedVehicles', function(confiscatedvehicles)
            
                local elements = {}

                for k,v in pairs(confiscatedvehicles) do
                    table.insert(elements, {label = "Owner: "..v.owner.." | ".."Officer: "..v.officer.." | ".."Plate: "..v.plate.." | ".."Date: "..v.originaldate, plate = v.plate})
                end
                
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confiscatemenu2b', {
                    title    = "Confiscated Vehicles",
                    align    = 'bottom-right',
                    elements = elements,
                    }, function (data, menu)
                        if Current.CanTakeOut then
                            menu.close()
                            TriggerServerEvent('DeleteConfiscation', data.current.plate)
                            ESX.ShowNotification("Vehicle with plate: "..data.current.plate.." released")
                            SpawnVehicle(data.current.plate)
                            OpenConfiscateMenu()
                        else
                            ESX.ShowNotification("This is not a garage")
                        end
                end, function (data, menu)
                    menu.close()
                end)
                
            end, Current.Garage)
        end
    end
end

function ImpoundVehicle(vehicle)
    Citizen.Wait(10000)
    ClearPedTasks(PlayerPedId())
    ESX.Game.DeleteVehicle(vehicle)
    ESX.ShowNotification("Fahrzeug beschlagnahmt")
end

function SpawnVehicle(plate)
    ESX.TriggerServerCallback('GetVehData', function(vehdata)
        vehdata.vehicle = json.decode(vehdata[1].vehicle)
        ESX.Game.SpawnVehicle(vehdata.vehicle.model, Current.Spawn.pos, Current.Spawn.rot, function(spawnedvehicle)
            ESX.Game.SetVehicleProperties(spawnedvehicle, vehdata.vehicle)
        end)
    end, plate)
end

RegisterCommand('confiscate', function()
    if (PlayerData.job and PlayerData.job.name == 'police') or (PlayerData.job and PlayerData.job.name == 'fib') then
        ConfiscateVehicle()
    else
        ESX.ShowNotification('You are not an officer')
    end
end, false)