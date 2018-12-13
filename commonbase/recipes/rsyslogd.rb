# install a custom rsyslogd template for centos machines
if platform?("centos")

	if tagged?('syslog')	
		service 'rsyslog' do
				action [:enable, :start]
		end
		
		template '/etc/rsyslog.conf' do
		source 'rsyslog-server.conf.erb'
		notifies :restart, 'service[rsyslog]'
		end
	end

	if ! tagged?('syslog')
		if node['platform_version'].to_f <= 6.9
			#package 'rsyslog'
			#package 'rsyslog-gnutls'
			file '/etc/rsyslog.conf' do
				action [:create_if_missing]
				mode '0644'
				owner 'root'
				group 'root'
			end
			template '/etc/rsyslog.conf' do
				source 'rsyslog6.conf.erb'
				variables syslog_server: node['logging']['server1']
				notifies :restart, 'service[rsyslog]'
			end
			service 'rsyslog' do
				action [:enable, :start]
			end
		end #endif

		if node['platform_version'].to_f >= 7.0
			#package 'rsyslog'
			#package 'rsyslog-gnutls'
			file '/etc/rsyslog.conf' do
				action [:create_if_missing]
				mode '0644'
				owner 'root'
				group 'root'
			end
			template '/etc/rsyslog.conf' do
				source 'rsyslog7.conf.erb'
				variables syslog_server: node['logging']['server1']
			    notifies :restart, 'service[rsyslog]'
			end #template
			service 'rsyslog' do
				action [:enable, :start]
			end
		end #endif
	end #tagged
end #endif
