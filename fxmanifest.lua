fx_version "bodacious"
games {"gta5"}


version '2.0'

server_script "@mysql-async/lib/MySQL.lua"

client_script {                                -- Client
'client.lua',
'baska_config.lua'
}

server_script {
'mysql-async/lib/MySQL.lua',
'server.lua',
'baska_config.lua'
}
