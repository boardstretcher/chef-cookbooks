resource_name :sssd_ng

property :group, String

action :configure do
	template '/etc/sssd/sssd.conf' do
		source 'sssd-ng.conf.erb'
		variables sssd_domain: node['auth']['domain'],
		sssd_ldap_uri_primary: node['auth']['ldap_uri_primary'],
		sssd_ldap_uri_secondary: node['auth']['ldap_uri_secondary'],
		sssd_search_base: node['auth']["search_base_#{new_resource.group}"],
		sssd_bind_username: node['auth']['bind_username'],
		sssd_bind_password: node['auth']['bind_password']
		notifies :restart, 'service[sssd]'
		not_if "service winbind status"
	end #template
end
