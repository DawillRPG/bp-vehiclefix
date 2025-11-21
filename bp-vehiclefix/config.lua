Config = {}

-- Configuración general
Config.Debug = false -- Activar/desactivar debug

-- Trabajos que pueden usar el script
Config.AllowedJobs = {
    ['mechanic'] = true,
    ['mechanic2'] = true,
    ['mechanic3'] = true,
}

-- Configuración de reparación
Config.RepairSettings = {
    -- Tiempo de reparación en milisegundos
    RepairTime = 10000, -- 10 segundos
    
    -- Distancia máxima para reparar
    MaxDistance = 3.0,
    
    -- Requerir bonete abierto
    RequireHoodOpen = true,
    
    -- Animación durante la reparación
    UseAnimation = true,
    
    -- Sonido durante la reparación
    UseSound = true
}

-- Configuración de ox_target
Config.TargetSettings = {
    -- Modelo del objeto para ox_target (opcional)
    TargetModel = nil,
    
    -- Offset del target
    Offset = {
        x = 0.0,
        y = 0.0,
        z = 0.0
    },
    
    -- Tamaño del target
    Size = {
        x = 1.0,
        y = 1.0,
        z = 1.0
    }
}

-- Mensajes
Config.Messages = {
    ['no_permission'] = 'No tienes permiso para usar esta herramienta',
    ['hood_closed'] = 'Necesitas abrir el bonete del vehículo',
    ['repairing'] = 'Reparando vehículo...',
    ['repair_complete'] = 'Vehículo reparado exitosamente',
    ['repair_failed'] = 'Error al reparar el vehículo',
    ['too_far'] = 'Estás muy lejos del vehículo',
    ['not_in_vehicle'] = 'No puedes reparar desde dentro del vehículo'
}

-- Items requeridos (opcional)
Config.RequiredItems = {
   ['repair_kit'] = true,
    -- ['wrench'] = true
}

-- Configuración de animaciones
Config.Animations = {
    dict = 'mini@repair',
    anim = 'fixing_a_ped',
    flag = 1
}

-- Configuración de sonidos
Config.Sounds = {
    repair = {
        name = 'Drill_Pin_Break',
        dict = 'DLC_HEIST_FLEECA_SOUNDSET'
    }
} 