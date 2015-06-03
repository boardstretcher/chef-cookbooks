# basic configuration for linux nodes

# if virtualized, install xentools
	if node['virtualization']['systems']['xen'].match(/guest/)

	  # centos and rhel
      if platform_family?("rhel")
	    cookbook_file "/root/xe-guest-utilities-6.5.0-1393.x86_64.rpm" do
         source "xe-guest-utilities-6.5.0-1393.x86_64.rpm"
         mode "0644"
        end
	    cookbook_file "/root/xe-guest-utilities-xenstore-6.5.0-1393.x86_64.rpm" do
         source "xe-guest-utilities-xenstore-6.5.0-1393.x86_64.rpm"
         mode "0644"
        end
		execute "yum install -y /root/xe-guest-utilities-6.5.0-1393.x86_64.rpm /root/xe-guest-utilities-xenstore-6.5.0-1393.x86_64.rpm" do
		 command "yum install -y /root/xe-guest-utilities-6.5.0-1393.x86_64.rpm /root/xe-guest-utilities-xenstore-6.5.0-1393.x86_64.rpm"
		end
	  end

	  if platform_family?("debian")
        cookbook_file "/root/xe-guest-utilities_6.5.0-1393_amd64.deb" do
         source "xe-guest-utilities_6.5.0-1393_amd64.deb"
         mode "0644"
        end
        execute "dpkg -i /root/xe-guest-utilities_6.5.0-1393_amd64.deb" do
         command "dpkg -i /root/xe-guest-utilities_6.5.0-1393_amd64.deb"
        end
      end
	end # end virtualized section

# directory colors
	cookbook_file "/etc/DIR_COLORS" do
	  source "DIR_COLORS"
	  mode "0644"
	end

# resolver configuration
	cookbook_file "/etc/resolv.conf" do
	  source "resolv.conf"
	  mode "0644"
	end

# disable iptables
	service "ip6tables" do
	  action :disable
	end

	service "iptables" do
	  action :disable
	end

# enable and configure ntp

	package "ntp" do
		action :install
	end

	package "ntpdate" do
        action :install
	end

    if platform_family?("debian")
	 service "ntp" do
		supports :restart => true
		action :nothing
	 end
    cookbook_file "/etc/ntp.conf" do
        source "ntp.conf"
        mode 0644
        owner "root"
        group "root"
        notifies :restart, "service[ntp]", :delayed
    end
    end

    if platform_family?("rhel")
     service "ntpd" do
        supports :restart => true
        action :nothing
     end
    cookbook_file "/etc/ntp.conf" do
        source "ntp.conf"
        mode 0644
        owner "root"
        group "root"
        notifies :restart, "service[ntpd]", :delayed
    end
    end

# configure vim colors 
	execute "curl https://gist.githubusercontent.com/boardstretcher/c8e9430befb9ca04415e/raw/8399895df47dd767bc6a9916f0539575d4b7f64c/setup-vim.sh | bash" do
		command "curl https://gist.githubusercontent.com/boardstretcher/c8e9430befb9ca04415e/raw/8399895df47dd767bc6a9916f0539575d4b7f64c/setup-vim.sh | bash"
	end

