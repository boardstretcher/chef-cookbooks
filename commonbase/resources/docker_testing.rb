resource_name :docker_testing

## Docker setup for ntp
action :setup_ntp do
	package 'ntp'
end

## Docker setup for sssd
action :setup_sssd do
	package 'sssd'
	package 'authconfig'
	package 'initscripts'
	
	directory '/etc/chef/' do
		owner 'root'
		group 'root'
		mode '0755'
	end
	directory '/etc/sssd/' do
		owner 'root'
		group 'root'
		mode '0755'
	end
	file '/etc/sssd/sssd.conf' do
		action [:create_if_missing]
		mode '0600'
		owner 'root'
		group 'root'
	end
	file '/etc/pki/ca-trust/source/anchors/cert.pem' do
		action [:create_if_missing]
		mode '0600'
		owner 'root'
		group 'root'
	end
	execute 'basic config of sssd' do
		command 'authconfig --enableldap --enableldapauth --ldapserver=ldap.example.com --ldapbasedn=dc=example,dc=com --enableldapstarttls --enablemkhomedir --update'
	action :run
	end
end
