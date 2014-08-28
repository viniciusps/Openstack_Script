#!/bin/bash

NOK=$(echo -e " \033[0;31m Failed  \033[0m")
OK=$(echo -e " \033[0;32m OK  \033[0m")
DIR=$(pwd)
LOGFILE="$DIR/logs/keystone-install.log"
> $LOGFILE
PASSWORD_DIR="$DIR/passwords"
PASSWORD_FILE="$PASSWORD_DIR/passwords.log"
source $PASSWORD_FILE
MYSQL_PASS=$(grep MYSQL $PASSWORD_FILE | cut -d= -f2)
KEYSTONE_DBPASS=$(grep KEYSTONE_DBPASS $PASSWORD_FILE | cut -d= -f2)


define_database() {
	mysql --user="root" --password="$MYSQL_PASS" --execute="CREATE DATABASE keystone;"
	mysql --user="root" --password="$MYSQL_PASS" --execute="GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY $KEYSTONE_DBPASS;"
	mysql --user="root" --password="$MYSQL_PASS" --execute="GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%'  IDENTIFIED BY $KEYSTONE_DBPASS;"

	echo "checking database configurations..."
	sleep 1
	mysql --user=keystone --password="$KEYSTONE_DBPASS" --execute="use keystone;show tables;" | tee $LOGFILE	
	if [ $? != 0 ]; then
		echo "Error while access keystone database configuration... [ $NOK ]" | tee $LOGFILE
		exit
	fi
}


install_packages() {
	 yum install openstack-keystone python-keystoneclient
	rpm -qa | grep openstack-keystone
	RESP1=$?
	rpm -qa | grep python-keystoneclient
	RESP2=$?
	if [ != 0 $RESP1 ] || [ != 0 $RESP2 ]; then
		echo "Error While Install keystone components [ $NOK ]" | tee $LOGFILE
		exit
	fi
}

config_files() {
echo a

}

create_admin_tenant() {
echo a

}

create_endpoint(){
echo a

}

check_token() {
echo a

}

set_environments() {
echo q

}

