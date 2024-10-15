local ESX = exports.es_extended:getSharedObject()

RegisterCommand('editgarage', function(source, args, rawCommand)
    local playerData = ESX.GetPlayerData()
    if playerData and playerData.group == 'admin' then
        OpenAdminMenu()
    else
        ESX.ShowNotification("Du hast keine Berechtigung dazu, da du mir nicht wie ein admin aussiehst, huhuhu...")
    end
end, false)

function OpenAdminMenu()
    local funktionen = {
        {label = '<span style="color:green;">Gebe ein Auto</span>', name = "autogeben"},
        {label = '<span style="color:red;">Nehme ein Auto weg</span>', name = "autowegnehmen"}
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "admin_menu", {
        title = "BMW_Cargarage | Admin Menu",
        align = 'top-left',
        elements = funktionen
    }, function(data, menu)
        if data.current.name == "autogeben" then
            menu.close()
            local input = lib.inputDialog('BMW_CarGarage | Fahrzeug geben', {
                {type = 'number', label = 'Spieler-ID', description = 'Gebe eine vorhandene Spieler ID an', icon = 'hashtag'},
            })

            if input == nil then
                ESX.ShowNotification("Du hast abgebrochen!")
            else
                local vehicleInput = lib.inputDialog('BMW_CarGarage | Fahrzeug geben', {
                    {type = 'input', label = 'Auto-Spawnname', description = 'Gebe einen Spawnnamen an vom jeweiligen Auto', required = true, min = 4, max = 16},
                })

                if vehicleInput then
                    local playerId = input[1]
                    local vehicleName = vehicleInput[1]
                    TriggerServerEvent('bmw_cargarage:giveVehicle', playerId, vehicleName)
                end
            end
        elseif data.current.name == "autowegnehmen" then
            menu.close()
            local input = lib.inputDialog('BMW_CarGarage | Fahrzeug wegnehmen', {
                {type = 'number', label = 'Spieler-ID', description = 'Gebe eine vorhandene Spieler ID an', icon = 'hashtag'},
            })

            if input == nil then
                ESX.ShowNotification("Du hast abgebrochen!")
            else
                local vehicleInput = lib.inputDialog('BMW_CarGarage | Fahrzeug wegnehmen', {
                    {type = 'input', label = 'Auto-Spawnname', description = 'Gebe den Spawnnamen des Fahrzeugs an', required = true, min = 4, max = 16},
                })

                if vehicleInput then
                    local playerId = input[1]
                    local vehicleName = vehicleInput[1]
                    TriggerServerEvent('bmw_cargarage:removeVehicle', playerId, vehicleName)
                end
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end

function AddNewGarage()
    local garageNameInput = lib.inputDialog('Neue Garage hinzufügen', {
        {type = 'input', label = 'Garage Name', required = true, min = 1, max = 30}
    })

    if garageNameInput then
        local garageName = garageNameInput[1]

        local pos = GetEntityCoords(PlayerPedId())
        local spawn = GetEntityCoords(PlayerPedId())
        local delete = GetEntityCoords(PlayerPedId())

        local coordinatesInput = lib.inputDialog('Koordinaten für die Garage', {
            {type = 'number', label = 'Auspark Koordinaten X', description = tostring(pos.x)},
            {type = 'number', label = 'Auspark Koordinaten Y', description = tostring(pos.y)},
            {type = 'number', label = 'Auspark Koordinaten Z', description = tostring(pos.z)},
            {type = 'number', label = 'Spawn Koordinaten X', description = tostring(spawn.x)},
            {type = 'number', label = 'Spawn Koordinaten Y', description = tostring(spawn.y)},
            {type = 'number', label = 'Spawn Koordinaten Z', description = tostring(spawn.z)},
            {type = 'number', label = 'Einpark Koordinaten X', description = tostring(delete.x)},
            {type = 'number', label = 'Einpark Koordinaten Y', description = tostring(delete.y)},
            {type = 'number', label = 'Einpark Koordinaten Z', description = tostring(delete.z)},
            {type = 'checkbox', label = 'Aktuelle Koordinaten verwenden', description = 'Benutze die aktuellen Koordinaten für alle Punkte.'}
        })

        if coordinatesInput then
            local useCurrentCoords = coordinatesInput[10]
            local garageConfig = {}

            if useCurrentCoords then
                garageConfig = {
                    Pos = {x = pos.x, y = pos.y, z = pos.z},
                    SpawnPoint = {x = spawn.x, y = spawn.y, z = spawn.z},
                    DeletePoint = {x = delete.x, y = delete.y, z = delete.z}
                }
            else
                garageConfig = {
                    Pos = {x = coordinatesInput[1], y = coordinatesInput[2], z = coordinatesInput[3]},
                    SpawnPoint = {x = coordinatesInput[4], y = coordinatesInput[5], z = coordinatesInput[6]},
                    DeletePoint = {x = coordinatesInput[7], y = coordinatesInput[8], z = coordinatesInput[9]}
                }
            end

            SaveGarageToConfig(garageName, garageConfig)
            ESX.ShowNotification("Neue Garage hinzugefügt: " .. garageName)
        end
    end
end

function SaveGarageToConfig(garageName, garageConfig)
    local configFilePath = 'home/FiveM/server/txData/ESXLegacy_F58552.base/resources/[Roleplay]/[Scripts]/bmw_cargarage/config/configuration.lua'

    local file = io.open(configFilePath, "a")
    if file then
        file:write(string.format("Config.Garages['%s'] = {\n    Pos = vector3(%.2f, %.2f, %.2f),\n    SpawnPoint = vector3(%.2f, %.2f, %.2f),\n    DeletePoint = vector3(%.2f, %.2f, %.2f)\n},\n",
            garageName, 
            garageConfig.Pos.x, garageConfig.Pos.y, garageConfig.Pos.z, 
            garageConfig.SpawnPoint.x, garageConfig.SpawnPoint.y, garageConfig.SpawnPoint.z, 
            garageConfig.DeletePoint.x, garageConfig.DeletePoint.y, garageConfig.DeletePoint.z))
        file:close()
    else
        ESX.ShowNotification("Fehler beim Speichern der Garage.")
    end
end

CreateThread(function()
    for garageName, garage in pairs(Config.Garages) do
        local pos = garage.Pos
        local delete = garage.DeletePoint

        CreateThread(function()
            while true do
                Wait(0)
                local playerCoords = GetEntityCoords(PlayerPedId())

                if #(playerCoords - pos) < 30.0 then
                    DrawMarker(36, pos.x, pos.y, pos.z + 0.0, 0, 0, 0, 0, 0, 0, 0.7, 0.5, 0.7, 0, 255, 0, 150, false, true, 2, false, false, false, false, false, false, false)
                    if #(playerCoords - pos) < 5.0 then
                    ESX.ShowHelpNotification('Drücke ~INPUT_CONTEXT~ um die Garage zu öffnen')

                    if IsControlJustReleased(0, 38) then
                        OpenGarageMenu(garageName, garage)
                    end
                end

                if #(playerCoords - delete) < 30.0 then
                    DrawMarker(24, delete.x, delete.y, delete.z + 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 150, false, true, 2, false, false, false, false, false, false, false)
                if #(playerCoords - delete) < 5.0 then
                    ESX.ShowHelpNotification('Drücke ~INPUT_CONTEXT~ um das Fahrzeug einzuparken')

                    if IsControlJustReleased(0, 38) then
                        ParkVehicle()
                            end
                        end
                    end
                end
            end
        end)
    end
end)

function OpenGarageMenu(garageName, garage)
    ESX.TriggerServerCallback('bmw_cargarage:getVehicles', function(vehicles)
        local elements = {}

        if #vehicles == 0 then
            ESX.ShowNotification('Du hast keine Fahrzeuge in dieser Garage.')
            return
        end

        for i=1, #vehicles, 1 do
            local vehicle = vehicles[i]
            local vehicleName = GetDisplayNameFromVehicleModel(vehicle.vehicle.model) or 'Unbekanntes Fahrzeug'
            local label = vehicleName .. ' - ' .. vehicle.plate
            
            if vehicle.state == 0 then
                label = label .. '<span style="color:red;"> [ausgeparkt]</span>'
            else
                label = label .. '<span style="color:green;"> [geparkt]</span>'
            end
            
            table.insert(elements, {label = label, value = vehicle})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
            css = 'garage',
            title = 'Garage - ' .. garageName,
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local vehicle = data.current.value
            if vehicle.state == 0 then
                ESX.ShowNotification('Dieses Fahrzeug ist bereits ausgeparkt.')
            else
                SpawnVehicle(vehicle, garage.SpawnPoint)
            end
        end, function(data, menu)
            menu.close()
        end)

        CreateThread(function()
            while ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'garage_menu') do
                Wait(1000)
                local playerCoords = GetEntityCoords(PlayerPedId())
                
                if #(playerCoords - garage.Pos) > 30.0 then
                    ESX.UI.Menu.CloseAll()
                    ESX.ShowNotification('Du hast die Garage verlassen, Menü geschlossen.')
                    break
                end
            end
        end)
    end)
