fx_version 'adamant'

game 'gta5'

author 'Jan.-'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/client.lua',
	'config.lua'
}

dependencies {
	'es_extended',
}

exports {
	'ConfiscateVehicle',
}