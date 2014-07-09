bash "reload_sysctl" do
        code <<-EOH
        sysctl -p
        EOH
        action :nothing
end

delete_lines "ip6 line 1" do
  path "/etc/sysctl.conf"
  line "net.ipv6.conf.all.disable_ipv6 = 1"
  notifies :run, "bash[reload_sysctl]"
end

delete_lines "ip6 line 2" do
  path "/etc/sysctl.conf"
  line "net.ipv6.conf.default.disable_ipv6 = 1"
  notifies :run, "bash[reload_sysctl]"
end

append_if_no_line "ip6 hosts" do
  path "/etc/hosts"
  line "::1 localhost localhost.localdomain localhost6 localhost6.localdomain6"
end

service "ip6tables" do
  action :enable
end
