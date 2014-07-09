#
# Cookbook Name:: so-addtodns
# Recipe:: default
#

if platform_family?("rhel")
 yum_package "mysql" do
        action :install
        not_if "rpm -qa | grep mysql-5."
 end
end

if node['network']['interfaces']['bond0:1'].nil?
 bash "add_to_powerdns" do
        code <<-EOH
	mysql -h67.203.70.53 -uremote_add_dns -pjustdnsRECORDS -e "INSERT INTO poweradmin.records (domain_id, name, type, content, ttl, prio, change_date)\
	SELECT * FROM (SELECT 1, '#{node[:fqdn]}', 'A', '#{node[:ipaddress]}', 3600, 0, UNIX_TIMESTAMP(now())) AS tmp\
	WHERE NOT EXISTS ( SELECT name FROM poweradmin.records WHERE name = '#{node[:fqdn]}') LIMIT 1;"
        EOH
 end
end

if ! node['network']['interfaces']['bond0:1'].nil?
 bash "add_to_powerdns" do
        code <<-EOH
        mysql -h67.203.70.53 -uremote_add_dns -pjustdnsRECORDS -e "INSERT INTO poweradmin.records (domain_id, name, type, content, ttl, prio, change_date)\
        SELECT * FROM (SELECT 1, '#{node[:fqdn]}', 'A', '#{node['network']['interfaces']['bond0:1']}', 3600, 0, UNIX_TIMESTAMP(now())) AS tmp\
        WHERE NOT EXISTS ( SELECT name FROM poweradmin.records WHERE name = '#{node[:fqdn]}') LIMIT 1;"
        EOH
 end
end


#INSERT INTO poweradmin.records (domain_id, name, type, content, ttl, prio, change_date)\
#SELECT * FROM (SELECT 1, '#{node[:fqdn]}', 'A', '#{node[:ipaddress]}', 3600, 0, UNIX_TIMESTAMP(now())) AS tmp\
#WHERE NOT EXISTS ( SELECT name FROM poweradmin.records WHERE name = '#{node[:fqdn]}') LIMIT 1;

