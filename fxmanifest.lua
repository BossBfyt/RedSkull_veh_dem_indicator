fx_version 'bodacious'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

files {
    'html/index.html',
    'html/css/styles.css',
    'html/js/index.js',
}

client_scripts {
	'config_c.lua',
	'client/function.lua',
    'client/main.lua'
}

ui_page 'html/index.html'