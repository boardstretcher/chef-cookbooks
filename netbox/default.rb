# status:	DEVELOPMENT
# file:     default.rb
# purpose:  configure netbox
# vim:      ts=4:sw=4

# this recipe only supports centos 7.3
if platform?("centos")
	case node['platform_version']
	when '7.3.1611'

include_recipe 'postgres::default'
include_recipe 'netbox::postgres'
include_recpie 'netbox::netbox'

	end
end
