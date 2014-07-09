template "/etc/my.cnf" do
        source "my.cnf.erb"
        mode 0644
        owner "root"
        group "root"
        case node['fqdn']
		when 'web3.website.com'
                        node.default[:soweb][:serverid] = "3"
                when 'web4.website.com'
                        node.default[:soweb][:serverid] = "4"
                when 'web5.website.com'
                        node.default[:soweb][:serverid] = "5"
                when 'web6.website.com'
                        node.default[:soweb][:serverid] = "6"
		when 'web7.website.com'
                        node.default[:soweb][:serverid] = "7"
                when 'web10.lasvegas.website.lan'
                        node.default[:soweb][:serverid] = "10"
                when 'web20.lasvegas.website.lan'
                        node.default[:soweb][:serverid] = "20"
		when 'web30.lasvegas.website.lan'
                        node.default[:soweb][:serverid] = "40"
                when 'web40.lasvegas.website.lan'
                        node.default[:soweb][:serverid] = "40"
        end
	action :create
end
