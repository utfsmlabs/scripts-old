#!/bin/bash
if [ $# = 0 ]; then
	echo "Argumente pue !!!"
	echo "./usuarios_conectados.sh COMPUTADOR(ES)"
	exit 0
fi
if [ -f $1 ]; then
	./send_com.sh $1 "who | grep -v root"
else
	echo "Usuarios en el $1"
	ssh root@$1 "who | grep -v root"
fi
