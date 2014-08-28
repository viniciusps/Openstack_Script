#!/bin/bash

DIR=$(pwd)
LOGFILE="$DIR/logs/rabbitmq-server.log"
> $LOGFILE
NOK=$(echo -e " \033[0;31m Failed  \033[0m")
OK=$(echo -e " \033[0;32m OK  \033[0m")
PASSWORD_DIR="$DIR/passwords"
PASSWORD_FILE="$PASSWORD_DIR/passwords.log"
RABBIT_PASS=$(grep RABBIT $PASSWORD_FILE | cut -d= -f2) 


## installing message server

yum install rabbitmq-server

rpm -qa | grep rabbitmq-server
if [ $? != 0 ]; then
	echo "Failed to install RabbitMQ-Server [ $NOK ]" | tee $LOGFILE
	exit
fi

service rabbitmq-server start
chkconfig rabbitmq-server on

rabbitmqctl change_password guest $RABBIT_PASS
