# auditd configuration

if platform?('centos')
	case node.environment
	when 'at'
		service 'auditd' do
			action [:enable, :start]
		end
		
		execute 'auditd-reload' do
		    command 'auditctl -R /etc/audit/rules.d/cis_centos7.rules'
				action :nothing
		end

		file '/etc/audit/auditd.conf' do
			action [:create_if_missing]
			mode '0640'
			owner 'root'
			group 'root'
		end
		
		template '/etc/audit/auditd.conf' do
			source 'auditd.conf.erb'
					notifies :run, 'execute[auditd-reload]'
		end # template

		file '/etc/audit/rules.d/cis_centos7.rules' do
			action [:create_if_missing]
			mode '0644'
			owner 'root'
			group 'root'
		end

        template '/etc/audit/rules.d/cis_centos7.rules' do
			source 'cis_centos7.rules.erb'
					notifies :run, 'execute[auditd-reload]'
		end # template

	end # case
end # endif
