# This recipe will install a custom postfix main.cf file and an aliases file
# that can be used centos platform wide

if platform?("centos")

	# Ensure the service is enabled and started, not if winbind is installed
	# and running
	service 'postfix' do
	    # action :restart
		action [:enable, :start,]
	end

	execute 'newaliases' do
        command 'newaliases'
        action :nothing
    end

	case node.environment
	when 'at'
		cookbook_file '/etc/aliases' do
			source 'aliases'
			owner 'root'
			group 'root'
			mode '0644'
			action :create
			notifies :run, 'execute[newaliases]'
		end

		template '/etc/postfix/main.cf' do
			source 'postfix-main.erb'
			variables postfix_domain: node['auth']['domain'],
			postfix_relayhost: node['postfix']['relayhost']
			notifies :restart, 'service[postfix]'
		end #template

	end #end case
end #end if
