# bootstrap the client
knife bootstrap 138.197.0.127 --ssh-user root --ssh-password yellow --node-name chef-client
knife node run_list add chef-client motd_update
knife node show chef-client
