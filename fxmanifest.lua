fx_version 'adamant'
game 'gta5'
description 'hh_sskey'
lua54 'yes'
shared_scripts {'@ox_lib/init.lua', 'Config.lua'}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
    '@oxmysql/lib/MySQL.lua'
}

