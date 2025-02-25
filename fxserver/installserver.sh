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

echo
echo -e "${COLOR2}Create Fivem Directory ... ${NC}"
mkdir -p -v /home/fivem/
echo
echo -e "${COLOR2}Install txAdmin ... ${NC}"
apt-get install unzip -y
wget -O /home/fivem/txAdmin.zip  https://github.com/tabarra/txAdmin/archive/refs/tags/v7.3.2.zip 
unzip /home/fivem/txAdmin.zip -d /home/fivem/
rm /home/fivem/txAdmin.zip
mv -T /home/fivem/txAdmin-7.3.2 /home/fivem/txAdmin
echo
echo -e "${COLOR2}Install fxserver ... ${NC}"
mkdir -p -v /home/fivem/txAdmin/fxserver
echo
echo -e "${COLOR2}Install Latest artifact url ?... ${NC}"
read -p "artifact url :" urlartifact
if [ "$urlartifact" != "" ]; then
    wget -O /home/fivem/txAdmin/fxserver/fx.tar.xz -q --show-progress $urlartifact
    tar -xvf /home/fivem/txAdmin/fxserver/fx.tar.xz -C /home/fivem/txAdmin/fxserver/
    rm /home/fivem/txAdmin/fxserver/fx.tar.xz
    echo
    echo -e "${COLOR2}Install Screen ... ${NC}"
    apt-get install screen -y
    echo
    mkdir -p -v /home/fivem/txAdmin/fxserver/txData/baseserver
    echo
    echo -e "${COLOR2}Install TxAdmin ... ${NC}"
    echo
    echo -e "\n${COLOR3}txAdmin Port ? ${NC}(default:40120)"
    read -p "txAdmin port: " txport   
    if [ "${txport}" -ge 0 ] && [ "${txport}" -le 65535 ]; then
        cp ./manage.sh /home/fivem/txAdmin/fxserver/manage.sh
        sleep 5
        sed -i "s/tx_port_here/$txport/g" /home/fivem/txAdmin/fxserver/manage.sh
        sleed 5
        echo -e "\n${COLOR3}Now execute command : bash manage.sh install \n and then connect to txadmin url."
        echo
        exit 0
    else
        echo -e "\n${COLOR1}Wrong txport number${NC} it must be 0 to 65535"
        exit 0
    fi
else
    echo -e "${COLOR1}url is empty !... ${NC}"
    exit 0
fi

