#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usar $0 pcs [off|on] [-F]"
    exit 0
fi


if [ $# -lt 2 ]; then
    op="off"
else
    op=$2
fi

if [ $# -lt 3 ]; then
    F="-no"
else
    F=$3
fi

for num in $(seq 0 10)
do
    if [ $op == "off" ]; then
        ./send_com.sh $1 "if [ \$(who | grep -v unknown | grep -v root | wc -l) -lt 1 ] || [ '$F' == '-F' ]; then DISPLAY=:$num xset dpms force $op;fi" 2>> /dev/null &
    else
        ./send_com.sh $1 "DISPLAY=:$num xset dpms force $op" 2>> /dev/null &
    fi
done
