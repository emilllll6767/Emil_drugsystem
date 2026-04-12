fx_version 'cerulean'
game 'gta5'

description 'Komplet drugsystem!'
author 'Emil'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/bridge.lua'
}

client_scripts {
    'client/main.lua',
    'client/zones.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/security.lua',
    'server/main.lua',
    'server/processing.lua'
}

dependencies {
    'ox_lib',
    'ox_inventory',
    'sz_bridge'
}
