#!/bin/bash

DICKS_PATH=$(dirname $(readlink $0))"/Dickts/"

if [ $# -lt 2 ]; then
	echo "DICK - (D)iccionar(I)os en ar(C)hivos, todo o(K)"
	echo Script para manejar diccionarios en archivos.
	echo Usage:
	echo $0 DICT_FILE KEY [DELIMITER]
	echo default DELIMITER: -
	echo example:
	echo 	$0 key2value key
	exit 1
fi

if [ -e "$DICKS_PATH$1" ]; then
	file=$DICKS_PATH$1
else
	file=$1
fi

if [ $# -eq 3 ]; then
	delim=$3
else
	delim="%"	
fi


while read -r line; do
	key=$(echo $line | sed "s/$delim.*//")
	if [ "$key" = "$2" ]; then
		value=$(echo $line | sed "s/.*$delim//")
		echo $value
		exit 0
	fi
done < $file
echo "ERROR IN DICK - Key not found."
