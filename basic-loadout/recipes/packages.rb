# install basic programs
	%w{vim curl wget ntp}.each do |p|
		package "#{p}" do
			action :install
		end
	end

# on centos, remove autoupdate
	if platform_family?("rhel")
		yum_package "yum-autoupdate" do
			package_name "yum-autoupdate" 
			action :remove
			only_if "rpm -qa | grep yum-autoupdate"
		end
		yum_package "epel-release" do
			package_name "epel-release"
			action :install
		end
	end
