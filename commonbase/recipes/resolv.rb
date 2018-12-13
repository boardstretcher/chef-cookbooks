# This recipe will install a custom resolv.conf file for each geo
# that can be used centos platform wide

if platform?("centos")
	case node.environment
	when 'at'
		template '/etc/resolv.conf' do
			source 'resolv.conf.erb'
			variables resolv_domain: node['auth']['domain'],
			resolv_dns1: node['resolv']['dns1'],
			resolv_dns2: node['resolv']['dns2']
		end #template
	end #end case
end #end if