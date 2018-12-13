# custom configuration for centos yum

if platform?("centos")
    template '/etc/yum.conf' do
        source 'yum.conf.erb'
    end
end
