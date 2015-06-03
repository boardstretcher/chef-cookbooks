if platform?("centos")
	execute "yum update -y" do
		command "yum update -y"
	end
end

if platform?("debian")
	execute "apt-get update; apt-get upgrade -y" do
		command "apt-get update; apt-get upgrade -y"
	end
end
