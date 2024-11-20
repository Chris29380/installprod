#!/bin/bash
COLOR1='\033[0;31m'
COLOR2='\033[1;34m'
COLOR3='\033[1;33m'
NC='\033[0m' # No Color

isuserok="ko"
ispwdok="ko"
# -----------------------------------------------------------
# check sudo permissions
# -----------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
    echo -e "${COLOR1} This script must be run as root ${NC}" 1>&2
    exit 1
fi

ismariadb=$(dpkg-query -l | grep -E "^.i *mariadb-server")

basic_single_escape () {
    echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g'
}

formatfield() {
    esc_user=`basic_single_escape "$usersql"`
    esc_pass=`basic_single_escape "$pwdusersql"`

}

if [ "${ismariadb}" != "" ]; then

    config=".my.cnf.$$"
    command=".mysql.$$"
    mysql_client=""

    trap "interrupt" 1 2 3 6 15

    rootpass=""
    echo_n=
    echo_c=

    set_echo_compat() {
        case `echo "testing\c"`,`echo -n testing` in
        *c*,-n*) echo_n=   echo_c=     ;;
        *c*,*)   echo_n=-n echo_c=     ;;
        *)       echo_n=   echo_c='\c' ;;
        esac
    }

    prepare() {
        touch $config $command
        chmod 600 $config $command
    }

    find_mysql_client()
    {
    for n in ./bin/mysql mysql
    do  
        $n --no-defaults --help > /dev/null 2>&1
        status=$?
        if test $status -eq 0
        then
        mysql_client=$n
        return
        fi  
    done
    echo -e "${COLOR1}Can't find a 'mysql' client in PATH or ./bin${NC}"
    exit 1
    }

    do_query() {
        echo "$1" >$command
        #sed 's,^,> ,' < $command  # Debugging
        $mysql_client --defaults-file=$config <$command
        return $?
    }   

    prepare
    find_mysql_client
    set_echo_compat

    echo
    echo -e "\n${COLOR3}Set USER SQL Name ${NC}"
    read -p "User Name : " usersql
    echo -e "\n${COLOR3}Set USER Password ${NC}"
    read -p "User Password : " pwdusersql
    formatfield
    if [ "${esc_user}" != "" ]; then
        isuserok="ok"
    else
        echo -e "\n${COLOR1} User is empty ${NC}"
        exit 0
    fi
    if [ "${esc_pass}" != "" ]; then
        ispwdok="ok"
    else
        echo -e "\n${COLOR1} Password is empty ${NC}"
        exit 0
    fi
    if [ "${isuserok}" == "ok" ] && [ "${ispwdok}" == "ok" ]; then
        echo
        echo -e "${COLOR2} User Creation ... ${NC}"
        do_query "CREATE USER '${esc_user}'@localhost IDENTIFIED BY '${esc_pass}';"
        echo -e "${COLOR2} Users Listing ... ${NC}"
        do_query "SELECT User FROM mysql.user;"
        echo -e "${COLOR2} Give All Privileges ... ${NC}"
        do_query "GRANT ALL PRIVILEGES ON *.* TO '${esc_user}'@localhost IDENTIFIED BY '${esc_pass}';"
        echo -e "${COLOR2} Reload Privileges ... ${NC}"
        do_query "FLUSH PRIVILEGES;"
        echo -e "${COLOR2} User Creation done ! ... ${NC}"
        echo
    fi
else
    echo -e "\n${COLOR1} Mariadb Server Not Installed, Can't configure User SQL ! ${NC}"
    exit 0
fi
