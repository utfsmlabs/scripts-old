#!/bin/bash

#Este scripts, es para ejecutar scripts decentralizadamente en algun computador habilitado:
#	Requerimientos del PC donde se desea ejecutar el script:
#		Tener los archivos base necesarios en el usuario "inf":
#			~/scripts/variables.sh
#			~/scripts/fileExists.sh
#			~/scripts/getFileAs.sh
#			~/scripts/lanzar_script_remoto.sh
#
#
#El script remoto que se desea ejecutar tiene que estar en https://primos.inf.santiago.usm.cl/scripts_remotos/postgrado/
#
#
#
#
#exit 0

#echo "Ingrese la passwordo: "
#read -s passwordo

COMPU=$1
SCRIPT=$2


ssh -t inf@$1 "cd ~/scripts/ && sudo ./lanzar_script_remoto.sh $SCRIPT"
