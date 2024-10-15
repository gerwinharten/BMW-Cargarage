fx_version("cerulean")
game("gta5")
author("Mr. BMW")
description("Free Edition of BMW Garage for esx legacy.")
version("V1")
lua54("yes")
shared_script("@ox_lib/init.lua")

server_scripts({
    "config/configuration.lua",
    "@oxmysql/lib/MySQL.lua",
    "server/main.lua",
})

client_scripts({
    "config/configuration.lua",
    "client/main.lua",
})

dependency({
    "es_extended",
    "oxmysql"
})