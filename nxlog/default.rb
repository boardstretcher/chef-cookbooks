#
# Cookbook Name:: so-nxlog
# Recipe:: default
#
if platform_family?("rhel")

 yum_package "http://downloads.sourceforge.net/project/nxlog-ce/nxlog-ce-2.7.1191-1.x86_64.rpm" do
	       action :localinstall
 end

 template "/etc/init.d/nxlog" do
        source "nxlog.init.erb"
        mode 0644
        owner "root"
        group "root"
 end

 template "/etc/nxlog.conf" do
        source "nxlog.conf.erb"
        mode 0644
        owner "root"
        group "root"
 end

end
