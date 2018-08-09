#!/bin/bash

#set let var=0;

cont=0

suma(){
    let cont=$cont+1;
}


uno(){
    #echo $var
    let cont=$cont+1;
    #suma
    let ola=1
    while [ $ola -lt 100000 ]
    do
        let ola=$ola+1
    done
    echo $cont
}

dos(){
    echo $cont
    let cont=$cont+10;
    echo "dos $cont"
}

#uno &
echo $(let cont=$(uno)+1) &

echo "ecooo $cont"
echo esperando 3

sleep 6
dos




echo $cont
