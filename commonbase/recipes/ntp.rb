# Additional configuration for docker and kitchen testing
# Needed for local testing
if File.exist?('/.dockerenv')
	docker_testing 'setup' do
		action :setup_ntp
	end
end

if platform?('centos')
	# if the node is tagged as 'ntp' it will be configured as an ntp server
	# using ntp server variables from the environments file
	if tagged?('ntp')	
		package 'ntp' do
			action :install
		end

		service 'ntpd' do
			action [:enable, :start]
		end

		case node["hostname"]
		when /.*ntp01/
			template '/etc/ntp.conf' do
				source 'ntp-server.conf.erb'
				variables server2: node['ntp']['server2'],
				server3: node['ntp']['server3'],
				server4: node['ntp']['server4']
				notifies :restart, 'service[ntpd]'
			end # template
		end # end case

		case node["hostname"]
		when /.*ntp02/
			template '/etc/ntp.conf' do
				source 'ntp-server.conf.erb'
				variables server2: node['ntp']['server1'],
				server3: node['ntp']['server3'],
				server4: node['ntp']['server4']
				notifies :restart, 'service[ntpd]'
			end # template
		end # end case
	end	# end if ntp

	# if a node is not configured with a tag of 'ntp' then it will
	# be considered a client and configured with information to use 
	# the correct ntp servers from the environments file
	if ! tagged?('ntp')	
		service 'ntpd' do
			action [:enable, :start]
		end

		template '/etc/ntp.conf' do
			source 'ntp-client.conf.erb'
				variables server1: node['ntp']['server1'],
				server2: node['ntp']['server2'],
				server3: node['ntp']['server3'],
				server4: node['ntp']['server4']
				notifies :restart, 'service[ntpd]'
		end # template
	end # endif ntp
end # endif centos
