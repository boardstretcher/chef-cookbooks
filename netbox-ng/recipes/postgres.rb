# opt directory required
directory '/opt/install-status' do
	recursive true
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

execute 'create-database' do
    # failures expected in check
    ignore_failure true
    # must be run as the postgres user
    user 'postgres'

    # commands to get database ready for netbox
    create_database = <<-EOC
    psql -c "CREATE DATABASE netbox_prod";
    psql -c "CREATE USER netbox_prod WITH PASSWORD 'ham'";
    psql -c "GRANT ALL PRIVILEGES ON DATABASE netbox_prod TO netbox_prod";
    EOC

    # run commands
    command create_database

    # only run if databse does not exist, do not create database again
	not_if 'ls /opt/install-status/postgres-done-install'
end

execute 'flag-as-complete' do
	command 'touch /opt/install-status/postgres-done-install'
	not_if 'ls /opt/install-status/postgres-done-install'
end

