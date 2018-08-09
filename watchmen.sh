#!/bin/bash

archivo="./tmp/usrlogin"
archivoDoble="./tmp/dobles"
archivoTrans="./tmp/trans"
lista="./tmp/pcs-todos"

echo "####" > $archivo
echo "####" > $archivoDoble
echo "#Dobles Logins" >> $archivoDoble
echo "####" > $archivoTrans
echo "#Transmission" >> $archivoTrans

cat pcs/lpa > $lista
cat pcs/lds >> $lista
clear
for pc in $(cat $lista | grep -v "^#")
do
    echo "vigilando a $pc"
    for usuario in $(ssh -o ConnectTimeout=1 root@$pc "who -T | grep ? " | awk '{print $1}')
    do
        doble=$(cat $archivo | grep $usuario)
        if [ "x$doble" == "x" ]; then
            echo "$usuario:::$pc" >> $archivo
        else
            echo "ENCONTRE UN DOBLE"
            echo "$doble" >> $archivoDoble
            echo "$usuario:::$pc" >> $archivoDoble
        fi
    done
    unset usuario
    ssh -o ConnectTimeout=1 root@$pc "ps aux | grep transmission | grep -v grep" >> $archivoTrans
    clear
done
cat $archivoDoble
echo ""
cat $archivoTrans
