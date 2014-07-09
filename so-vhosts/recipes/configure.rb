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

