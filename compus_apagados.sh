#!/bin/bash
if [ $# != 1 ]; then
	echo "usar ./compus_apagados.sh LISTA_DE_COMPUTADORES"
	exit 0
fi
if [ -f $1 ]; then
	./send_com.sh $1 -f "who" | grep "Connection timed out"
else
	echo "eeeso que metio no es una lista de computadores !!"
fi
