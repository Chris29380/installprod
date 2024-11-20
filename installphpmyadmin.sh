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

install_phpm(){
    echo
    echo -e "${COLOR2}UPDATE Packages ... ${NC}"
    apt-get update
    echo
    echo -e "${COLOR2}PHPmyadmin Installation ... ${NC}"
    apt-get install phpmyadmin -y
    echo
    echo -e "\n${COLOR3}Url PhpMyAdmin ? ${NC}(ex: phpmyadmin.serverrp.com)"
    echo -e "You must add A or CNAME Register in your Cloudflare DNS for this url"
    echo -e "point to the ip of this server"
    echo -e "then acces panel admin with : phpmyadmin.serverrp.com/phpmyadmin"
    read -p "Url : " urlphpm
    if [ "${urlphpm}" != "" ]; then
        sed -i "s/urlprodphp_here/$urlphpm/g" /etc/nginx/sites-enabled/prodssl.conf
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi
    echo
    echo -e "\n${COLOR2}Configuration files done ! ... ${NC}"
    echo
}

install_phpm