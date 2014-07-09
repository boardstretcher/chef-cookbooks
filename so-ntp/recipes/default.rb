#
# Cookbook Name:: so-ntp
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
yum_package "ntp" do
	action :install
end

yum_package "ntpdate" do
        action :install
end

service "ntpd" do
	supports :restart => true
	action :nothing
end 

template "/etc/ntp.conf" do
	source "ntp.conf.erb"
	mode 0644
	owner "root"
	group "root"
	notifies :restart, "service[ntpd]", :delayed
end
