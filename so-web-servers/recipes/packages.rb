if platform?("scientific")
 %w{nfs-utils nfs-utils-lib libmemcache libmemcache-devel php-pecl-memcache 
varnish httpd php php-mysql php-pdo php-cli php-mcrypt php-xml php-pear 
php-pecl-memcached php-common }.each do |p|
        yum_package "#{p}" do
                action :install
        end
 end
end

if platform?("centos")
 %w{nfs-utils nfs-utils-lib libmemcache libmemcache-devel varnish  
httpd php php-mysql php-pdo php-cli php-mcrypt php-xml php-pear php-common }.each do |p|
        yum_package "#{p}" do
                action :install
        end
 end
end


