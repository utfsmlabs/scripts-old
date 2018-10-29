#!/bin/bash

error_temp="tmp/error_mapa-"

rm ./tmp/error_mapa-*
rm ./tmp/estado_*
rm ./tmp/usuarios_*

total=$(cat pcs/lpa | wc -l)
cont=0

load(){
    for pc in $(cat pcs/lds | grep -v "^#")
    do
        pc=$(echo "$pc" | sed 's/^#//')
        clear
	echo "Waitea un poquitin :)"
     #   echo "waitea"
        id=$(echo $pc | sed "s/^[-pcslpad]*//")
        info $pc $id &
    done
}

info(){
    pc=$1
    id=$2
    compu=$(ping -w 1 $pc | grep "bytes from")
    var[$id]="\e[43;1;31m?\e[0m" #O amarilla (DEFAULT)
    if [ "x${compu}" != 'x' ]; then
        ### echo -e "\e[0;32m$pc PRENDIDO\e[0m"
        ssh -o ConnectTimeout=3 root@$pc "exit" 2> $error_temp$pc
        cat $error_temp$pc | grep -v "Warning: Permanently added" > $error_temp$pc
	if [ "x$(cat $error_temp$pc)" = 'x' ]; then
		#var[$id]="\e[0;0;32mO\e[0m" #O verde
		echo "\e[0;0;32mO\e[0m" > tmp/estado_$pc
		echo $(ssh root@$pc "users") > tmp/usuarios_$pc
            rm $error_temp$pc 2>/dev/null
	else
		#var[$id]="\e[43;1;30mO\e[0m" #O amarilla
		echo "\e[43;1;30mO\e[0m" > tmp/estado_$pc
        fi
    else
        ### echo -e "\e[1;31m$pc APAGADOH\e[0m"
        #var[$id]="\e[0;1;31mX\e[0m" #X roja
	echo "\e[0;1;31mX\e[0m" > tmp/estado_$pc
    fi
}

load
stty_state=`stty -g`
##stty raw; stty -echo


copiar_estados(){
    #var[38]="\e[45;1;35m \e[0m"
    #var[39]="\e[45;1;35m \e[0m"
    #var[48]="\e[45;1;35m \e[0m"
    #var[49]="\e[45;1;35m \e[0m"
	for indice in $(seq 49)
	do
		var[$indice]="\e[43;1;31m?\e[0m"
	done
	cont=0
	while [ $cont -lt $total ]
	do
		for pc in $(ls tmp/estado_lds* 2>/dev/null)
		do
			id=$(echo $pc | sed "s/^tmp\/estado_lds-pc//")
			#var[$(echo $pc | sed "s/^tmp\/estado_lds-pc//")]=$(cat $pc)
			var[$id]=$(cat $pc)
			#echo $pc
			id=$(echo $pc | sed "s/^tmp\/estado_lds-pc//")
			#echo ${var[$id]}
			usua[$id]=$(cat tmp/usuarios_lds-pc$id 2>/dev/null)
			let cont=$cont+1
			#rm $pc
		done
	done
	for indice in $(seq 49)
    	do
        	#echo $indice
        	ori[$indice]=${var[$indice]}
    	done
	
#	rm tmp/estado_lds*
}

reset_pos(){
    i=4
    j=0
    let pos=$i*10+$j
    var[40]=$(echo ${var[40]} | sed "s/e.[0-9]*[;][0-9]*[;]/e[7;1;/")

}



info "lds-pc10" 10
copiar_estados
reset_pos


#rm tmp/estado_lds*


#Ciclo Principal
while [ true ]
do

let pos=$i*10+$j
for indice in $(seq 5)
do
    mostrar_usua[$indice]=""
done
indice=1
for pj in $(echo ${usua[$pos]})
do
    if [ $pj != "(unknown)" ]; then
        mostrar_usua[$indice]=$pj
        let indice=$indice+1
    fi
done

#for indice in $(seq 49)
#do
#	if [ var[$indice] = "" ]; then
#		var[$indice] = "\e[43;1;31m?\e[0m"
#	fi
#done

#make_primos_great_again
echo "Make Primos Great Again"
#sleep 0.1
clear

#JSON
#json="tmp/json_lds"
#rm tmp/json_lds
#echo "{\"lds\": {" >> $json
#echo "	}" >> $json
#echo "}" >> $json



#FIN JSON






