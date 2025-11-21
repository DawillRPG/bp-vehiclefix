local QBCore = exports['qb-core']:GetCoreObject()

-- Evento para reparar vehículo
RegisterNetEvent('bp-vehiclefix:repairVehicle', function(netId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then
        return
    end
    
    -- Verificar trabajo
    local jobName = Player.PlayerData.job.name
    if not Config.AllowedJobs[jobName] then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = Config.Messages['no_permission'],
            type = 'error'
        })
        return
    end
    
    -- Verificar items requeridos
    if next(Config.RequiredItems) then
        for itemName, _ in pairs(Config.RequiredItems) do
            local hasItem = Player.Functions.GetItemByName(itemName)
            if not hasItem then
                TriggerClientEvent('ox_lib:notify', src, {
                    title = 'Error',
                    description = 'No tienes los items necesarios',
                    type = 'error'
                })
                return
            end
        end
        
        -- Consumir items (opcional)
        -- for itemName, _ in pairs(Config.RequiredItems) do
        --     Player.Functions.RemoveItem(itemName, 1)
        -- end
    end
    
    -- Reparar vehículo en todos los clientes
    TriggerClientEvent('bp-vehiclefix:repairVehicleClient', -1, netId)
    
    -- Log de la reparación
    if Config.Debug then
        print(string.format('[bp-vehiclefix] Player %s (%s) repaired a vehicle', 
            Player.PlayerData.name, 
            Player.PlayerData.job.name
        ))
    end
end)

-- Comando para administradores
QBCore.Commands.Add('repairall', 'Reparar todos los vehículos (Admin)', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.admin then
        TriggerClientEvent('bp-vehiclefix:repairAllVehicles', source)
    end
end)

-- Evento para reparar todos los vehículos (solo admin)
RegisterNetEvent('bp-vehiclefix:repairAllVehicles', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player or not Player.PlayerData.admin then
        return
    end
    
    -- Enviar evento a todos los clientes para reparar todos los vehículos
    TriggerClientEvent('bp-vehiclefix:repairAllVehiclesClient', -1)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Admin',
        description = 'Todos los vehículos han sido reparados',
        type = 'success'
    })
end)

-- Comando para agregar trabajo a la lista permitida
QBCore.Commands.Add('addrepairjob', 'Agregar trabajo a la lista de reparación (Admin)', {{name = 'job', help = 'Nombre del trabajo'}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or not Player.PlayerData.admin then
        return
    end
    
    local jobName = args[1]
    if not jobName then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Debes especificar un nombre de trabajo',
            type = 'error'
        })
        return
    end
    
    Config.AllowedJobs[jobName] = true
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Éxito',
        description = 'Trabajo ' .. jobName .. ' agregado a la lista permitida',
        type = 'success'
    })
end)

-- Comando para remover trabajo de la lista permitida
QBCore.Commands.Add('removerepairjob', 'Remover trabajo de la lista de reparación (Admin)', {{name = 'job', help = 'Nombre del trabajo'}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or not Player.PlayerData.admin then
        return
    end
    
    local jobName = args[1]
    if not jobName then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Debes especificar un nombre de trabajo',
            type = 'error'
        })
        return
    end
    
    Config.AllowedJobs[jobName] = nil
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Éxito',
        description = 'Trabajo ' .. jobName .. ' removido de la lista permitida',
        type = 'success'
    })
end)

-- Comando para listar trabajos permitidos
QBCore.Commands.Add('listrepairjobs', 'Listar trabajos permitidos para reparación', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or not Player.PlayerData.admin then
        return
    end
    
    local jobList = {}
    for jobName, _ in pairs(Config.AllowedJobs) do
        table.insert(jobList, jobName)
    end
    
    local message = 'Trabajos permitidos: ' .. table.concat(jobList, ', ')
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Trabajos Permitidos',
        description = message,
        type = 'inform'
    })
end)

-- Evento cuando el jugador se conecta
RegisterNetEvent('QBCore:Server:PlayerLoaded', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player and Config.Debug then
        print(string.format('[bp-vehiclefix] Player %s connected with job: %s', 
            Player.PlayerData.name, 
            Player.PlayerData.job.name
        ))
    end
end) 