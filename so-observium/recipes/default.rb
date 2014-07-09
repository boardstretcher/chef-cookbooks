#
# Cookbook Name:: so-observium
# Recipe:: default
#
#


# notifies
bash "add_to_observium" do
	code <<-EOH
	sshpass -p "password" ssh -oStrictHostKeyChecking=no 67.203.70.50 "cd /opt/observium; ./add_device.php #{node[:fqdn]} website_read v2c 161 udp; chown -R www-data:www-data .; ./discovery.php -h #{node[:fqdn]}; ./poller.php -h #{node[:fqdn]}"
	EOH
	action :nothing
end

service "snmpd" do
  supports :restart => true
  action :nothing
end 

service "iptables" do
  action :disable
  action :stop
end

#yum package installs (only if redhat)
%w{epel-release net-snmp net-snmp-utils net-snmp-perl net-snmp-libs perl-YAML perl-CPAN perl-YAML-Syck perl-YAML-Tiny sshpass}.each do |p|
        yum_package "#{p}" do
                action :install
        end
end

#not needed with new client
cpan_client 'LWP::Simple' do
    user 'root'
    group 'root'
    version '0'
    install_type 'cpan_module'
    action 'install'
end

# make sure files are up to date for ALL observium clients
directory "/usr/share/snmp" do
        action :create
        recursive true
        mode 0755
end
directory "/usr/lib/observium_agent/local" do
        action :create
        recursive true
        mode 0755
end

template "/usr/share/snmp/snmpd.conf" do
        source "snmpd.conf"
        mode 0644
        owner "root"
        group "root"
	# if this file is not there/different, assume smtp needs a restart
	notifies :restart, "service[snmpd]", :delayed
end

template "/etc/snmp/snmpd.conf" do
        source "etc_snmp_snmpd.conf"
        mode 0644
        owner "root"
        group "root"
        # if this file is not there/different, assume smtp needs a restart
        notifies :restart, "service[snmpd]", :delayed
        end
        
template "/etc/xinetd.d/observium_agent.xinet" do
        source "observium_agent.xinet"
        mode 0644
        owner "root"
        group "root"
	# if this file is not there -- assume it needs added to observium
  	notifies :run, "bash[add_to_observium]"
end

template "/usr/bin/observium_agent" do
        source "observium_agent"
        mode 0644
        owner "root"
        group "root"
end

template "/usr/bin/distro" do
        source "distro"
        mode 0644
        owner "root"
        group "root"
end

directory "/usr/lib/observium_agent/local" do
        action :create
        recursive true
        mode 0755
end

remote_directory "/usr/lib/observium_agent/local" do
        source "agents"
        files_owner "root"
        files_group "root"
        files_mode 00644
        owner "root"
        group "root"
        mode 0755
end
