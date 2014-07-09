if platform_family?("rhel")
 include_recipe "yum-rsyslog::default"

 yum_package "rsyslog-elasticsearch" do
        action :install
 end

 service "rsyslog" do
        supports :restart => true, :stop => true, :start => true
        action :nothing
 end 

 bash "logger_test" do
        code <<-EOH
	logger test
        EOH
 	action :nothing
 end

 template "/etc/rsyslog.conf" do
        source "rsyslog.conf.erb"
        mode 0644
        owner "root"
        group "root"
        notifies :stop, "service[rsyslog]"
	notifies :start, "service[rsyslog]"
        notifies :run, "bash[logger_test]"
 end

 template "/etc/rsyslog.d/elasticsearch.conf" do
        source "elasticsearch.conf.erb"
        mode 0644
        owner "root"
        group "root"
        notifies :stop, "service[rsyslog]"
	notifies :start, "service[rsyslog]"
        notifies :run, "bash[logger_test]"
 end

end
