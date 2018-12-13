#
# Cookbook Name:: so-remove-yumupdate
# Recipe:: default
#
if platform_family?("rhel")
 yum_package "yum-autoupdate" do
        package_name "yum-autoupdate" 
        action :remove
        only_if "rpm -qa | grep yum-autoupdate"
 end
end
