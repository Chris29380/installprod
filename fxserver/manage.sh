#!/bin/bash
# @By HalCroves

# Couleurs
    NORMAL="\033[0;39m"
    ROUGE="\033[1;31m"
    VERT="\033[1;32m"
    ORANGE="\033[1;33m"
    
# Messages customs
    MSG_120="Une tempête approche, dans 3 minutes la ville sera rasé !"
    MSG_60="Une tempête est aux portes de la ville, fuyez pauvres fous !"
    MSG_30="Mon dieu !! Dans 30 secondes vous serez tous morts si vous ne fuyez pas !"
    
# Path
    FIVEM_PATH=/home/fivem/txAdmin/fxserver
    DATA_PATH=/home/fivem/txAdmin/fxserver/txData/baseserver
    TX_PORT=tx_port_here

# Screen
    SCREEN="fxserver"

cd $FIVEM_PATH    
running(){
    if ! screen -list | grep -q "$SCREEN"
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
        echo -e "$ROUGE Le serveur [$SCREEN] est deja démarrer !$NORMAL"
    else
        echo -e "$ROUGE Redémarrage de mysql !$NORMAL"
        sudo service mysql restart
        sleep 10
        echo -e "$ORANGE Le serveur [$SCREEN] va démarrer.$NORMAL"
        screen -dm -S $SCREEN
        sleep 2
        screen -x $SCREEN -X stuff "cd "$FIVEM_PATH""$DATA_PATH" && bash "$FIVEM_PATH"/run.sh +set txAdminPort $TX_PORT
        "
        echo -e "$ORANGE Restart des sessions.$NORMAL"
        sleep 20
        screen -x $SCREEN -X stuff "restart sessionmanager
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
        echo -e "$VERT Le serveur va être stoppé dans 10s. $NORMAL"
        screen -S $SCREEN -p 0 -X stuff "`printf "say $MSG_30\r"`"; sleep 30
        screen -S $SCREEN -X quit
        echo -e "$ROUGE Le serveur [$SCREEN] a été stopper.$NORMAL"
        sleep 5
        echo -e "$VERT Serveur [$SCREEN] eteint. $NORMAL"
        rm -R $FIVEM_PATH/$DATA_PATH/cache/
        echo -e "$VERT Nettoyage du cache. $NORMAL"

    else
        echo -e "Le serveur [$SCREEN] n'est pas démarrer."
    fi
    ;;
    # ----------------[ Restart ]---------------- #
    restart)
    if ( running )
    then
        echo -e "$ROUGE Le serveur [$SCREEN] fonctionne déja ! $NORMAL"
    else
        echo -e "$VERT Le serveur [$SCREEN] est eteint. $NORMAL"
    fi
        echo -e "$ROUGE Le serveur va redémarrer... $NORMAL"
        screen -S $SCREEN -p 0 -X stuff "`printf "say $MSG_120\r"`"; sleep 120
        screen -S $SCREEN -p 0 -X stuff "`printf "say $MSG_60\r"`"; sleep 60
        screen -S $SCREEN -p 0 -X stuff "`printf "say $MSG_30\r"`"; sleep 30
        screen -S $SCREEN -X quit
        echo -e "$VERT Serveur eteint $NORMAL"
        rm -R $DATA_PATH/cache/
        echo -e "$VERT Nettoyage du cache. $NORMAL"
        sleep 2
        echo -e "$ORANGE Redémarrage en cours ... $NORMAL"
        echo -e "$ROUGE Redémarrage de mysql !$NORMAL"
        sudo service mysql restart
        sleep 10
        echo -e "$ORANGE Le serveur [$SCREEN] va démarrer.$NORMAL"
        screen -dm -S $SCREEN
        sleep 2
        screen -x $SCREEN -X stuff "cd "$DATA_PATH" && bash "$FIVEM_PATH"/run.sh +set txAdminPort $TX_PORT
        "
        echo -e "$ORANGE Restart des sessions.$NORMAL"
        sleep 20
        screen -x $SCREEN -X stuff "restart sessionmanager
        "
        echo -e "$VERT Serveur [$SCREEN] démarrer ! $NORMAL"
    ;;    
    # -----------------[ Status ]---------------- #
    status)
    if ( running )
    then
        echo -e "$VERT [$SCREEN] démarrer. $NORMAL"
    else
        echo -e "$ROUGE [$SCREEN]éteint. $NORMAL"
    fi
    ;;
    # -----------------[ Screen ]---------------- #
    screen)
        echo -e "$VERT Screen du serveur [$SCREEN]. $NORMAL"
        screen -R $SCREEN
    ;;
    # -----------------[ Install ]---------------- #
    install)
        echo -e "$ROUGE Redémarrage de mysql !$NORMAL"
        sudo service mysql restart
        sleep 10
        echo -e "$ORANGE Le serveur [$SCREEN] va démarrer.$NORMAL"
        screen -dm -S $SCREEN
        sleep 2
        screen -x $SCREEN -X stuff "cd "$DATA_PATH" && bash "$FIVEM_PATH"/run.sh +set txAdminPort $TX_PORT"
    ;;
    *)
    echo -e "$ORANGE Utilisation :$NORMAL ./manage.sh {start|stop|status|screen|restart|install}"
    exit 1
    ;;
esac

exit 0