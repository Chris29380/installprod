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

install_f2b(){
    echo
    echo -e "${COLOR2}UPDATE Packages ... ${NC}"
    apt-get update
    echo
    echo -e "${COLOR2}Fail2ban Installation ... ${NC}"
    apt-get install fail2ban -y
    echo
    echo -e "${COLOR2}Installation done ! ... ${NC}"
    echo
    echo -e "${COLOR2}Copy Configuration Files ... ${NC}"
    echo
    cp ./fail2ban/jail.local /etc/fail2ban/jail.local
    echo
    echo -e "${COLOR2}Fail2Ban Activation ... ${NC}"
    systemctl start fail2ban
    echo
    echo -e "${COLOR2}IPTable Installation ... ${NC}"
    echo
    sudo apt-get install iptables -y
    sudo apt-get install iptables-persistent -y
    echo
    echo -e "${COLOR2}IPTable Configuration ... ${NC}"
    echo
    echo -e "${COLOR2}Rule 1 ... ${NC}"
    iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
    echo -e "${COLOR2}Rule 2 ... ${NC}"
    iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
    echo -e "${COLOR2}Rule 3 ... ${NC}"
    iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
    echo -e "${COLOR2}Rule 4 ... ${NC}"
    iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
    echo -e "${COLOR2}Rule 5 ... ${NC}"
    iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
    echo -e "${COLOR2}Rule 6 ... ${NC}"
    iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
    echo -e "${COLOR2}Rule 7 ... ${NC}"
    iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
    echo -e "${COLOR2}Rule 8 ... ${NC}"
    iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
    echo -e "${COLOR2}Rule 9 ... ${NC}"
    iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
    echo -e "${COLOR2}Rule 10 ... ${NC}"
    iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
    echo -e "${COLOR2}Rule 11 ... ${NC}"
    iptables -t mangle -A PREROUTING -p icmp -j DROP
    echo -e "${COLOR2}Rule 12 ... ${NC}"
    iptables -A INPUT -p tcp -m connlimit --connlimit-above 100 -j REJECT --reject-with tcp-reset
    echo -e "${COLOR2}Rule 13 ... ${NC}"
    iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 20 -j ACCEPT 
    echo -e "${COLOR2}Rule 14 ... ${NC}"
    iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP
    echo -e "${COLOR2}Rule 15 ... ${NC}"
    iptables -t mangle -A PREROUTING -f -j DROP
    echo -e "${COLOR2}Rule 16 ... ${NC}"
    iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT 
    echo -e "${COLOR2}Rule 17 ... ${NC}"
    iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP
    echo -e "${COLOR2}Rule 18 ... ${NC}"
    iptables -A INPUT -m limit --limit 1/s --limit-burst 3 -j RETURN
    echo -e "${COLOR2}Rule 20 ... ${NC}"
    iptables -t raw -A PREROUTING -p tcp -m tcp --syn -j CT --notrack 
    echo -e "${COLOR2}Rule 21 ... ${NC}"
    iptables -A INPUT -p tcp -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460 
    echo -e "${COLOR2}Rule 22 ... ${NC}"
    iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
    echo -e "${COLOR2}Rule 23 ... ${NC}"
    iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set 
    echo -e "${COLOR2}Rule 24 ... ${NC}"
    iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP
    echo -e "${COLOR2}Rule 25 ... ${NC}"
    iptables -N port-scanning 
    echo -e "${COLOR2}Rule 26 ... ${NC}"
    iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN 
    echo -e "${COLOR2}Rule 27 ... ${NC}"
    iptables -A port-scanning -j DROP
    
    echo
    echo -e "${COLOR2}Port HTTP 80 ... ${NC}"
    iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 80 -j ACCEPT
    iptables -A INPUT -p tcp -m tcp --sport 80 -j ACCEPT
    iptables -A INPUT -p udp -m udp --sport 80 -j ACCEPT
    echo
    echo -e "${COLOR2}Port HTTPS 443 ... ${NC}"
    iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 443 -j ACCEPT
    iptables -A INPUT -p tcp -m tcp --sport 443 -j ACCEPT
    iptables -A INPUT -p udp -m udp --sport 443 -j ACCEPT
    echo
    echo -e "${COLOR2}Port SSH 22 ... ${NC}"
    iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 22 -j ACCEPT
    iptables -A INPUT -p tcp -m tcp --sport 22 -j ACCEPT
    iptables -A INPUT -p udp -m udp --sport 22 -j ACCEPT
    echo
    echo -e "${COLOR2}Port FTP 21 ... ${NC}"
    iptables -A INPUT -p tcp -m tcp --dport 21 -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 21 -j ACCEPT
    iptables -A INPUT -p tcp -m tcp --sport 21 -j ACCEPT
    iptables -A INPUT -p udp -m udp --sport 21 -j ACCEPT
    echo
    iptables -t filter -A INPUT -j DROP

    echo -e "\n${COLOR3}txAdmin Port ? ${NC}(default:40120)"
    read -p "txAdmin port: " txport       
    if [ "${txport}" -ge 0 ] && [ "${txport}" -le 65535 ]; then
        iptables -A INPUT -p tcp -m tcp --dport ${txport} -j ACCEPT
        iptables -A INPUT -p udp -m udp --dport ${txport} -j ACCEPT
        iptables -A INPUT -p tcp -m tcp --sport ${txport} -j ACCEPT
        iptables -A INPUT -p udp -m udp --sport ${txport} -j ACCEPT
    else
        echo -e "\n${COLOR1}Wrong txport number${NC} it must be 0 to 65535"
        exit 0
    fi

    echo -e "\n${COLOR3}Server Fivem Port ? ${NC}(default:30120)"
    read -p "FxServer port : " cfxport       
    if [ "${cfxport}" -ge 0 ] && [ "${cfxport}" -le 65535 ]; then
        iptables -A INPUT -p tcp -m tcp --dport ${cfxport} -j ACCEPT
        iptables -A INPUT -p udp -m udp --dport ${cfxport} -j ACCEPT
        iptables -A INPUT -p tcp -m tcp --sport ${cfxport} -j ACCEPT
        iptables -A INPUT -p udp -m udp --sport ${cfxport} -j ACCEPT
    else
        echo -e "\n${COLOR1}Wrong cfxport number${NC} it must be 0 to 65535"
        exit 0
    fi
    
    iptables-save > /etc/iptables/rules.v4
    iptables-save > /etc/iptables/rules.v6
    echo -e "${COLOR2}Configuration done... ${NC}"
    echo
}

install_f2b