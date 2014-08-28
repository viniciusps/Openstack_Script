#!/bin/bash

DIR=$(pwd)
LOGFILE="$DIR/logs/mysql_install.log"
> $LOGFILE
CONFIG_FILE="/etc/my.cnf"
NOK=$(echo -e " \033[0;31m Failed  \033[0m")
OK=$(echo -e " \033[0;32m OK  \033[0m")

## Installing and configuring mysql-server
##

funtion install_mysql() {

yum install mysql-server

rpm -qa | grep mariadb-server 2> /dev/null 2>&1

if [ $? != 0 ]; then
	echo "MariaDB is not installed [ $NOK ]" | tee $LOGFILE
else
	echo "MariaDB installed, continuing..."
fi

NMLINE=$(grep -n "^\[mysqld\]" /etc/my.cnf| cut -d: -f1)
let NMLINE++
sed -i -e $NMLINE'i'"bind-address=0.0.0.0" $CONFIG_FILE
let NMLINE++
sed -i -e $NMLINE'i'"default-storage-engine = innodb" $CONFIG_FILE
let NMLINE++
sed -i -e $NMLINE'i'"innodb_file_per_table" $CONFIG_FILE
let NMLINE++
sed -i -e $NMLINE'i'"collation-server = utf8_general_ci" $CONFIG_FILE
let NMLINE++
sed -i -e $NMLINE'i'"init-connect = 'SET NAMES utf8'" $CONFIG_FILE
let NMLINE++
sed -i -e $NMLINE'i'"character-set-server = utf8" $CONFIG_FILE


service mariadb start
chkconfig mariadb on
rm -rf /var/lib/mysql/aria_log_control
mysql_install_db
mysql_secure_installation

}
