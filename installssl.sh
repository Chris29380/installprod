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

install_ssl(){
    echo
    echo -e "${COLOR2} COPY SSL Certificates ... ${NC}"
    echo -e "\n You must have copy/paste ssl certificate pem and key in ssl directory"
    echo -e "\n before use this ssl installation, however files are empty..."
    echo
    echo -e "\n${COLOR2} Stop Nginx Server ... ${NC}"
    systemctl stop nginx
    echo
    echo -e "\n${COLOR2} Create ssl directory in /etc/nginx/ssl ... ${NC}"
    mkdir /etc/nginx/ssl
    cp ./ssl/certif.pem /etc/nginx/ssl/certif.pem
    cp ./ssl/certif.key /etc/nginx/ssl/certif.key
    echo
    echo -e "\n${COLOR2} Start Nginx Server ... ${NC}"
    systemctl start nginx
    echo
    echo -e "\n${COLOR2} SSL Files installation done ! ... ${NC}"
    echo
    echo -e "\n${COLOR2} Copy prodssl.conf in /etc/nginx/sites-enabled ... ${NC}"
    cp ./nginxfiles/prodssl.conf /etc/nginx/sites-enabled/prodssl.conf
    echo
    echo -e "\n${COLOR2} Nginx Copy Configuration Files done ! ... ${NC}"
    echo
    echo -e "\n${COLOR3}Url Server Prod ? ${NC}(ex: play.serverrp.com)"
    echo -e "You must add A or CNAME Register in your Cloudflare DNS for this url"
    echo -e "point to the ip of this server"
    echo -e "if you have a proxy, name this url for ex: prod.serverrp.com"
    read -p "Url : " urlprod
    if [ "${urlprod}" != "" ]; then
        sed -i "s/urlprod_here/$urlprod/g" /etc/nginx/sites-enabled/prodssl.conf
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi

    echo
    echo -e "\n${COLOR3}Fivem server port ? ${NC}(default: 30120)"    
    read -p "Port Cfx Server : " cfxport
    if [ "${cfxport}" != "" ] && [ "${cfxport}" -ge 0 ] && [ "${cfxport}" -le 65535 ]; then
        sed -i "s/ipprod_port_here/localhost:$cfxport/g" /etc/nginx/sites-enabled/prodssl.conf
    else
        echo
        echo -e "\n${COLOR1}Port is empty, or wrong value [ 0 - 65535 ] ... ${NC}"
        exit 0
    fi

    echo -e "\n${COLOR3}txAdmin Port ? ${NC}(default:40120)"
    read -p "txAdmin port: " txport       
    if [ "${txport}" -ge 0 ] && [ "${txport}" -le 65535 ]; then
        veriftxport="ok"
    else
        echo -e "\n${COLOR1}Wrong txport number${NC} it must be 0 to 65535"
        exit 0
    fi
    if [ "${veriftxport}" == "ok" ]; then
        echo
        echo -e "\n${COLOR2} Nginx Copy txAdmin Configuration Files ... ${NC}"
        echo
        cp ./nginxfiles/prodssltx.conf /etc/nginx/sites-enabled/prodssltx.conf
        echo
        echo -e "\n${COLOR2} Nginx Configure txAdmin ... ${NC}"
        echo
        echo -e "\n${COLOR3}Url Tx Admin ? ${NC}(ex: txadmin.serverrp.com)"
        echo -e "You must add A or CNAME Register in your Cloudflare DNS for this url"
        echo -e "point to the ip of this server"
        read -p "Url : " urltx
        if [ "${urltx}" != "" ]; then
            sed -i "s/urltx_here/$urltx/g" /etc/nginx/sites-enabled/prodssltx.conf
        else
            echo
            echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
            exit 0
        fi
        sed -i "s/iptxprod_port_here/localhost:$txport/g" /etc/nginx/sites-enabled/prodssltx.conf

    fi
    cp ./nginxfiles/nginx.conf /etc/nginx/nginx.conf
    cp ./nginxfiles/default /etc/nginx/sites-available/default
    echo
    echo -e "\n${COLOR2}Configuration files done ! ... ${NC}"
    echo
}

install_ssl