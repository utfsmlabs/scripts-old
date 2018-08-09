#!/bin/bash
if [ $# -eq 0 ]; then
    echo "" > temp_apagados
    echo "sin parametros - viendo todos los pc"
    $0 pcs/lpa
    echo ""
    echo ""
    echo "" >> temp_apagados
    echo "" >> temp_apagados
    $0 pcs/lds
    echo "" 
    echo "Resumen - pcs apagados"
    echo "$(cat temp_apagados)"
    rm temp_apagados
    exit 1
fi
if [ $# -gt 2 ]; then
    echo "usar:  $0 LISTA_DE_COMPUTADORES [-a]"
    exit
fi

ap="prendidos"
if [ $# = 2 ]; then
    if [ $2 = "-a" ]; then
        ap="apagados"
    fi
fi

if [ -f $1 ]; then
    for pc in $(cat $1 | grep -v "^#")
    do
        compu=$(ping -w 1 $pc | grep "bytes from")
        if [ "x${compu}" != 'x' ]; then
            if [ $ap != "apagados" ]; then
                echo -e "\e[0;32m$pc PRENDIDO\e[0m"
                ssh -o ConnectTimeout=3 root@$pc "users"
            fi
        else
            echo -e "\e[1;31m$pc APAGADOH\e[0m"
            echo -e "\e[1;31m$pc APAGADOH\e[0m" >> temp_apagados
        fi
    done
else
    echo "La lista no es una lista valida de PeCes"
fi
