fx_version 'cerulean'
game 'gta5'

author 'Gege'
version '1.0.0'
description 'Vehicle handling editor'

dependencies {
    'ScaleformUI_Assets',
    'ScaleformUI_Lua'
}

client_scripts {
    "@ScaleformUI_Lua/ScaleformUI.lua",
    'client.lua',
    'config.lua'
}