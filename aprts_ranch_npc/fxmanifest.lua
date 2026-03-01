fx_version "adamant"
lua54 'yes'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'SpoiledMouse'
version '1.0'
description 'aprts_ranch_npc'

games {"rdr3"}

client_scripts {'config.lua','client/warmenu.lua','client/client.lua','client/events.lua','client/renderer.lua', 'client/menu.lua'}
server_scripts {'@oxmysql/lib/MySQL.lua','config.lua','server/server.lua','server/events.lua'}


ui_page "nui://jo_libs/nui/menu/index.html"

shared_scripts {'@jo_libs/init.lua','@ox_lib/init.lua'}

jo_libs {'menu'}