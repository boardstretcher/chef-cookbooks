# install a custom bashrc template for centos machines

if platform?('centos')
	if node['platform_version'].to_f <= 6.9
		file '/etc/bashrc' do
			action [:create_if_missing]
			mode '0644'
			owner 'root'
			group 'root'
		end
		template '/etc/bashrc' do
			source 'bashrc6.erb'
		end
	end #endif

	if node['platform_version'].to_f >= 7.0
		file '/etc/bashrc' do
			action [:create_if_missing]
			mode '0644'
			owner 'root'
			group 'root'
		end
		template '/etc/bashrc' do
			source 'bashrc7.erb'
		end
	end # endif
end # endif