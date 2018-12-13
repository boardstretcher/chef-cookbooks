# SO  web server loadout

include_recipe 'so-web-servers::packages'
include_recipe 'so-web-servers::sync'
include_recipe 'so-web-servers::configure'
include_recipe 'so-web-servers::mysql'

