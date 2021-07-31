fx_version 'cerulean'
game 'gta5'

author 'Tutya & Ekhion'
description 'Economy - Caching'
version '0.1 beta'

shared_script {
    '@es_extended/locale.lua',
    'config.lua',
    'locales/*.lua',
}

client_scripts {
    'libs/point.lua',
    'libs/object.lua',
    'libs/hud.lua',
    'libs/statistics.lua',
    'libs/shop.lua',
    'libs/control.lua',
    'libs/helper.lua',
    'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'libs/reward.lua',
    'server/main.lua',
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/styles.css',
    'html/js/*.js',
    'html/img/*.*',
    'html/img/item/*.*'
}