# varnish config
directory "/etc/varnish" do
	action :create
	recursive true
	mode 0755
end
remote_directory "/etc/varnish" do
        source "varnish"
        files_owner "root"
        files_group "root"
        files_mode 00644
        owner "root"
        group "root"
        mode 0755
end

# m.anywhere.conf template
if node['network']['interfaces']['bond0:1']
	vhost_ipaddress = node['network']['interfaces']['bond0:1']['addresses'].first[0]
	else
	vhost_ipaddress = node['ipaddress']
end

if node['network']['interfaces']['eth1:1']
        vhost_ipaddress = node['network']['interfaces']['eth1:1']['addresses'].first[0]
        else
        vhost_ipaddress = node['ipaddress']
end

template "/etc/httpd/vhost.d/m.anywhere.conf" do
        source "m.anywhere.conf.erb"
        mode 0644
        owner "root"
        group "root"
	variables(
		:vhost_ipaddress => vhost_ipaddress
	)
	action :create
end

