local ESX = exports.es_extended:getSharedObject()

MySQL.ready(function()
    print('loaded bmw_cargarage successfully! dm for help and support on discord: mister_bmw')
end)

ESX.RegisterServerCallback('bmw_cargarage:getVehicles', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = identifier
    }, function(result)
        local vehicles = {}
        for i=1, #result, 1 do
            local vehicleData = json.decode(result[i].vehicle)
            table.insert(vehicles, {
                plate = result[i].plate,
                vehicle = vehicleData,
                state = result[i].state,
            })
        end
        cb(vehicles)
    end)
end)

RegisterServerEvent('bmw_cargarage:setVehicleOut')
AddEventHandler('bmw_cargarage:setVehicleOut', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE owned_vehicles SET state = 0 WHERE plate = @plate AND owner = @owner', {
        ['@plate'] = plate,
        ['@owner'] = xPlayer.getIdentifier()
    })
end)

RegisterServerEvent('bmw_cargarage:setVehicleIn')
AddEventHandler('bmw_cargarage:setVehicleIn', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE owned_vehicles SET state = 1 WHERE plate = @plate AND owner = @owner', {
        ['@plate'] = plate,
        ['@owner'] = xPlayer.getIdentifier()
    })
end)

RegisterNetEvent('bmw_cargarage:giveVehicle')
AddEventHandler('bmw_cargarage:giveVehicle', function(playerId, vehicleName)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    if xPlayer then
        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, state) VALUES (@owner, @vehicle, @plate, @state)', {
            ['@owner'] = xPlayer.identifier,
            ['@vehicle'] = json.encode({model = vehicleName}),
            ['@plate'] = GeneratePlate(),
            ['@state'] = 1
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du hast ein Fahrzeug erhalten: ' .. vehicleName)
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Es gab ein Problem beim Erhalten des Fahrzeugs.')
            end
        end)
    else
        TriggerClientEvent('esx:showNotification', source, 'Diese ID konnte nicht gefunden werden!')
    end
end)

RegisterNetEvent('bmw_cargarage:removeVehicle')
AddEventHandler('bmw_cargarage:removeVehicle', function(playerId, vehicleName)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
        MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner = @owner AND vehicle LIKE @vehicle', {
            ['@owner'] = xPlayer.identifier,
            ['@vehicle'] = json.encode({model = vehicleName})
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du hast das Fahrzeug entfernt: ' .. vehicleName)
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Es gab ein Problem beim Entfernen des Fahrzeugs.')
            end
        end)
    else
        print('Spieler nicht gefunden: ' .. playerId)
    end
end)

function GeneratePlate()
    local plate = ""
    for i = 1, 8 do
        if math.random(1, 2) == 1 then
            plate = plate .. string.char(math.random(65, 90))
        else
            plate = plate .. math.random(0, 9)
        end
    end
    return plate
end
