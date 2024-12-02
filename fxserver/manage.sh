#!/bin/bash
# @By HalCroves

# Couleurs
    NORMAL="\033[0;39m"
    ROUGE="\033[1;31m"
    VERT="\033[1;32m"
    ORANGE="\033[1;33m"
    
# Messages customs
    MSG_120="Une tempête approche, dans 2 minutes la ville sera rasé !"
    MSG_60="Une tempête est aux portes de la ville, fuyez pauvres fous, il vous reste 1 minute !"
    MSG_30="Mon dieu !! Dans 30 secondes vous serez tous morts si vous ne fuyez pas !"

cd /home/fivem/txAdmin/fxserver/ 

running(){
    if ! screen -list | grep fxserver
    then
        return 1
    else
        return 0
    fi
}    

case "$1" in
    # -----------------[ Start ]----------------- #
    start)
    if ( running )
    then
        echo -e "$ROUGE Le serveur [fxserver] est deja démarrer !$NORMAL"
    else
        echo -e "$ROUGE Redémarrage de mysql !$NORMAL"
        sudo service mysql restart
        sleep 10
        echo -e "$ORANGE Le serveur [fxserver] va démarrer.$NORMAL"
        screen -dm -S fxserver
        sleep 2
        screen -x fxserver -X stuff "cd /home/fivem/txAdmin/fxserver/txData/baseserver \n"
        screen -x fxserver -X stuff "bash /home/fivem/txAdmin/fxserver/run.sh +set serverProfile default +set txAdminPort tx_port_here \n"
        echo -e "$ORANGE Restart des sessions.$NORMAL"
        sleep 20
        screen -x fxserver -X stuff "restart sessionmanager
        "
        echo -e "$VERT Session Ok ! $NORMAL"
        sleep 5
        echo -e "$VERT Serveur Ok ! $NORMAL"
    fi
    ;;
    # -----------------[ Stop ]------------------ #
    stop)
    if ( running )
    then
        echo -e "$VERT Le serveur va être stoppé dans 30s. $NORMAL"
        screen -S fxserver -p 0 -X stuff "`printf "say $MSG_30\r"`"; sleep 30
        screen -S fxserver -X quit
        echo -e "$ROUGE Le serveur [fxserver] a été stopper.$NORMAL"
        sleep 5
        echo -e "$VERT Serveur [fxserver] eteint. $NORMAL"
        rm -R /home/fivem/txAdmin/fxserver/txData/baseserver/cache/
        echo -e "$VERT Nettoyage du cache. $NORMAL"

    else
        echo -e "Le serveur [fxserver] n'est pas démarrer."
    fi
    ;;
    # ----------------[ Restart ]---------------- #
    restart)
    if ( running )
    then
        echo -e "$ROUGE Le serveur [fxserver] fonctionne déja ! $NORMAL"
    else
        echo -e "$VERT Le serveur [fxserver] est eteint. $NORMAL"
    fi
        echo -e "$ROUGE Le serveur va redémarrer... $NORMAL"
        screen -S fxserver -p 0 -X stuff "`printf "say $MSG_120\r"`"; sleep 120
        screen -S fxserver -p 0 -X stuff "`printf "say $MSG_60\r"`"; sleep 60
        screen -S fxserver -p 0 -X stuff "`printf "say $MSG_30\r"`"; sleep 30
        screen -S fxserver -X quit
        echo -e "$VERT Serveur eteint $NORMAL"
        rm -R /home/fivem/txAdmin/fxserver/txData/baseserver/cache/
        echo -e "$VERT Nettoyage du cache. $NORMAL"
        sleep 2
        echo -e "$ORANGE Redémarrage en cours ... $NORMAL"
        echo -e "$ROUGE Redémarrage de mysql !$NORMAL"
        sudo service mysql restart
        sleep 10
        echo -e "$ORANGE Le serveur [fxserver] va démarrer.$NORMAL"
        screen -dm -S fxserver
        sleep 2
        screen -x fxserver -X stuff "cd /home/fivem/txAdmin/fxserver/txData/baseserver && bash /home/fivem/txAdmin/fxserver/run.sh +set txAdminPort tx_port_here \n"
        echo -e "$ORANGE Restart des sessions.$NORMAL"
        sleep 20
        screen -x fxserver -X stuff "restart sessionmanager
        "
        echo -e "$VERT Serveur [fxserver] démarrer ! $NORMAL"
    ;;    
    # -----------------[ Status ]---------------- #
    status)
    if ( running )
    then
        echo -e "$VERT [fxserver] démarrer. $NORMAL"
    else
        echo -e "$ROUGE [fxserver]éteint. $NORMAL"
    fi
    ;;
    # -----------------[ Screen ]---------------- #
    screen)
        echo -e "$VERT Screen du serveur [fxserver]. $NORMAL"
        screen -R fxserver
    ;;
    # -----------------[ Install ]---------------- #
    install)
        echo -e "$ROUGE Redémarrage de mysql !$NORMAL"
        sudo service mysql restart
        sleep 10
        echo -e "$ORANGE Le serveur [fxserver] va démarrer.$NORMAL"
        screen -dm -S fxserver
        sleep 2
        screen -x fxserver -X stuff "cd /home/fivem/txAdmin/fxserver/txData/baseserver && bash /home/fivem/txAdmin/fxserver/run.sh +set txAdminPort tx_port_here \n"
    ;;
    *)
    echo -e "$ORANGE Utilisation :$NORMAL ./manage.sh {start|stop|status|screen|restart|install}"
    exit 1
    ;;
esac

exit 0