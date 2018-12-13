# host_setup.sh

# install snmp 
# install observium client/xinet.d

#!/bin/bash -x
#

# exit on any error
set -e

# if no parameters, show usage
if [ -z "$1" ]; then
	echo "usage:"
	echo ""
	echo "set up SNMP and OBSERVIUM:"
	echo "./host_setup.sh somehost.somewhere.website.lan"
	exit; end;
fi

# install required files for snmp
yum install -y net-snmp-utils net-snmp net-snmp-libs net-snmp-perl perl-YAML.noarch perl-YAML-Syck.x86_64 perl-YAML-Tiny.noarch 

# install required perl stuff
echo "check for LWP: perl -MLWP -le \"print(LWP->VERSION)\""
echo "install LWP: perl -MCPAN -e'install \"LWP::Simple\"'"


# change hostname in snmpd.conf
sed -i "s/XXX/$1/g" /usr/share/snmp/snmpd.conf

# start or restart snmpd
if ps aux | grep "snmpd" > /dev/null
    then
        echo "snmpd running, restarting"
        service snmpd restart
    else
        echo "snmpd not running, starting"
        service snmpd start
fi

