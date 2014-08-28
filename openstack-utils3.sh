#!/bin/bash
## 3
## Installing Openstack Packages
NOK=$(echo -e " \033[0;31m Failed  \033[0m")
OK=$(echo -e " \033[0;32m OK  \033[0m")
DIR=$(pwd)
LOGFILE="$DIR/logs/openstack-utils.log"
> $LOGFILE



yum install yum-plugin-priorities
yum install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install openstack-utils

rpm -qa | grep openstack-utils

if [ $? != 0 ]; then
	echo "There was a problem when installing openstack-utils [ $NOK ]"  | tee $LOGFILE
	exit
fi

echo "Warning: Please disable your SELinux for avoid problems" | tee $LOGFILE
