#
# Cookbook Name:: so-nxlog
# Recipe:: default
#
if platform_family?("rhel")

 remote_file "#{Chef::Config[:file_cache_path]}/nxlog-ce-2.5.1089-1.x86_64.rpm" do
	source "http://downloads.sourceforge.net/project/nxlog-ce/older-releases/nxlog-ce-2.5.1089-1.x86_64.rpm"
	action :create
	not_if "rpm -qa | grep nxlog"
 end

 yum_package "nxlog" do
	source "#{Chef::Config[:file_cache_path]}/nxlog-ce-2.5.1089-1.x86_64.rpm"
	action :install
	not_if "rpm -qa | grep nxlog"
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
