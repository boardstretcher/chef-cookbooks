# chef server installation

# prepare box
yum install -y vim epel-release wget

# download and verify
wget https://packages.chef.io/files/stable/chef-server/12.11.1/el/7/chef-server-core-12.11.1-1.el7.x86_64.rpm
curl https://downloads.chef.io/chef-server | grep -o 'c75.*379d'
sha256sum chef-server-core-12.11.1-1.el7.x86_64.rpm 

# install and configure
yum install -y chef-server-core-12.11.1-1.el7.x86_64.rpm 
chef-server-ctl reconfigure

# double check services are running
chef-server-ctl status

# install gui
chef-server-ctl install chef-manage
opscode-manage-ctl reconfigure
opscode-manage-ctl reconfigure

# create chefadmin/workforce
mkdir .chef
chef-server-ctl user-create chefadmin my user myuser1978@workforcesoftware.com 'fuck123' --filename /root/.chef/chefadmin.pem
chef-server-ctl org-create workforce Workforce --association_user chefadmin --filename /root/.chef/workforcevalidator.pem

# send keys to workstation
scp workforcevalidator.pem root@chef-workstation.sz-net.org:/root/chef-repo/.chef/
scp chefadmin.pem root@chef-workstation.sz-net.org:/root/chef-repo/.chef/
