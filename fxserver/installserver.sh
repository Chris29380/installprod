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

startserver(){
    SCREEN="fxserver"
    FIVEM_PATH=/home/fivem/txAdmin/fxserver

    screen -S $SCREEN -X quit
    screen -dm -S $SCREEN
    screen -x $SCREEN -X stuff "bash $FIVEM_PATH/run.sh +set txAdminPort ${txport}"
    screen -r $SCREEN

}

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
echo -e "${COLOR2}Install Latest artifact ... ${NC}"
LATEST_VERSION=`wget -q -O - https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ | grep '<a href' | tail -1 | grep -Po '(?<=href=").{47}'`
url=`echo $LATEST_VERSION | sed -r 's/[./]+//g'`
echo Latest FXServer build: ${url}
echo "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$url/fx.tar.xz"
wget -O /home/fivem/txAdmin/fxserver/fx.tar.xz -q --show-progress "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$url/fx.tar.xz"
tar -xvf /home/fivem/txAdmin/fxserver/fx.tar.xz -C /home/fivem/txAdmin/fxserver/
#rm /home/fivem/txAdmin/fxserver/fx.tar.xz
echo
echo -e "${COLOR2}Install Screen ... ${NC}"
apt-get install screen -y
echo
echo -e "${COLOR2}Start Server ... ${NC}"
echo
echo -e "\n${COLOR3}txAdmin Port ? ${NC}(default:40120)"
read -p "txAdmin port: " txport       
if [ "${txport}" -ge 0 ] && [ "${txport}" -le 65535 ]; then
    startserver
else
    echo -e "\n${COLOR1}Wrong txport number${NC} it must be 0 to 65535"
    exit 0
fi
