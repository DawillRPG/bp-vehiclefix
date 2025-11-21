# BP Vehicle Fix - Script de Reparación de Vehículos

Un script de FiveM que permite a mecánicos y trabajos específicos reparar vehículos fuera del taller usando ox_target, con la condición de que el bonete esté abierto.

## Características

- ✅ Reparación de vehículos fuera del taller
- ✅ Integración con ox_target
- ✅ Verificación de bonete abierto
- ✅ Sistema de trabajos configurable
- ✅ Animaciones y sonidos durante la reparación
- ✅ Barra de progreso con ox_lib
- ✅ Sistema de items requeridos (opcional)
- ✅ Comandos de administrador
- ✅ Debug mode para desarrolladores

## Dependencias

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [qb-core](https://github.com/qbcore-framework/qb-core)

## Instalación

1. Descarga o clona este repositorio en tu carpeta `resources`
2. Asegúrate de tener instaladas las dependencias mencionadas arriba
3. Agrega `ensure bp-vehiclefix` a tu `server.cfg`
4. Reinicia tu servidor

## Configuración

### Trabajos Permitidos

Edita el archivo `config.lua` para agregar o remover trabajos que pueden usar el script:

```lua
Config.AllowedJobs = {
    ['mechanic'] = true,
    ['lsc'] = true,
    ['tuner'] = true,
    ['auto_shop'] = true,
    ['tu_trabajo'] = true -- Agrega tu trabajo aquí
}
```

### Items Requeridos (Opcional)

Si quieres que los jugadores necesiten items específicos para reparar:

```lua
Config.RequiredItems = {
    ['repair_kit'] = true,
    ['wrench'] = true
}
```

### Tiempo de Reparación

Ajusta el tiempo que toma reparar un vehículo:

```lua
Config.RepairSettings.RepairTime = 10000 -- 10 segundos
```

## Uso

### Para Jugadores

1. Asegúrate de tener un trabajo permitido (mecánico, etc.)
2. Acércate a un vehículo
3. Abre el bonete del vehículo
4. Usa ox_target en el vehículo
5. Selecciona "Reparar Vehículo"
6. Espera a que termine la reparación

### Para Administradores

#### Comandos Disponibles

- `/repairall` - Repara todos los vehículos en el servidor
- `/addrepairjob [trabajo]` - Agrega un trabajo a la lista permitida
- `/removerepairjob [trabajo]` - Remueve un trabajo de la lista permitida
- `/listrepairjobs` - Lista todos los trabajos permitidos

#### Ejemplos

```bash
/addrepairjob mechanic
/removerepairjob tuner
/listrepairjobs
```

### Para Desarrolladores

Si tienes `Config.Debug = true`, puedes usar:

- `/testrepair` - Prueba la reparación en un vehículo cercano

## Configuración Avanzada

### Desactivar Verificación de Bonete

```lua
Config.RepairSettings.RequireHoodOpen = false
```

### Cambiar Animación

```lua
Config.Animations = {
    dict = 'mini@repair',
    anim = 'fixing_a_ped',
    flag = 1
}
```

### Cambiar Sonido

```lua
Config.Sounds = {
    repair = {
        name = 'Drill_Pin_Break',
        dict = 'DLC_HEIST_FLEECA_SOUNDSET'
    }
}
```

## Estructura del Proyecto

```
bp-vehiclefix/
├── fxmanifest.lua
├── config.lua
├── client/
│   └── main.lua
├── server/
│   └── main.lua
└── README.md
```

## Funcionalidades Técnicas

### Verificación de Bonete

El script verifica si el bonete está abierto comparando la posición del hueso del bonete con la posición del vehículo. Si la distancia es mayor a 0.5 unidades, considera que está abierto.

### Sistema de Permisos

- Verifica el trabajo del jugador en el servidor
- Solo permite trabajos configurados en `Config.AllowedJobs`
- Verifica items requeridos si están configurados

### Reparación Completa

El script repara:
- Motor y daños del vehículo
- Deformaciones
- Neumáticos
- Limpia la suciedad
- Enciende el motor

## Solución de Problemas

### El script no funciona

1. Verifica que tienes todas las dependencias instaladas
2. Asegúrate de que el script está en la carpeta correcta
3. Revisa la consola del servidor para errores
4. Verifica que tu trabajo está en la lista permitida

### No aparece la opción en ox_target

1. Verifica que tienes un trabajo permitido
2. Asegúrate de estar cerca del vehículo (máximo 3 metros)
3. Verifica que ox_target está funcionando correctamente

### El bonete no se detecta como abierto

1. Asegúrate de que el vehículo tiene un bonete
2. Intenta abrir y cerrar el bonete nuevamente
3. Algunos vehículos pueden no tener bonete (motos, etc.)

## Contribuciones

Si encuentras bugs o quieres agregar nuevas funcionalidades, no dudes en crear un issue o pull request.

## Licencia

Este script es de código abierto y está disponible bajo la licencia MIT.

## Soporte

Para soporte, puedes:
- Crear un issue en GitHub
- Contactar al desarrollador
- Revisar la documentación de las dependencias

---

**Nota**: Este script está diseñado para funcionar con QBCore Framework. Si usas otro framework, puede requerir modificaciones. 