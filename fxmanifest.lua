fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ExtraCommands'
author 'HRScripts Development'
description 'A script that concludes the needed commands when you\'re not with a framework'
version '1.0.0'

shared_script '@HRLib/import.lua'

client_script 'client.lua'

server_script 'server.lua'

files {
    'config.lua',
    'translation.lua'
}

dependency 'HRLib'