echo "            Mapa del LDS"
echo ""
echo ""
echo -e "     0 1    2 3    4 5    6 7    8 9"
echo -e "                                          \e[0;0;1mlds-pc$pos\e[0m"
echo -e "  4  ${var[40]}|${var[41]}    ${var[42]}|${var[43]}    ${var[44]}|${var[45]}    ${var[46]}|${var[47]}    ${var[48]}|${var[49]}      ${mostrar_usua[1]}"
echo -e "    --+--  --+--  --+--  --+--  --+--     ${mostrar_usua[2]}"  
echo -e "  3  ${var[30]}|${var[31]}    ${var[32]}|${var[33]}    ${var[34]}|${var[35]}    ${var[36]}|${var[37]}    ${var[38]}|${var[39]}      ${mostrar_usua[3]}"
echo -e "                                          ${mostrar_usua[4]}"
echo -e "                                          ${mostrar_usua[5]}"
echo -e "  2  ${var[20]}|${var[21]}    ${var[22]}|${var[23]}    ${var[24]}|${var[25]}    ${var[26]}|${var[27]}    ${var[28]}|${var[29]}"
echo -e "    --+--  --+--  --+--  --+--  --+--"  
echo -e "  1  ${var[10]}|${var[11]}    ${var[12]}|${var[13]}    ${var[14]}|${var[15]}    ${var[16]}|${var[17]}    ${var[18]}|${var[19]}"

echo ""
echo ""
echo -e "\e[0;1;31mX\e[0m APAGADO    \e[0;0;32mO\e[0m PRENDIDO    \e[43;1;30mO\e[0m PRENDIDO con algun problema xD"
echo -e "\e[43;1;31m?\e[0m No se pudo determinar el estado :("
echo ""
echo -e "Si se ve 'raro', recargar todo (R)"
echo ""
echo -e "R: recargar todo    p: recargar info pc"
echo -e "l: login SSH    q: salir"
echo ""

    stty raw; stty -echo
    keycode=`dd bs=1 count=1 2>/dev/null`
    stty "$stty_state"


    case $keycode in
        "A")    #echo "ARRIBA"
                let pos=$i*10+$j
                var[$pos]=${ori[$pos]}
                if [ $i -eq 4 ]; then
                    i=1
                    let pos=$i*10+$j
                    var[$pos]=$(echo ${var[$pos]} | sed "s/e.[0-9]*[;][0-9]*[;]/e[7;1;/")
                else
                    let i=$i+1
                    let pos=$i*10+$j
                    var[$pos]=$(echo ${var[$pos]} | sed "s/e.[0-9]*[;][0-9]*[;]/e[7;1;/")
                fi
                ;;
        "B")    #echo "ABAJO"
                let pos=$i*10+$j
                var[$pos]=${ori[$pos]}
                if [ $i -eq 1 ]; then
                    i=4
                    let pos=$i*10+$j
                    var[$pos]=$(echo ${var[$pos]} | sed "s/e.[0-9]*[;][0-9]*[;]/e[7;1;/")
                else
                    let i=$i-1
                    let pos=$i*10+$j
                    var[$pos]=$(echo ${var[$pos]} | sed "s/e.[0-9]*[;][0-9]*[;]/e[7;1;/")
                fi
                ;;
        "C")    #echo "DERECHA"
                let pos=$i*10+$j
                var[$pos]=${ori[$pos]}
                if [ $j -eq 9 ]; then
                    j=0
                    let pos=$i*10+$j
                    var[$pos]=$(echo ${var[$pos]} | sed "s/e.[0-9]*[;][0-9]*[;]/e[7;1;/")
                else
                    let j=$j+1
                    let pos=$i*10+$j
                    var[$pos]=$(echo ${var[$pos]} | sed "s/e.[0-9]*[;][0-9]*[;]/e[7;1;/")
                fi
                ;;
        "D")    #echo "IZQUIERDA"
                let pos=$i*10+$j
                var[$pos]=${ori[$pos]}
                if [ $j -eq 0 ]; then
                    j=9
                    let pos=$i*10+$j
                    var[$pos]=$(echo ${var[$pos]} | sed "s/e.[0-9]*[;][0-9]*[;]/e[7;1;/")
                else
                    let j=$j-1
                    let pos=$i*10+$j
                    var[$pos]=$(echo ${var[$pos]} | sed "s/e.[0-9]*[;][0-9]*[;]/e[7;1;/")
                fi
                ;;
        "R")    #echo "RELOAD"
		#rm tmp/estado_lds*
		clear
		rm tmp/usuarios_lds*
		load
                sleep 2 
		info "lds-pc10" 10
		copiar_estados
		reset_pos
		#make_primos_great_again
                ;;
        "p")    #echo "RELOAD PC"
                let pos=$i*10+$j
                id=$pos
                pc="lds-pc$id"
		info $pc $id
                copiar_estados
                var[$pos]=$(echo ${var[$pos]} | sed "s/e.[0-9]*[;][0-9]*[;]/e[7;1;/")
		#make_primos_great_again
                ;;
	"l")	echo "Ingresando por SSH"
		id=$pos
		ssh root@lds-pc$id
		;;
        "q")    rm tmp/usuarios_lds* 2>/dev/null
		rm tmp/estado_lds* 2>/dev/null
		exit;;
    esac
done

