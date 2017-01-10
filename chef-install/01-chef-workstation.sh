# chef workstation installation

# prepare
yum install -y vim epel-release
echo "138.197.0.104 chef-server" >> /etc/hosts

# get the package
wget https://packages.chef.io/files/stable/chefdk/1.1.16/el/7/chefdk-1.1.16-1.el7.x86_64.rpm

# get the sha and compare
curl https://downloads.chef.io/chefdk | grep -o 'b6bf.*bdb9'
sha256sum chefdk-1.1.16-1.el7.x86_64.rpm 

# install the packages
yum install -y figlet chefdk-1.1.16-1.el7.x86_64.rpm 

# make a repo to work from
mkdir -pv chef-repo/cookbooks
cd chef-repo/cookbooks

# generate the cookbook and template file
chef generate cookbook motd_update
chef generate template motd_update motd

# populate cookbook and template file
echo "# This machine is configured and managed by: " > motd_update/templates/motd.erb 
figlet CHEF >> motd_update/templates/motd.erb
cat << EOF > motd_update/recipes/default.rb
#
# Cookbook:: motd_update
# Recipe:: default
#

template '/etc/motd' do
source 'motd.erb'
end
EOF 

# test the cookbook locally
chef-client --local-mode --runlist 'recipe[motd_update]'
