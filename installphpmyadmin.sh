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

basic_single_escape () {
    echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g'
}

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
    echo -e "${COLOR2}PHPmyadmin Configuration ... ${NC}"
    cp ./phpmyadmin/config.inc.php /usr/share/phpmyadmin/config.inc.php
    echo
    echo -e "\n${COLOR3}Pma User name ? ${NC}"
    read -p "User name : " pmauser
    echo
    echo -e "\n${COLOR3}Pma password ? ${NC}"
    read -p "Pma password : " pmapwd
    if [ "${pmauser}" != "" ]; then
        pmauserc=`basic_single_escape "$pmauser"`
        sed -i "s/user_here/$pmauserc/g" /usr/share/phpmyadmin/config.inc.php
    else
        echo
        echo -e "\n${COLOR1}field is empty, stop the process... ${NC}"
        exit 0
    fi
    if [ "${pmapwd}" != "" ]; then
        pmapwdc=`basic_single_escape "$pmapwd"`
        sed -i "s/pwd_here/$pmapwdc/g" /usr/share/phpmyadmin/config.inc.php
    else
        echo
        echo -e "\n${COLOR1}field is empty, stop the process... ${NC}"
        exit 0
    fi
    echo
    echo -e "\n${COLOR2}Configuration files done ! ... ${NC}"
    echo
}

install_phpm