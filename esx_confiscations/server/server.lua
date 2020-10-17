ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('InsertConfiscation')
AddEventHandler('InsertConfiscation', function(plate, owner, time, garage)
    local xPlayer = ESX.GetPlayerFromId(source)
    if plate ~= nil and owner ~= nil and time ~= nil and xPlayer ~= nil then
        MySQL.Async.execute('INSERT INTO confiscations (plate, owner, officer, originaldate, garage) VALUES (@plate, @owner, @officer, @time, @garage)', {
            ['@plate'] = plate,
            ['@owner'] = owner,
            ['@officer'] = xPlayer.identifier,
            ['@time'] = time,
            ['@garage'] = garage,
        })
    end
end)

RegisterNetEvent('DeleteConfiscation')
AddEventHandler('DeleteConfiscation', function(plate)
    if plate ~= nil then
        MySQL.Async.execute('DELETE FROM confiscations WHERE plate = @plate', {
            ['@plate'] = plate
        })
    end
end)

ESX.RegisterServerCallback('GetVehOwner', function(source, cb, plate)
    if plate ~= nil then
        MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = plate,
        }, function(result)
            if result[1] ~= nil then
                cb(result[1].owner)
            end
        end)
    end
end)

ESX.RegisterServerCallback('GetVehData', function(source, cb, plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate,
    }, function(result)
        if result[1] ~= nil then
            cb(result)
        end
	end)
end)

ESX.RegisterServerCallback('RetrieveConfiscatedVehicles', function(source, cb, garage)
    MySQL.Async.fetchAll('SELECT * FROM confiscations WHERE garage = @garage ORDER BY `date` DESC', {
        ['@garage'] = garage,
    }, function(result)
        if result[1] ~= nil then
            for k,v in pairs(result) do
                local identifierowner = v.owner
                local identifierofficer = v.officer

                MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', { 
                    ['@identifier'] = identifierowner 
                }, function(resultowner)
                    if resultowner[1] ~= nil then
                        v.owner = resultowner[1].firstname.." "..resultowner[1].lastname
                    end
                end)

                MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', { 
                    ['@identifier'] = identifierofficer 
                }, function(resultofficer)
                    if resultofficer[1] ~= nil then
                        v.officer = resultofficer[1].firstname.." "..resultofficer[1].lastname
                    end
                end)
            end
            Citizen.Wait(1000)
            cb(result)
        end
	end)
end)

