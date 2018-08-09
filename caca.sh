#!/bin/bash

uno(){
    let ola=0
    while [ $ola -le 100000 ]
    do
        let ola=$ola+1
    done
    echo $var
    . ./pipi.sh
}


uno &


. ./pipi.sh
