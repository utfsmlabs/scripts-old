#!/bin/bash

if [ $# -lt 2  ]; then
    echo "Usar: $0 pc:/ruta lista_pc"
    echo "Ejemplo:"
    echo "$0 lpa-pc10:~/caca.file pcs/lpa"
    exit 0
fi

if [ ! -f $2 ]; then
    echo "'$2' Debe ser un archivo!"
    exit 0
fi

if [ $# -ge 3 ]; then
    debug=$3
else
    debug="NADA"
fi

original=$(echo $1 | sed 's/[:].*$//')

if [ -f ./tmp/SSHerror ]; then
    rm ./tmp/SSHerror
fi

touch ./tmp/SSHerror

if [ "x$(ssh root@$original "who | grep  NUNCA_APARECERECE" 2>./tmp/SSHerror;cat ./tmp/SSHerror)" != "x" ]; then
    echo "No se pudo establecer una conexion SSH con '$original'"
    exit 0
fi

ruta=$(echo $1 | sed 's/^.*[:]//')
if [ "x$(ssh root@$original "ls $ruta 2>/dev/null")" == "x" ]; then
    echo "La ruta '$ruta' en '$original' no existe o algo parecido..."
    exit 0
fi

if [ "x$(echo $ruta | grep '/$')" == "x" ]; then
    probRuta=$(echo $ruta | sed 's/$/\//')
    if [ "x$(ssh root@$original "ls $probRuta 2>/dev/null")" != "x" ]; then
        ruta=$probRuta
    fi
fi

let cont=0
libres="./tmp/libres"
uso="./tmp/uso"
faltan="./tmp/faltan"
error="./tmp/error"
copiados="./tmp/exzito"
#mutex="./tmp/mutex"

rm $libres 2>/dev/null
rm $uso 2>/dev/null
rm $faltan 2>/dev/null
rm $error 2>/dev/null
rm $copiados 2>/dev/null
#rm $mutex 2>/dev/null
rm tmp/l*__*l 2>/dev/null

touch $libres
touch $uso
touch $faltan
touch $error
touch $copiados
#echo 1 > $mutex

cat $2 | grep -v $original > $faltan
echo $original > $libres

contador="./tmp/contador"

rm $contador 2>/dev/null
touch $contador


for pid in $(ps aux | grep ssh.*rsync | awk '{print $2}')
do
    echo $pid
    kill -9 $pid
done

cont_suma(){
    #while [ $(cat $mutex) -eq 0 ]
    #do
        #sleep $(($RANDOM%3+1))
    #    echo "SUMA-----------------------------------------------------------------------------------------------------------" 
    #done

    #echo 0 > $mutex
        echo "$(cat $contador)|" > $contador
    #echo 1 > $mutex
}

cont_resta(){
    #while [ $(cat $mutex) -eq 0 ]
    #do
        #sleep $(($RANDOM%3+1))
    #    echo "RESTA-----------------------------------------------------------------------------------------------------------"
    #done
    
    #echo 0 > $mutex
    temp="$(cat $contador | sed 's/[|]$//')"
    echo $temp > $contador
    #echo 1 > $mutex
}

rsynquear(){
    cont_suma
    rm ./tmp/$1_error 2>/dev/null
    touch ./tmp/$1_error 2>/dev/null
    continuar="si"
    if  [ $debug == "-debug" ]; then
        echo "probando1 $1"
    fi

    if [ "x$(ssh root@$1 "who | grep NUNCA_APARECERE" 2>./tmp/$1_error;cat ./tmp/$1_error;rm ./tmp/$1_error)" != "x" ]; then
        cat $uso | grep -v $1 > $uso
        echo $1 >> $error
        echo $2 >> $faltan
        continuar="no"
        echo "$1 cago"
    fi
    rm ./tmp/$2_error 2>/dev/null
    touch ./tmp/$2_error 2>/dev/null
    if [ $debug == "-debug" ]; then
        echo "probando2 $2"
    fi
    if [ "x$(ssh root@$2 "who | grep NUNCA_APARECERE" 2>./tmp/$2_error;cat ./tmp/$2_error;rm ./tmp/$2_error)" != "x" ]; then
        cat $uso | grep -v $2 > $uso
        echo $2 >> $error
        echo $1 >> $libres
        continuar="no"
        echo "$2 cago"
    fi
    
    if [ $continuar == "si" ];then
        ##asdfas
        if  [ $debug == "-debug" ]; then
            echo "weon cuidao voy!! a rsynquear del $1 al $2"
        fi
        touch ./tmp/$1__$2
        if [ "x$(ssh root@$1 "rsync -a $ruta root@$2:$ruta" 2>./tmp/$1__$2  && ssh root@$1 "rsync -a --del $ruta root@$2:$ruta" 2>>./tmp/$1__$2;cat ./tmp/$1__$2)" == "x" ]; then
            #ssh root@$1 "rsync -a --del $ruta root@$2:$ruta"  #para borrar los temporales del rsync
            cat $uso | grep -v $1 | grep -v $2 > $uso
            echo $1 >> $libres
            echo $2 >> $libres
            echo $2 >> $copiados
            if  [ $debug != "-debug" ]; then
                rm ./tmp/$1__$2
            fi
        else
            cat $uso | grep -v $1 | grep -v $2 > $uso
            echo $1 >> $libres
            echo $2 >> $error
        fi
    else
        cat $uso | grep -v $1 | grep -v $2 > $uso
        echo "error desde $1 hacia $2"
    fi
   cont_resta 
   #echo "OOOAAA${cont}AAAOOO"
}
        echo "---LIBRES---"
        cat $libres
        echo "---USO---"
        cat $uso
        echo "---ERROR---"
        cat $error
        echo "---LISTA---"
        cat $faltan

inicio=1

total=$(wc -l $faltan | awk '{print $1}')

while [ "x$(cat $faltan)" != "x" ] && [ $inicio ] || [ "x$(cat $uso)" != "x" ] || [ "x$(cat $contador)" != "x" ]
do
    if [ "x$(cat $libres)" != "x" ] && [ "x$(cat $faltan)" != "x" ]; then
            pc=$(tail -n 1 $libres)
            destino=$(tail -n 1 $faltan)
            cat $libres | grep -v $pc > tmp/putazoooLIBRE
            cat tmp/putazoooLIBRE > $libres
            cat $faltan | grep -v $destino > tmp/putazooo
            cat tmp/putazooo > $faltan
        echo $pc >> $uso
        echo $destino >> $uso
        rsynquear $pc $destino &
    fi
        sleep 1
        clear
        if [ $debug == "-debug" ]; then
            echo "---LIBRES---"
            cat $libres
            echo "---USO---"
            cat $uso
        fi
        echo "rsynqueos simultaneos: $(cat $contador)"
        echo "---LISTA 10 siguientes----"
        tail $faltan
        echo "---ERROR---"
        cat $error
        
    
    
    let otro_total=$(wc -l $error | awk '{print $1}')+$(wc -l $copiados | awk '{print $1}')
   # if [ $debug == "-debug" ]; then
   # fi
    
   echo "TOTAL: $total - lib $(wc -l $libres | awk '{print $1}') - uso $(wc -l $uso | awk '{print $1}') - err $(wc -l $error | awk '{print $1}') - copy $(wc -l $copiados | awk '{print $1}')"
   ps aux | grep rsync | grep -v "grep"
    if [ $total -eq $otro_total ]; then
        break;
    fi
done

sleep 5
echo "me sali!!!!!!"
        if [ $debug == "-debug" ]; then
            echo "---LIBRES---"
            cat $libres
            echo "---LISTA---"
            cat $faltan
            echo "---USO---"
            cat $uso
        fi
        echo "---COPIADOS---"
        cat $copiados
        echo "---ERROR---"
        cat $error
        
            #echo "Contador, no deberia salir ninguna barrita: $(cat $contador)"
