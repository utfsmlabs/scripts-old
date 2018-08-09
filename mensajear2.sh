#!/bin/bash
if [ $# -lt 2 ]; then
	echo "Argumente pue !!!"
	echo "./mensajear.sh COMPUTADOR(ES) \"MENSAJE\""
	exit 0
fi
if [ -f $1 ]; then
	./send_com.sh $1 -f "DISPLAY=:0 zenity --info --text='$2'" | grep ssh
	exit 0
else
	echo "Mensajiando al $1"
	ssh root@$1 "DISPLAY=:0 zenity --info --text='$2'"
	exit 0
fi
echo "No hice ni una wea..."
