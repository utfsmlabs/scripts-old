#!/bin/bash

compu=$1

if [ $# -lt 1 ]; then
	echo Usage: $0 NOMBRE_PC
	echo Ej:
	echo "    $0 dolores"
	exit 1
fi

#echo $compu 
response=$(ping $compu -c 1 -W 1 -s 8 2>/dev/null | grep "16 bytes")
#echo $response

if [ "$response" != "" ]; then
	echo "si"
else
	echo "no"
fi
