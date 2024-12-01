#!/bin/bash
COLOR1='\033[0;31m'
COLOR2='\033[1;34m'
COLOR3='\033[1;33m'
NC='\033[0m' # No Color
# -----------------------------------------------------------
# check sudo permissions
# -----------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
    echo -e "${COLOR1} This script must be run as root ${NC}" 1>&2
    exit 1
fi


install_nginx(){
    echo
    echo -e "${COLOR2} UPDATE Packages ... ${NC}"
    apt-get update
    echo -e "${COLOR2} Nginx Installation ... ${NC}"
    echo
    apt-get install nginx-extras -y
    apt-get install libnginx-mod-stream -y
    echo
    echo -e "${COLOR2} Nginx Installation done ! ... ${NC}"
    echo
    systemctl start nginx
    sleep 10
    systemctl status nginx
    sleep 5
    bash installssl.sh
}

install_nginx