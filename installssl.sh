#!/bin/bash
COLOR1='\033[0;31m'
COLOR2='\033[1;34m'
COLOR3='\033[1;33m'
NC='\033[0m' # No Color
VALID=0
# -----------------------------------------------------------
# check sudo permissions
# -----------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
    echo -e "${COLOR1} This script must be run as root ${NC}" 1>&2
    exit 1
fi

install_ssl(){

    echo
    echo -e "${COLOR2} Copy Nginx Configuration Files ... ${NC}"
    cp ./nginxfiles/nginx.conf /etc/nginx/nginx.conf
    cp ./nginxfiles/default /etc/nginx/sites-available/default
    cp ./nginxfiles/default /etc/nginx/sites-enabled/default

    echo
    echo -e "${COLOR2} Certbot Installation ... ${NC}"
    apt install -y certbot python3-certbot-nginx
    sleep 10
    echo
    echo -e "\n${COLOR2} Stop Nginx Server ... ${NC}"
    systemctl stop nginx
    read -p "Machine Url : " urlmachine
    if [ "${urlmachine}" != "" ]; then
        sed -i "s/machine_url_here/$urlmachine/g" /etc/nginx/sites-enabled/default
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi
    echo
    echo -e "${COLOR2} Create SSL Certificates ... ${NC}"
    read -p "play Url : " urlplay
    if [ "${urlplay}" != "" ]; then
        sed -i "s/play_url_here/$urlplay/g" /etc/nginx/sites-enabled/default
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi
    echo
    read -p "tx Url : " urltx
    if [ "${urltx}" != "" ]; then
        sed -i "s/urltx_here/$urltx/g" /etc/nginx/sites-enabled/default
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi
    echo
    read -p "php Url : " urlphp
    if [ "${urlphp}" != "" ]; then
        sed -i "s/urlprodphp_here/$urlphp/g" /etc/nginx/sites-enabled/default
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi
    echo
    read -p "panel Url : " urlpanel
    if [ "${urlpanel}" != "" ]; then
        sed -i "s/urlprodpanel_here/$urlpanel/g" /etc/nginx/sites-enabled/default
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi
    echo
    echo -e "\n${COLOR3}Fivem server port ? ${NC}(default: 30120)"    
    read -p "Port Cfx Server : " cfxport
    echo
    echo -e "\n${COLOR3}txAdmin Port ? ${NC}(default:40120)"
    read -p "txAdmin port: " txport 

    if [ "${cfxport}" != "" ] && [ "${cfxport}" -ge 0 ] && [ "${cfxport}" -le 65535 ]; then
        sed -i "s/ipprod_port_here/localhost:$cfxport/g" /etc/nginx/sites-enabled/default
    else
        echo
        echo -e "\n${COLOR1}Port is empty, or wrong value [ 0 - 65535 ] ... ${NC}"
        exit 0
    fi      
    if [ "${txport}" -ge 0 ] && [ "${txport}" -le 65535 ]; then
        sed -i "s/iptxprod_port_here/localhost:$txport/g" /etc/nginx/sites-enabled/default
    else
        echo -e "\n${COLOR1}Wrong txport number${NC} it must be 0 to 65535"
        exit 0
    fi
    echo -e "\n${COLOR2} Start Nginx Server ... ${NC}"
    systemctl start nginx
    sleep 10
    echo -e "${COLOR2} Create SSL Certificates ... ${NC}"
    if [ "${urlmachine}" != "" ]; then
        certbot --nginx -d $urlmachine
        sleep 5
        if [ ! -d "/etc/letsencrypt/live/$urlmachine/" ]; then
            echo
            echo -e "\n${COLOR1}SSl Certification error, stop process... ${NC}"
            exit 0
        fi
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi

    if [ "${urlplay}" != "" ]; then
        certbot --nginx -d $urlplay
        sleep 5
        if [ ! -d "/etc/letsencrypt/live/$urlplay/" ]; then
            echo
            echo -e "\n${COLOR1}SSl Certification error, stop process... ${NC}"
            exit 0
        fi
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi

    if [ "${urltx}" != "" ]; then
        certbot --nginx -d $urltx
        sleep 5
        if [ ! -d "/etc/letsencrypt/live/$urltx/" ]; then
            echo
            echo -e "\n${COLOR1}SSl Certification error, stop process... ${NC}"
            exit 0
        fi
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi

    if [ "${urlphp}" != "" ]; then
        certbot --nginx -d $urlphp
        sleep 5
        if [ ! -d "/etc/letsencrypt/live/$urlphp/" ]; then
            echo
            echo -e "\n${COLOR1}SSl Certification error, stop process... ${NC}"
            exit 0
        fi
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi

    if [ "${urlpanel}" != "" ]; then
        certbot --nginx -d $urlpanel
        sleep 5
        if [ ! -d "/etc/letsencrypt/live/$urlpanel/" ]; then
            echo
            echo -e "\n${COLOR1}SSl Certification error, stop process... ${NC}"
            exit 0
        fi
    else
        echo
        echo -e "\n${COLOR1}Url is empty, stop the process... ${NC}"
        exit 0
    fi

    echo -e "\n${COLOR2} Stop Nginx Server ... ${NC}"
    systemctl stop nginx
    echo
    echo -e "\n${COLOR2} SSL Files installation done ! ... ${NC}"
    echo
    echo -e "\n${COLOR2}Configuration files done ! ... ${NC}"
    echo
    echo -e "\n${COLOR2} Start Nginx Server ... ${NC}"
    systemctl start nginx
    echo
    
}

install_ssl