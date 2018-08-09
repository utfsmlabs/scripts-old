#!/bin/bash
if [ $# -lt 1]; then
	echo "Miss!!"
	echo "$0 COMPUTADOR(ES)"
	exit 0
fi
if [ -f $1 ]; then
	./send_com.sh $1 -f "lvremove /dev/storage/windows-snap -f"
	exit 0;
else
	echo "Snap removida del PC $1"
	ssh root@$1 "lvremove /dev/storage/windows-snap -f"
	exit 0;
fi
echo "FAIL!!!"
