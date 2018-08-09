#!/bin/bash
if [ $# -lt 1 ]; then
	echo "USAR:"
	echo "$0 COMPUTADOR(ES)"
	exit 1
fi
#echo $1
if [ -f $1 ]; then
    lista="tmp/pcs_temp"
    echo "#Lista_lista_:3" > $lista
    for pc in $(cat $1)
    do
        if [ "x$(cat pcs/ignorar | grep $pc)" == "x" ]; then
            echo $pc >> $lista
        fi
    done
    echo "PECES excluidos"
    cat pcs/ignorar | grep -v "^#"
    echo ""
    if [ $1 == "pcs/core2" ]; then
        echo "SOY CORE2"
        ./send_com.sh $lista -f "pm-suspend"
    else
        echo "NICAGANDO SOY CORE2"
        ./send_com.sh $lista -f "poweroff"
    fi
	exit 0;
else
	echo "apagando EL pc $1"
	ssh root@$1 "poweroff"
	exit 0;
fi
echo "no hizo ni una wea..."
