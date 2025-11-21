local QBCore = exports['qb-core']:GetCoreObject()
local isRepairing = false
local currentVehicle = nil

-- Función para verificar si el jugador tiene un trabajo permitido
local function HasAllowedJob()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not PlayerData or not PlayerData.job then
        return false
    end
    
    return Config.AllowedJobs[PlayerData.job.name] == true
end

-- Función para verificar si el bonete está abierto
local function IsHoodOpen(vehicle)
    if not Config.RepairSettings.RequireHoodOpen then
        return true
    end
    
    local hoodBone = GetEntityBoneIndexByName(vehicle, 'bonnet')
    if hoodBone == -1 then
        return true -- Si no tiene bonete, permitir reparación
    end
    
    local hoodCoords = GetWorldPositionOfEntityBone(vehicle, hoodBone)
    local vehicleCoords = GetEntityCoords(vehicle)
    local distance = #(hoodCoords - vehicleCoords)
    
    -- Si la distancia es mayor a 0.5, el bonete está abierto
    return distance > 0.5
end

-- Función para verificar items requeridos
local function HasRequiredItems()
    if not next(Config.RequiredItems) then
        return true
    end
    
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not PlayerData or not PlayerData.items then
        return false
    end
    
    for itemName, _ in pairs(Config.RequiredItems) do
        local hasItem = QBCore.Functions.HasItem(itemName)
        if not hasItem then
            return false
        end
    end
    
    return true
end

-- Función para reproducir animación
local function PlayRepairAnimation()
    if not Config.RepairSettings.UseAnimation then
        return
    end
    
    local ped = PlayerPedId()
    local animDict = Config.Animations.dict
    local animName = Config.Animations.anim
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    
    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, Config.Animations.flag, 0, false, false, false)
end

-- Función para reproducir sonido
local function PlayRepairSound()
    if not Config.RepairSettings.UseSound then
        return
    end
    
    local soundDict = Config.Sounds.repair.dict
    local soundName = Config.Sounds.repair.name
    
    RequestScriptAudioBank(soundDict, false)
    PlaySoundFromCoord(-1, soundName, GetEntityCoords(currentVehicle), soundDict, false, 0, false)
end

-- Función para reparar vehículo
local function RepairVehicle(vehicle)
    if isRepairing then
        return
    end
    
    -- Verificar permisos
    if not HasAllowedJob() then
        lib.notify({
            title = 'Error',
            description = Config.Messages['no_permission'],
            type = 'error'
        })
        return
    end
    
    -- Verificar distancia
    local playerCoords = GetEntityCoords(PlayerPedId())
    local vehicleCoords = GetEntityCoords(vehicle)
    local distance = #(playerCoords - vehicleCoords)
    
    if distance > Config.RepairSettings.MaxDistance then
        lib.notify({
            title = 'Error',
            description = Config.Messages['too_far'],
            type = 'error'
        })
        return
    end
    
    -- Verificar si está dentro del vehículo
    if IsPedInVehicle(PlayerPedId(), vehicle, false) then
        lib.notify({
            title = 'Error',
            description = Config.Messages['not_in_vehicle'],
            type = 'error'
        })
        return
    end
    
    -- Verificar bonete
    if not IsHoodOpen(vehicle) then
        lib.notify({
            title = 'Error',
            description = Config.Messages['hood_closed'],
            type = 'error'
        })
        return
    end
    
    -- Verificar items
    if not HasRequiredItems() then
        lib.notify({
            title = 'Error',
            description = 'No tienes los items necesarios',
            type = 'error'
        })
        return
    end
    
    -- Iniciar reparación
    isRepairing = true
    currentVehicle = vehicle
    
    -- Mostrar progreso
    if lib.progressBar({
        duration = Config.RepairSettings.RepairTime,
        label = Config.Messages['repairing'],
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = Config.Animations.dict,
            clip = Config.Animations.anim
        }
    }) then
        -- Reparación exitosa
        TriggerServerEvent('bp-vehiclefix:repairVehicle', NetworkGetNetworkIdFromEntity(vehicle))
        
        lib.notify({
            title = 'Éxito',
            description = Config.Messages['repair_complete'],
            type = 'success'
        })
    else
        -- Reparación cancelada
        lib.notify({
            title = 'Cancelado',
            description = 'Reparación cancelada',
            type = 'inform'
        })
    end
    
    isRepairing = false
    currentVehicle = nil
end

-- Configurar ox_target para vehículos
CreateThread(function()
    exports.ox_target:addGlobalVehicle({
        {
            name = 'repair_vehicle',
            icon = 'fas fa-wrench',
            label = 'Reparar Vehículo',
            canInteract = function(entity, distance, coords, name)
                -- Solo mostrar si tiene trabajo permitido
                return HasAllowedJob() and distance <= Config.RepairSettings.MaxDistance
            end,
            onSelect = function(data)
                RepairVehicle(data.entity)
            end
        }
    })
end)

-- Evento para reparar vehículo desde el servidor
RegisterNetEvent('bp-vehiclefix:repairVehicleClient', function(netId)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true, true)
        
        -- Limpiar suciedad
        SetVehicleDirtLevel(vehicle, 0.0)
        
        -- Reparar neumáticos
        SetVehicleTyreFixed(vehicle, 0)
        SetVehicleTyreFixed(vehicle, 1)
        SetVehicleTyreFixed(vehicle, 2)
        SetVehicleTyreFixed(vehicle, 3)
        SetVehicleTyreFixed(vehicle, 4)
        SetVehicleTyreFixed(vehicle, 5)
        
        if Config.Debug then
            print('Vehículo reparado: ' .. GetEntityModel(vehicle))
        end
    end
end)

-- Comando de debug (solo para desarrolladores)
if Config.Debug then
    RegisterCommand('testrepair', function()
        local vehicle = GetVehiclePedIsNear(PlayerPedId(), 3.0)
        if vehicle ~= 0 then
            RepairVehicle(vehicle)
        else
            lib.notify({
                title = 'Debug',
                description = 'No hay vehículo cerca',
                type = 'error'
            })
        end
    end, false)
end

-- Evento para reparar todos los vehículos (solo admin)
RegisterNetEvent('bp-vehiclefix:repairAllVehiclesClient', function()
    local vehicles = GetGamePool('CVehicle')
    local repairedCount = 0
    
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if DoesEntityExist(vehicle) then
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, true, true)
            SetVehicleDirtLevel(vehicle, 0.0)
            
            -- Reparar neumáticos
            for j = 0, 5 do
                SetVehicleTyreFixed(vehicle, j)
            end
            
            repairedCount = repairedCount + 1
        end
    end
    
    if Config.Debug then
        print('Vehículos reparados: ' .. repairedCount)
    end
end) 