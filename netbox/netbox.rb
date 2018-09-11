# status:   DEVELOPMENT
# file:     default.rb
# purpose:  installation and configuration of netbox
# vim:      ts=4:sw=4

# epel required
package 'epel-release' do
    action :install
end

# opt directory required
directory '/opt/install-status' do
    recursive true
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

## INSTALLATION section
## This will only happen once

# python 2 requirements
%w{gcc python2 python-devel python-pip libxml2-devel libxslt-devel libffi-devel graphviz openssl-devel wget}.each do |p|
    package "#{p}" do
        action :install
    end
end

# grab versioned stable release and untar
execute 'install-netbox' do
    cwd '/opt'
    command 'wget https://github.com/digitalocean/netbox/archive/v2.1.3.tar.gz;
        tar xf v2.1.3.tar.gz;
        ln -s netbox-2.1.3 netbox;
        touch /opt/install-status/netbox-done-package;'
    not_if 'ls /opt/install-status/netbox-done-package'
end

# install python packages
execute 'pip-requirements' do
    cwd '/opt'
    command 'pip install -r netbox/requirements.txt;
        touch /opt/install-status/netbox-done-pip;'
    not_if 'ls /opt/install-status/netbox-done-pip'
end

template '/opt/netbox/netbox/netbox/configuration.py' do
    source 'configuration.py.erb'
end

# netbox migrate database schema
execute 'netbox-database-migrate' do
    cwd '/opt/netbox/netbox'
    command 'python manage.py migrate;
        touch /opt/install-status/netbox-done-dbconfig-migrate'
    not_if 'ls /opt/install-status/netbox-done-dbconfig-migrate'
end

# netbox superuser creation
execute 'netbox-superuser-config' do
	cwd '/opt/netbox/netbox'
	create_superuser = <<-EOC
	echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'szornes@workforcesoftware.com', 'ham')" | python manage.py shell;
	touch /opt/install-status/netbox-done-superuser;
	EOC
	command create_superuser
	not_if 'ls /opt/install-status/netbox-done-superuser'
end

# collect staticfiles
execute 'netbox-collectstatic' do
	cwd '/opt/netbox/netbox'
	collectstatic = <<-EOC
	python manage.py collectstatic --no-input;
	touch /opt/install-status/netbox-done-collectstatic;
	EOC
	command collectstatic
	not_if 'ls /opt/install-status/netbox-done-collectstatic'
end

# initial data install
execute 'netbox-install-data' do
	cwd '/opt/netbox/netbox'
	loadinitial = <<-EOC
	python manage.py loaddata initial_data;
	touch /opt/install-status/netbox-done-initialdata;
	EOC
	command loadinitial
	not_if 'ls /opt/install-status/netbox-done-initialdata'
end

## END INSTALLATION SECTION
