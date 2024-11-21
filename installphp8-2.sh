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

install_php(){
    echo
    echo -e "${COLOR2} UPDATE Packages ... ${NC}"
    apt-get update
    echo -e "${COLOR2} PHP 8.2 Installation ... ${NC}"
    echo
    apt-get install php8.2 php8.2-cli php8.2-{bz2,curl,mbstring,intl,fpm} -y
    apt purge apache2 apache2-utils
    echo
    echo -e "${COLOR2} PHP 8.2 Installation done ! ... ${NC}"
    echo
}

install_php

