fx_version 'cerulean'
game 'gta5'

description 'esx-characterkill'
version '1.0.0'
author 'Kenta'

shared_scripts { 'config.lua', '@es_extended/imports.lua'
}
server_scripts { 'server/server.lua',
	'@oxmysql/lib/MySQL.lua'
}
