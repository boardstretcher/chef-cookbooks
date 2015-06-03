#include_recipe "database::mysql"

# send zip file
	cookbook_file "/root/bugify-v1.6.1136.zip" do
	source "bugify-v1.6.1136.zip"
	mode 0644
	owner "root"
	group "root"
	end


# create a mysql database
#	mysql_database 'bugify' do
#	connection ({
#			:host => "localhost", 
#			:username => 'bugify', 
#			:password => 'mty3asz7v5r3e'
#	})
#	action :create
#	end
