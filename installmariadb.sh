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

ismariadb=$(dpkg-query -l | grep -E "^.i *mariadb-server")

if [ "${ismariadb}" != "" ]; then
    echo
    echo -e "${COLOR2} REMOVE Mariadb Server ... ${NC}"
    apt-get remove mariadb-server -y
    apt-get remove mariadb-server-core -y
    apt autoremove -y
fi

install_sql(){
    echo
    echo -e "${COLOR2} UPDATE Packages ... ${NC}"
    apt-get update
    echo -e "${COLOR2} Mariadb Server Installation ... ${NC}"
    echo
    apt-get install mariadb-server -y
    bash securemysql.sh
}

install_sql