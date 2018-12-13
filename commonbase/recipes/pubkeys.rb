# install any public keys and user accounts on machines

if platform?('centos')

		$domain = node['auth']['domain']
		$groupid = "Domain\ Users"
		
		directory "/home/#$domain" do 	
			owner 'root' 	
			group 'root' 	
			mode '0755' 
		end
    	directory "/home/#$domain/svc_acct_rundeck" do 	
			owner 'svc_acct_rundeck' 	
			group "#$groupid"
			mode '0700'
			only_if "id svc_acct_rundeck" 
		end
		directory "/home/#$domain/svc_acct_rundeck/.ssh" do 	
			owner 'svc_acct_rundeck' 	
			group "#$groupid"
			mode '0700' 
			only_if "id svc_acct_rundeck" 
		end

		file "/home/#$domain/svc_acct_rundeck/.ssh/authorized_keys" do
			action [:create_if_missing]
			mode '0600'
			owner 'svc_acct_rundeck'
			group "#$groupid"
			only_if "stat /home/#$domain/svc_acct_rundeck/.ssh" 
		end

		cookbook_file "/home/#$domain/svc_acct_rundeck/.bashrc" do
			source 'skel-bashrc'
			owner 'svc_acct_rundeck'
			group "#$groupid"
			mode '0744'
			action :create
			not_if "stat /home/#$domain/svc_acct_rundeck/.bashrc"
		end
		cookbook_file "/home/#$domain/svc_acct_rundeck/.bash_profile" do
			source 'skel-bashprofile'
			owner 'svc_acct_rundeck'
			group "#$groupid"
			mode '0744'
			action :create
			not_if "stat /home/#$domain/svc_acct_rundeck/.bash_profile"
		end

		template "/home/#$domain/svc_acct_rundeck/.ssh/authorized_keys" do
			source "pubkey-rundeck.erb"
		end
end # endif