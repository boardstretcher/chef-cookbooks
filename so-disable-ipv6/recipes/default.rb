bash "reload_sysctl" do
        code <<-EOH
        sysctl -p
        EOH
        action :nothing
end

append_if_no_line "ip6 line 1" do
  path "/etc/sysctl.conf"
  line "net.ipv6.conf.all.disable_ipv6 = 1"
  notifies :run, "bash[reload_sysctl]"
end

append_if_no_line "ip6 line 2" do
  path "/etc/sysctl.conf"
  line "net.ipv6.conf.default.disable_ipv6 = 1"
  notifies :run, "bash[reload_sysctl]"
end

delete_lines "remove broken lines from sysctl 1" do
  path "/etc/sysctl.conf"
  pattern "net.bridge.bridge-nf-call-ip6tables"
end

delete_lines "remove broken lines from sysctl 2" do
  path "/etc/sysctl.conf"
  pattern "net.bridge.bridge-nf-call-iptables"
end

delete_lines "remove broken lines from sysctl 3" do
  path "/etc/sysctl.conf"
  pattern "net.bridge.bridge-nf-call-arptables"
end

service "ip6tables" do
  action :disable
end
