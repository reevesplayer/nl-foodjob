fx_version 'cerulean'
game 'gta5'

author 'Cryptic/Rip'
description 'Food Delivery Job'
version '1.0.0'

shared_scripts {
    'config.lua',
    -- '@ox_lib/init.lua'
}

server_scripts {
    'server/main.lua',
    'server/version.lua'
}

client_scripts {
    'client/main.lua',
    'client/client_open.lua',
}
