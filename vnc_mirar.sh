#!/bin/bash
if [ $# -lt 2  ]; then
	echo "asi no eeeesss !!!"
	echo "$0 VICTIMA DISPLAY"
	echo "$0 lpa-pc10 :0 "
	exit 0
fi
victima=$1
display=$2
if [ $display == "login" ]; then
    display=":0"
    login="-auth guess"
else
    login=""
fi
experimento=$3
if [ $# -ge 3 ] && [ $experimento = "-asistir" ]; then
	echo "MODO ASISTENCIA"
    ssh -t -L hermes:5000:localhost:6000 root@$victima "x11vnc -rfbport 6000 -display $display  -localhost $login"
else
	ssh -t -L hermes:5000:localhost:6000 root@$victima "x11vnc -rfbport 6000 -display $display  -localhost -viewonly $login"
fi