end

function SpawnVehicle(vehicleData, spawnPoint)
    ESX.Game.SpawnVehicle(vehicleData.vehicle.model, spawnPoint, 0.0, function(vehicle)
        ESX.Game.SetVehicleProperties(vehicle, vehicleData.vehicle)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        TriggerServerEvent('bmw_cargarage:setVehicleOut', vehicleData.plate)
        ESX.ShowNotification('Fahrzeug ausgeparkt: ' .. vehicleData.plate)
        ESX.UI.Menu.CloseAll()
    end)
end

function ParkVehicle()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        ESX.TriggerServerCallback('bmw_cargarage:getVehicles', function(vehicles)
            for i=1, #vehicles, 1 do
                if vehicles[i].plate == vehicleProps.plate then
                    TriggerServerEvent('bmw_cargarage:setVehicleIn', vehicleProps.plate)
                    ESX.Game.DeleteVehicle(vehicle)
                    ESX.ShowNotification('Fahrzeug eingeparkt: ' .. vehicleProps.plate)
                    ESX.UI.Menu.CloseAll()
                    return
                end
            end
            ESX.ShowNotification('Dies ist nicht dein Fahrzeug.')
        end)
    else
        ESX.ShowNotification('Du bist nicht in einem Fahrzeug.')
    end
end
