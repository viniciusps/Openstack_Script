#!/bin/bash

DIR=$(pwd)
NOK=$(echo -e " \033[0;31m Failed  \033[0m")
OK=$(echo -e " \033[0;32m OK  \033[0m")
if [ ! -d "$DIR/logs" ]; then
mkdir $DIR/logs
fi

LOGFILE="$DIR/logs/requirements.log"
if [ ! -d "$DIR/passwords" ]; then
mkdir $DIR/passwords
fi

PASSWORD_DIR="$DIR/passwords"
PASSWORD_FILE="$PASSWORD_DIR/passwords.log"
> $PASSWORD_FILE

## Basic Requirements for install Openstack
## Disabling NetworkManager, if is configured


## Checking whether NetworkManager is enabled or not

function check_network() {

RESULT=$(systemctl status NetworkManager.service | grep Active | cut -d: -f2 | awk '{ print $1 }')

if [ "$RESULT" = "active" ]; then
	echo "NetworkManager is active, disabling..." | tee $LOGFILE
	sleep 1
	chkconfig NetworkManager off 2> /dev/null 2>&1
	if [ $? = 0 ]; then
		echo $OK
		echo "Enabling network service" | tee $LOGFILE
		chkconfig network on 2> /dev/null 2>&1
		if [ $? = 0 ]; then
			echo $OK
			echo "Network service enabled" | tee $LOGFILE
		else
			echo $NOK
			echo "Network service can\'t be enabled" | tee $LOGFILE
			exit
		fi
	else
		echo "$NOK"
		echo "NetworkManager can\'t be disbled" | tee $LOGFILE
		exit
	fi
else
	echo "NetworkManager is already disabled [ $OK ] " | tee $LOGFILE
	echo "Checking network service..."
	sleep 2
	RESULT=$(systemctl status network.service | grep Active | cut -d: -f2 | awk '{ print $1 }')
	if [ "$RESULT" = "active" ]; then
		echo "Network service is already enabled, nothing to do [ $OK ] " | tee $LOGFILE
	else
		echo "$NOK"
		exit
	fi
fi

}

## Define Password for services in Openstack configuration


function define_passwords() {


echo "Type Keystone Database password: "
read KEYSTONE_DBPASS
echo "Type Admin password: "
read ADMIN_PASS
echo "Type Glance database password: "
read GLANCE_DBPASS
echo "Type Glance image password: "
read GLANCE_PASS
echo "Type Nova database password: "
read NOVA_DBPASS
echo "Type Nova password: "
read NOVA_PASS
echo "Type Neutron Database password: "
read NEUTRON_DBPASS
echo "Type Neutron password: "
read NEUTRON_PASS
echo "Type RabbitMQ Password:"
read RABBIT_PASS
echo "Type Database mysql root password: "
read MYSQL_PASS

if [ -z $KEYSTONE_DBPASS ] || [ -z $ADMIN_PASS ] || [ -z $GLANCE_DBPASS ] || [ -z $GLANCE_PASS ] || [ -z $NOVA_DBPASS ] || [ -z $NOVA_PASS ] || [ -z $NEUTRON_DBPASS ] || [ -z $NEUTRON_PASS ] || [ -z $RABBIT_PASS ]; then
	echo "Some Passwords wasn't defined [ $NOK ]" | tee $LOGFILE
	exit

fi

echo "KEYSTONE_DBPASS=$KEYSTONE_DBPASS" >> $PASSWORD_FILE
echo "ADMIN_PASS=$ADMIN_PASS" >> $PASSWORD_FILE
echo "GLANCE_DBPASS=$GLANCE_DBPASS" >> $PASSWORD_FILE
echo "GLANCE_PASS=$GLANCE_PASS" >> $PASSWORD_FILE
echo "NOVA_DBPASS=$NOVA_DBPASS" >> $PASSWORD_FILE
echo "NOVA_PASS=$NOVA_PASS" >> $PASSWORD_FILE
echo "NEUTRON_DBPASS=$NEUTRON_DBPASS" >> $PASSWORD_FILE
echo "NEUTRON_PASS=$NEUTRON_PASS" >> $PASSWORD_FILE
echo "RABBIT_PASS=$RABBIT_PASS" >> $PASSWORD_FILE
echo "MYSQL_PASS=$MYSQL_PASS" >> $PASSWORD_FILE

echo "Password File was generated... [ $OK ]" | tee $LOGFILE


}

define_passwords
