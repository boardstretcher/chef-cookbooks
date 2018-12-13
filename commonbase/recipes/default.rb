#
# default base recipes for all linux clients
#

include_recipe 'wfs-commonbase::bashrc'
include_recipe 'wfs-commonbase::group'
include_recipe 'wfs-commonbase::rsyslogd'
include_recipe 'wfs-commonbase::sssd-ng'
include_recipe 'wfs-commonbase::sudoers'
include_recipe 'wfs-commonbase::yum'
include_recipe 'wfs-commonbase::ntp'
include_recipe 'wfs-commonbase::centos-base-repo'


#
# Test recipes not yet applied to production
#

#incldue_recipe 'wfs-commonbase::standard-packages'
#include_recipe 'wfs-commonbase::pubkeys'
#include_recipe 'wfs-commonbase::auditd'
#include_recipe 'wfs-commonbase::resolv'
#include_recipe 'wfs-commonbase::postfix'