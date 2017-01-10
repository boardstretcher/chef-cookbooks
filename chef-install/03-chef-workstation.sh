# workstation configuration continued

# grab chef-starter from the chef gui under 'workforce' orginization
unzip chef-starter.zip 

# grab ssl config from server
cd chef-repo/.chef
knife ssl fetch
knife ssl check

# check connection
knife user list
knife client list

# upload my motd cookbook to server
cd chef-repo/cookbooks
knife cookbook upload motd_update
