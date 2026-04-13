fx_version 'cerulean'
game 'gta5'

description 'Sz_Bridge - Universal Framework Wrapper'
version '1.0.0'

shared_scripts {
    'config.lua',
    'init.lua',
    'modules/**/shared.lua'
}

client_scripts {
    'modules/**/client.lua'
}

server_scripts {
    'modules/**/server.lua'
}

-- Exports definition (exposing the exact functions requested)
export 'getCore'
export 'getPlayer'
export 'getIdentifier'
export 'hasItem'
export 'addItem'
export 'removeItem'
export 'sendDispatch'
export 'progressBar'
export 'notify'
export 'textUI'
export 'teleport'
export 'banPlayer'
export 'getTeam'
export 'sendLog'
export 'spawnVehicle'
export 'setFuel'
export 'giveKeys'
