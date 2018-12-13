# This recipe will install a custom sssd template for centos machines depending
# on the geo that it resides it. If the node is tagged with disys/groupex, the
# configuration for that need will be written out. 
#
# This recipe also manages the sssd certificates and reloads the cert store
# if a change is made

if platform?("centos")
	# Additional configuration for docker and kitchen testing
	# Needed for local testing
	if File.exist?('/.dockerenv')	
		docker_testing 'setup' do
			action :setup_sssd
		end
	end

	# Function for reloading the certificate trust, this does not run on its
	# own and must be called from a 'notifies' statement in a chef block
	execute 'cert-reload' do
		command 'update-ca-trust && update-ca-trust enable && update-ca-trust check && systemctl restart sssd'
		action :nothing
		not_if "service winbind status"
	end
			
    # This will write out the certificate from the base/files directory
	# and run the 'cert-reload' function from above if needed
    cookbook_file "/etc/pki/ca-trust/source/anchors/#{node['auth']['subcaname']}" do
        source "#{node['auth']['subcaname']}"
        owner 'root'
        group 'root'
        mode '0644'
        action :create
        notifies :run, 'execute[cert-reload]'
        not_if "service winbind status"
    end

	# write out the sssd configuration using the sssd_ng resource (resources/sssd_ng.rb)
	# based on the tag of the node. if there is no tag, it gets the default sssd search base
	# from the environments file
	if tagged?('groupex')
		sssd_ng 'manage search base' do
 			group 'groupex'
 			action :configure
		end
	elsif tagged?('disys')
		sssd_ng 'manage search base' do
			group 'disys'
            action :configure
        end
	elsif tagged?('unicorn1')
       sssd_ng 'manage search base' do
            group 'alt1'
            action :configure
        end
	elsif tagged?('unicorn2')
       sssd_ng 'manage search base' do
            group 'alt2'
            action :configure
        end
	elsif tagged?('unicorn3')
       sssd_ng 'manage search base' do
            group 'alt3'
            action :configure
        end
	else
       sssd_ng 'manage search base' do
            group 'default'
            action :configure
        end
	end

    # Ensure the service is enabled and started, not if winbind is installed
    # and running
    service 'sssd' do
        action [:enable, :start,]
        not_if "service winbind status"
    end
end #end if
