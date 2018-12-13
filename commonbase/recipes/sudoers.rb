# custom sudoers templates

if platform?('centos')

	## GENERAL SECTION
	## Config that will be applied to all centos linux hosts

	directory '/etc/sudoers.d/' do
		owner 'root'
		group 'root'
		mode '0755'
	end	

	# for each of these items in the curly braces, do a loop and create a file
	# with that name
	%w{fwbuilder monitor}.each do |fn|
		file "#{fn}" do
			action [:create_if_missing]
			mode '0440'
			owner 'root'
			group 'root'
		end
		# for each item in the curly braces, populate that named file from the corresponding template
		# in the templates directory
		template "/etc/sudoers.d/#{fn}" do
			source "sudoers-#{fn}.erb"
		end
	end # for loop

	file "/etc/sudoers" do
		action [:create_if_missing]
		mode "0644"
		owner "root"
		group "root"
	end

	template "/etc/sudoers" do
		source "sudoers.erb"
	end
end # endif
