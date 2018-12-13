# This recipe will ensure that the "Domain Users" group and ID exists
# in the /etc/group file for all versions of Centos

if platform?("centos")
	# Variable names
	# node['auth']['groupname']
	# node['auth']['groupid']
	groupline = node['auth']['groupname'] + ":x:" + node['auth']['groupid'] + ":"
	ruby_block "insert_line" do
		block do
			file = Chef::Util::FileEdit.new("/etc/group")
			file.insert_line_if_no_match(groupline, groupline)
			file.write_file
		end
	end
end #end if