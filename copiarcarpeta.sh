#!/bin/bash
if [ $# -lt 3  ]; then
	echo "Solo para copiar archivos de APU a los demas computadores"
	echo "$0 COMPUTADOR(ES) ARCHIVO DESTINO"
fi
	DESTINO_FINAL=$3
        	for pc in $(cat $1)
		do
			echo "Copiando al $pc"
			DESTINO="root@$pc:$3"
			scp -r $2 $DESTINO
		done
        	exit 0
