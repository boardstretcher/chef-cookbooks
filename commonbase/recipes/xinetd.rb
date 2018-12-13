# purpose:  xinetd configuration (primarily for checkmk) 

if platform?('centos')

	# Start and enable the service
	service 'xinetd' do
		action [:enable, :start]
	end

	# Write out a custom agent file with information from the
	# environments/*.json files
	template '/etc/xinetd.d/check-mk-agent' do
		source 'check-mk-agent.erb'
			variables server1: node['check-mk']['server1']
			notifies :restart, 'service[xinetd]'
	end #template

end # endif
