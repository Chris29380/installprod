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

# -----------------------------------------------------------
# base
# -----------------------------------------------------------

echo -e "\n${COLOR3}Install Mariadb Server ? ${NC}(y/n)"
echo -e "\n${COLOR3}----------------------${NC}"
read -p "Mariadb Install : " mariadbinstall
if [ "${mariadbinstall}" == "y" ]; then 
    echo
    echo -e "${COLOR2} Loading Mariadb installation ... ${NC}"       
    bash installmariadb.sh
else
    if [ "${mariadbinstall}" == "n" ] || [ "${mariadbinstall}" == "" ]; then
        echo -e "${COLOR2} Skip Mariadb installation ... ${NC}"
    fi
fi

echo -e "\n${COLOR3}Configure User SQL ? ${NC}(y/n)"
echo -e "\n${COLOR3}----------------------${NC}"
read -p "User SQL : " usersqlinstall
if [ "${usersqlinstall}" == "y" ]; then 
    echo
    echo -e "${COLOR2} Loading User SQL Configuration ... ${NC}"       
    bash usersql.sh
else
    if [ "${usersqlinstall}" == "n" ] || [ "${usersqlinstall}" == "" ]; then
        echo -e "${COLOR2} Skip User SQL Configuration ... ${NC}"
    fi
fi

echo -e "\n${COLOR3}Install php8.2 ? ${NC}(y/n)"
echo -e "\n${COLOR3}----------------------${NC}"
read -p "Php 8.2 : " phpinstall
if [ "${phpinstall}" == "y" ]; then 
    echo
    echo -e "${COLOR2} Loading PHP8.2 Installation ... ${NC}"       
    bash installphp8-2.sh
else
    if [ "${phpinstall}" == "n" ] || [ "${phpinstall}" == "" ]; then
        echo -e "${COLOR2} Skip PHP8.2 Installation ... ${NC}"
    fi
fi

echo -e "\n${COLOR3}Install Nginx Web Server ? ${NC}(y/n)"
echo -e "\n${COLOR3}----------------------${NC}"
read -p "Nginx : " nginxinstall
if [ "${nginxinstall}" == "y" ]; then 
    echo
    echo -e "${COLOR2} Loading Nginx Installation ... ${NC}"       
    bash installnginx.sh
else
    if [ "${nginxinstall}" == "n" ] || [ "${nginxinstall}" == "" ]; then
        echo -e "${COLOR2} Skip Nginx Installation ... ${NC}"
    fi
fi

echo -e "\n${COLOR3}Install PhpMyAdmin ? ${NC}(y/n)"
echo -e "\n${COLOR3}----------------------${NC}"
read -p "PhpMyAdmin : " phpminstall
if [ "${phpminstall}" == "y" ]; then 
    echo
    echo -e "${COLOR2} Loading PhpMyAdmin Installation ... ${NC}"       
    bash installphpmyadmin.sh
else
    if [ "${phpminstall}" == "n" ] || [ "${phpminstall}" == "" ]; then
        echo -e "${COLOR2} Skip PhpMyAdmin Installation ... ${NC}"
    fi
fi

echo -e "\n${COLOR3}Install DDOS Protection ? ${NC}(y/n)"
echo -e "\n${COLOR3}----------------------${NC}"
read -p "ddosprotect : " ddosinstall
if [ "${ddosinstall}" == "y" ]; then 
    echo
    echo -e "${COLOR2} Loading DDOS Protection ... ${NC}"       
    bash installddos.sh
else
    if [ "${ddosinstall}" == "n" ] || [ "${ddosinstall}" == "" ]; then
        echo -e "${COLOR2} Skip DDOS Protection ... ${NC}"
    fi
fi